import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineclothingstoreapp/DetailPage.dart';
import 'package:onlineclothingstoreapp/api/CategoryApi.dart';
import 'package:onlineclothingstoreapp/api/ProductApi.dart';


class ProductListPage extends StatefulWidget
{
  @override
  State<ProductListPage> createState() => _ProductListPageState();

  int? loggedUserId;
  int? BrandID;
  int? CategoryID;

  ProductListPage({required int loggedUserId,int? BrandID,int? CategoryID})
  {
    this.loggedUserId=loggedUserId;
    this.BrandID=BrandID;
    this.CategoryID=CategoryID;
  }
}

class _ProductListPageState extends State<ProductListPage> {
  var name=new TextEditingController();
  var categoryID,categoryName;
  var selectedIndex=0;
  var loggedUserId;

  @override
  void initState()
  {
    super.initState();

    this.loggedUserId=widget.loggedUserId;

    categoryID=widget.CategoryID;
  }

  Future<List<dynamic>> renderProducts(int CategoryID)
  {
    if(widget.BrandID==null) {
      return CategoryID == 0 ? ProductApi().getProducts() : ProductApi()
          .getProductsByCategoryID(CategoryID);
    }
    else{
      return ProductApi().getProductsByBrandID(widget.BrandID!);
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
        title: Text("Products"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.shopping_cart, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 10),
          child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: TextField(
                      controller: name,
                      decoration: InputDecoration(
                          hintText: "Search Your Dress",
                          hintStyle: TextStyle(fontSize: 15,),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide(color: Colors.grey.shade500)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide(color: Colors.grey.shade700)
                          ),
                          prefixIcon: Icon(Icons.search,color: Colors.grey.shade700),
                          contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 0)
                      ),
                      cursorColor: Colors.grey.shade700,
                    ),
                    height: 30,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  ),
                ),
                widget.BrandID==null ? Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: CategoryApi().getCategories(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        var categories = [
                          {'categoryId': 0, 'categoryName': "All"},
                          ...snapshot.data!
                        ];

                        return Padding(
                          padding: EdgeInsets.fromLTRB(20,0,20,0),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    categoryID=categories[index]['categoryId'];
                                  });
                                },
                                child: Container(
                                  child: Text(categories[index]['categoryName'].toString(),
                                    style: TextStyle(
                                        color: categoryID==categories[index]['categoryId']?Colors.white:Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  margin: index==0?EdgeInsets.fromLTRB(0,0,10,0):EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: categoryID==categories[index]['categoryId']
                                        ?Colors.black87
                                        :Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      else{
                        return Center(child: CircularProgressIndicator(color: Colors.blueAccent,));
                      }
                    },
                  ),
                ) : Container(),
                SizedBox(height: 20,),
                Expanded(
                  flex: 10,
                  child: FutureBuilder(future: renderProducts(categoryID), builder: (context, snapshot) {
                    if(snapshot.hasData){
                      if(snapshot.data!.isNotEmpty){
                        return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                childAspectRatio: 0.7,
                              ),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(product: snapshot.data![index], loggedUserID: this.loggedUserId,),))
                                        .then((value) {
                                      if(value==true){
                                        setState(() {

                                        });
                                      }
                                    }
                                    );
                                  },
                                  child: Card(
                                    elevation: 15,
                                    shadowColor: Colors.black87,
                                    surfaceTintColor: Colors.purple.shade100,
                                    child: Container(
                                      child: Column(
                                          children: [
                                            ClipRRect(
                                              child: Image.network(
                                                snapshot.data![index]['imgUrl'].toString(),
                                                fit: BoxFit.fill,
                                                height: MediaQuery.of(context).size.height*0.18,
                                                width: MediaQuery.of(context).size.width,
                                              ),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            Container(
                                              child: Text(snapshot.data![index]['productName'].toString(),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.brown.shade700,
                                                    fontWeight: FontWeight.bold
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              width: MediaQuery.of(context).size.width*0.3,
                                              margin: EdgeInsets.only(left: 10),
                                            ),
                                            Container(
                                              child: Text('\u{20B9}${snapshot.data![index]['price'].toString()}',
                                                style: TextStyle(
                                                    color: Colors.orange.shade900,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              width: MediaQuery.of(context).size.width*0.3,
                                              margin: EdgeInsets.only(left:10),
                                            ),
                                          ]
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                        );
                      }

                      else {
                        return Center(
                            child: Text("Product List is Empty......",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                  fontSize: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.02
                              ),
                            )
                        );
                      }
                    }
                    else{
                      return Center(child: CircularProgressIndicator(color: Colors.blueAccent,));
                    }
                  },),
                ),
                SizedBox(height: 20,)
              ]
          ),
        ),
      ),
    );
  }
}