import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineclothingstoreapp/api/categoryApi.dart';

class CategoryFormPage extends StatefulWidget
{
  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();

  Map<String, dynamic>? category;

  CategoryFormPage({Map<String, dynamic>? category}){
    if(category!=null){
      this.category=category;
    }
  }
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  var categoryName=new TextEditingController();
  var description=new TextEditingController();
  var isValid=true;

  var formKey=GlobalKey<FormState>();

  Map<String, dynamic> category=new Map();

  @override
  void initState(){
    super.initState();

    if(widget.category!=null){
      this.category=widget.category!;

      categoryName.text=this.category!["categoryName"];
      description.text=this.category!["description"];
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
        title: Text("Category Form"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.category_outlined, color: Colors.white),
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
                              child: TextFormField(controller: categoryName,
                                validator: (value) {
                                  if(value==""){
                                    return "Enter Category Name";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                                    errorStyle: TextStyle(fontSize: 15),
                                    labelText: "Enter Category Name",
                                    floatingLabelStyle: TextStyle(color: Colors.brown.shade700),
                                    hintText: "Category Name",
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
                            InkWell(
                              onTap: () async {
                                if(formKey.currentState!.validate()){
                                  this.category!['categoryId']=this.category['categoryId']??"5";
                                  this.category!['categoryName']=categoryName.text;
                                  this.category!['description']=description.text;

                                  var response = widget.category==null
                                      ? await CategoryApi().addCategory(this.category!)
                                      : await CategoryApi().updateCategory(this.category!, this.category!['categoryId']);

                                  if(response){
                                    showCupertinoDialog(context: context, builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: Text("SUCCESS!!",style: TextStyle(color: Colors.green),),
                                        content: Text("Category updated successfully!!"),
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
                        )
                    )
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