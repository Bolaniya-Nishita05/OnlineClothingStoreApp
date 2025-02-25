import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineclothingstoreapp/api/ProductApi.dart';
import 'package:onlineclothingstoreapp/api/categoryApi.dart';

class ProductFormPage extends StatefulWidget
{
  @override
  State<ProductFormPage> createState() => _ProductFormPageState();

  Map<String, dynamic>? product;

  ProductFormPage({Map<String, dynamic>? product}){
    if(product!=null){
      this.product=product;
    }
  }
}

class _ProductFormPageState extends State<ProductFormPage> {
  var productName=new TextEditingController();
  var description=new TextEditingController();
  int categoryID=0;
  int brandID=0;
  var price=new TextEditingController();
  var stockQuantity=new TextEditingController();
  var imgUrl=new TextEditingController();

  var isValid=true;

  var formKey=GlobalKey<FormState>();

  Map<String, dynamic> product=new Map();

  @override
  void initState(){
    super.initState();

    if(widget.product!=null){
      this.product=widget.product!;

      productName.text=this.product!["productName"];
      description.text=this.product!["description"];
      categoryID=this.product!["categoryID"];
      brandID=this.product!["brandID"];
      price.text=this.product!["price"].toString();
      stockQuantity.text=this.product!["stockQuantity"].toString();
      imgUrl.text=this.product!["imgUrl"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        title: Text("Product Form"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.production_quantity_limits, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        child: TextFormField(controller: productName,
                          validator: (value) {
                            if(value==""){
                              return "Enter Product Name";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                              errorStyle: TextStyle(fontSize: 15),
                              labelText: "Enter Product Name",
                              floatingLabelStyle: TextStyle(color: Colors.brown.shade700),
                              hintText: "Product Name",
                              prefixIcon: Icon(Icons.abc, color: Colors.brown.shade700)
                          ),
                        ),
                        margin: EdgeInsets.fromLTRB(20,10,20,10),
                      ),
                      Container(
                        child: TextFormField(controller: description,
                          validator: (value) {
                            if(value==""){
                              return "Enter Description";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                              errorStyle: TextStyle(fontSize: 15),
                              labelText: "Enter Description",
                              floatingLabelStyle: TextStyle(color: Colors.brown.shade700),
                              hintText: "Description",
                              prefixIcon: Icon(Icons.description_outlined, color: Colors.brown.shade700)
                          ),
                        ),
                        margin: EdgeInsets.fromLTRB(20,10,20,10),
                      ),
                      Container(
                        child: FutureBuilder(
                            future: ProductApi().getCategoriesDropDown(),
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                                var categories = [
                                  {'categoryId': 0, 'categoryName': "Select Category"},
                                  ...snapshot.data!
                                ];

                                return DropdownButtonFormField<int>(
                                  value: categoryID,
                                  items: categories.map((c) {
                                    return DropdownMenuItem<int>(
                                      value: c['categoryId'],
                                      child: Text(c['categoryName']),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      categoryID = newValue!;
                                    });
                                  },
                                  validator: (value){
                                    if(value==0){
                                      return "Select Category";
                                    }

                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                                      errorStyle: TextStyle(fontSize: 15),
                                      labelText: "Select Category",
                                      floatingLabelStyle: TextStyle(color: Colors.brown.shade700),
                                      hintText: "Category",
                                      prefixIcon: Icon(Icons.category_outlined, color: Colors.brown.shade700)
                                  ),
                                );
                              }

                              else {
                                return Text(snapshot.error.toString());
                              }
                            },
                        ),
                        margin: EdgeInsets.fromLTRB(20,10,20,10),
                      ),
                      Container(
                        child: FutureBuilder(
                          future: ProductApi().getBrandsDropDown(),
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                              var brands = [
                                {'brandId': 0, 'brandName': "Select Brand"},
                                ...snapshot.data!
                              ];

                              return DropdownButtonFormField<int>(
                                value: brandID,
                                items: brands.map((b) {
                                  return DropdownMenuItem<int>(
                                    value: b['brandId'],
                                    child: Text(b['brandName']),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    brandID = newValue!;
                                  });
                                },
                                validator: (value){
                                  if(value==0){
                                    return "Select Brand";
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                                    errorStyle: TextStyle(fontSize: 15),
                                    labelText: "Select Brand",
                                    floatingLabelStyle: TextStyle(color: Colors.brown.shade700),
                                    hintText: "Brand",
                                    prefixIcon: Icon(Icons.brightness_auto_outlined, color: Colors.brown.shade700)
                                ),
                              );
                            }

                            else {
                              return Text(snapshot.error.toString());
                            }
                          },
                        ),
                        margin: EdgeInsets.fromLTRB(20,10,20,10),
                      ),
                      Container(
                        child: TextFormField(controller: price,
                          validator: (value) {
                            RegExp priceRegex = RegExp(r'^-?\d+(\.\d+)?$');

                            if (value == null || value.isEmpty) {
                              return "Enter Price";
                            }
                            if (!priceRegex.hasMatch(value)) {
                              return "Enter valid price";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                              errorStyle: TextStyle(fontSize: 15),
                              labelText: "Enter Price",
                              floatingLabelStyle: TextStyle(color: Colors.brown.shade700),
                              hintText: "Price",
                              prefixIcon: Icon(Icons.monetization_on_outlined, color: Colors.brown.shade700)
                          ),
                        ),
                        margin: EdgeInsets.fromLTRB(20,10,20,10),
                      ),
                      Container(
                        child: TextFormField(controller: stockQuantity,
                          validator: (value) {
                            RegExp stockQuantityRegex = RegExp(r'^-?\d+$');

                            if (value == null || value.isEmpty) {
                              return "Enter Stock Quantity";
                            }
                            if (!stockQuantityRegex.hasMatch(value)) {
                              return "Enter valid stock quantity";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                              errorStyle: TextStyle(fontSize: 15),
                              labelText: "Enter Stock Quantity",
                              floatingLabelStyle: TextStyle(color: Colors.brown.shade700),
                              hintText: "Stock Quantity",
                              prefixIcon: Icon(Icons.production_quantity_limits_rounded, color: Colors.brown.shade700)
                          ),
                        ),
                        margin: EdgeInsets.fromLTRB(20,10,20,10),
                      ),
                      Container(
                        child: TextFormField(controller: imgUrl,
                          validator: (value) {
                            if(value==""){
                              return "Enter Image URL";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                              errorStyle: TextStyle(fontSize: 15),
                              labelText: "Enter Image URL",
                              floatingLabelStyle: TextStyle(color: Colors.brown.shade700),
                              hintText: "Image URL",
                              prefixIcon: Icon(Icons.image_outlined, color: Colors.brown.shade700)
                          ),
                        ),
                        margin: EdgeInsets.fromLTRB(20,10,20,10),
                      ),
                      InkWell(
                        onTap: () async {
                          if(formKey.currentState!.validate()){
                            this.product!['productID']=this.product!['productID'] ?? "5";
                            this.product!['productName'] = productName.text;
                            this.product!['description'] = description.text;
                            this.product!['categoryID'] = categoryID;
                            this.product!['brandID'] = brandID;
                            this.product!['price'] = double.parse(price.text);
                            this.product!['stockQuantity'] = int.parse(stockQuantity.text);
                            this.product!['imgUrl'] = imgUrl.text;

                            var response = widget.product==null
                                ? await ProductApi().addProduct(this.product!)
                                : await ProductApi().updateProduct(this.product!, this.product!['productID']);

                            if(response){
                              showCupertinoDialog(context: context, builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text("SUCCESS!!",style: TextStyle(color: Colors.green),),
                                  content: Text("Product updated successfully!!"),
                                  actions: [
                                    TextButton(onPressed: ()  {
                                      Navigator.pop(context);
                                      setState(() {
                                        Navigator.of(context).pop(true);
                                      });
                                    }, child: Text("Ok"))
                                  ],
                                );
                              },);
                            }

                            else{
                              showCupertinoDialog(context: context, builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text("FAILURE!!",style: TextStyle(color: Colors.red),),
                                  content: Text("Error occured!! Try Agan!!"),
                                  actions: [
                                    TextButton(onPressed: ()  {
                                      Navigator.pop(context);
                                      setState(() {
                                        Navigator.of(context).pop(true);
                                      });
                                    }, child: Text("Ok"))
                                  ],
                                );
                              },);
                            }
                          }

                          else{
                            setState(() {
                              isValid=false;
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(color: Colors.brown.shade700,borderRadius: BorderRadius.circular(20)),
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Center(
                            child: Text("SUBMIT",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.height*0.025
                              ),
                            ),
                          ),
                          margin: EdgeInsets.fromLTRB(20,50,20,10),
                        ),
                      ),
                      !isValid?Text("INVALID VALUES",
                        style: TextStyle(
                            color: Colors.red.shade900,
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                        ),
                      ):Text(""),
                    ],
                  ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ),
      ),
      backgroundColor: Colors.brown.shade50,
    );
  }
}