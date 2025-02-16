import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineclothingstoreapp/BrandFormPage.dart';
import 'package:onlineclothingstoreapp/CategoryFormPage.dart';
import 'package:onlineclothingstoreapp/DetailPage.dart';
import 'package:onlineclothingstoreapp/ProductFormPage.dart';
import 'package:onlineclothingstoreapp/UserFormPage.dart';
import 'package:onlineclothingstoreapp/api/BrandApi.dart';
import 'package:onlineclothingstoreapp/api/CategoryApi.dart';
import 'package:onlineclothingstoreapp/api/OrderApi.dart';
import 'package:onlineclothingstoreapp/api/ProductApi.dart';
import 'package:onlineclothingstoreapp/api/UserApi.dart';

class AdminListPage extends StatefulWidget {
  @override
  State<AdminListPage> createState() => _AdminListPageState();

  String? listType;

  AdminListPage({required String listType})
  {
    this.listType=listType;
  }
}

class _AdminListPageState extends State<AdminListPage> {
  var listType;

  @override
  void initState()
  {
    super.initState();

    this.listType=widget.listType;
  }

  Future<dynamic> listData() async
  {
    var fun;

    switch(this.listType){
      case "Category" : fun = CategoryApi().getCategories();
        break;
      case "Brand" : fun = BrandApi().getBrands();
        break;
      case "Product" : fun = ProductApi().getProducts();
        break;
      case "User" : fun = UserApi().getUsers();
        break;
      case "Order" : fun = OrderApi().getOrders();
        break;
    }

    return fun;
  }

  void refreshItems() {
    setState(() {

    });
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
        title: Text(listType+" List"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: listType!="Order"?IconButton(
              onPressed: () {
                var FormPage;

                switch(this.listType){
                  case "Category" : FormPage = CategoryFormPage(category: null,);
                      break;
                  case "Brand" : FormPage = BrandFormPage(brand: null,);
                      break;
                  case "Product" : FormPage = ProductFormPage(product: null,);
                      break;
                  case "User" : FormPage = UserFormPage(user: null,);
                      break;
                }

                if(listType!="Order"){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FormPage,))
                      .then((value) {
                    if(value){
                      setState(() {

                      });
                    }
                  }
                  );
                }
              },
              icon: Icon(Icons.add, color: Colors.white),
            ):Text(""),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 10),
          child: FutureBuilder(
              future: listData(),
              builder: (context, snapshot) {
                if(snapshot.hasError){
                  return Center(
                      child: Text("Error occured : "+snapshot.error.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      )
                  );
                }

                if(snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    var items = snapshot.data!;

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: items.length,
                      itemBuilder: (context, index) {

                        if(listType=="Category"){
                          return Category(category: items[index], onDelete: refreshItems);
                        }
                        else if(listType=="Brand"){
                          return Brand(brand: items[index], onDelete: refreshItems);
                        }
                        else if(listType=="Product"){
                          return Product(product: items[index], onDelete: refreshItems);
                        }
                        else if(listType=="User"){
                          return User(user: items[index], onDelete: refreshItems);
                        }
                        else if(listType=="Order"){
                          return Order(order: items[index], onDelete: refreshItems);
                        }
                      },
                    );
                  }

                  else {
                    return Center(
                        child: Text("No Data Avalaible......",
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
              }

          ),
        ),
      ),
    );
  }
}

class Category extends StatefulWidget {
  Map<String, dynamic> category=new Map();
  VoidCallback onDelete;

  Category({
    required this.category,
    required this.onDelete
  });

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black87,
      surfaceTintColor: Colors.purple.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.category['categoryName'],
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.brown.shade700,
                        fontWeight: FontWeight.bold
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(widget.category['description'], style: TextStyle(color: Colors.grey))
                ],
              ),
            ),
            Column(
              children: [
                IconButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryFormPage(category: widget.category),))
                      .then((value) {
                    if(value){
                      setState(() {

                      });
                    }
                  }
                  );
                }, icon: Container(
                  child: Icon(Icons.edit_note_outlined, color: Colors.green,),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green,width: 2),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  padding: EdgeInsets.all(5),
                )
                ),
                IconButton(
                  onPressed: () async {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text("DELETE!!", style: TextStyle(color: Colors.red)),
                          content: Text("Are you sure, you want to delete this data?"),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context); // Close the confirmation dialog first

                                bool isDeleted = await CategoryApi().deleteCategory(widget.category['categoryId'].toString());

                                bool? result = await showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                        isDeleted ? "SUCCESS!!" : "FAILURE!!",
                                        style: TextStyle(color: isDeleted ? Colors.green : Colors.red),
                                      ),
                                      content: Text(
                                        isDeleted
                                            ? "Data deleted successfully!!"
                                            : "Deletion failed!! Try again!!",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context,true);
                                          },
                                          child: Text("OK"),
                                        )
                                      ],
                                    );
                                  },
                                );

                                if (result == true) {
                                  widget.onDelete(); // Refresh the UI
                                }

                              },
                              child: Text("Yes"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("No"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}

class Brand extends StatefulWidget {
  Map<String, dynamic> brand=new Map();
  VoidCallback onDelete;

  Brand({
    required this.brand,
    required this.onDelete
  });

  @override
  State<Brand> createState() => _BrandState();
}

class _BrandState extends State<Brand> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black87,
      surfaceTintColor: Colors.purple.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.brand['brandName'],
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.brown.shade700,
                        fontWeight: FontWeight.bold
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(widget.brand['description'], style: TextStyle(color: Colors.grey))
                ],
              ),
            ),
            Column(
              children: [
                IconButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BrandFormPage(brand: widget.brand),))
                      .then((value) {
                    if(value){
                      setState(() {

                      });
                    }
                  }
                  );
                }, icon: Container(
                  child: Icon(Icons.edit_note_outlined, color: Colors.green,),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green,width: 2),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  padding: EdgeInsets.all(5),
                )
                ),
                IconButton(
                  onPressed: () async {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text("DELETE!!", style: TextStyle(color: Colors.red)),
                          content: Text("Are you sure, you want to delete this data?"),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context); // Close the confirmation dialog first

                                bool isDeleted = await BrandApi().deleteBrand(widget.brand['brandId'].toString());

                                bool? result = await showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                        isDeleted ? "SUCCESS!!" : "FAILURE!!",
                                        style: TextStyle(color: isDeleted ? Colors.green : Colors.red),
                                      ),
                                      content: Text(
                                        isDeleted
                                            ? "Data deleted successfully!!"
                                            : "Deletion failed!! Try again!!",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context,true);
                                          },
                                          child: Text("OK"),
                                        )
                                      ],
                                    );
                                  },
                                );

                                if (result == true) {
                                  widget.onDelete(); // Refresh the UI
                                }

                              },
                              child: Text("Yes"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("No"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}

class Product extends StatefulWidget {
  Map<String, dynamic> product=new Map();
  VoidCallback onDelete;

  Product({
    required this.product,
    required this.onDelete
  });

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black87,
      surfaceTintColor: Colors.purple.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.product['imgUrl'],
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.2,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product['productName'],
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.brown.shade700,
                        fontWeight: FontWeight.bold
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(widget.product['description'], style: TextStyle(color: Colors.grey))
                ],
              ),
            ),
            Column(
              children: [
                IconButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductFormPage(product: widget.product),))
                      .then((value) {
                    if(value){
                      setState(() {

                      });
                    }
                  }
                  );
                }, icon: Container(
                  child: Icon(Icons.edit_note_outlined, color: Colors.green,),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green,width: 2),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  padding: EdgeInsets.all(5),
                )
                ),
                IconButton(
                  onPressed: () async {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text("DELETE!!", style: TextStyle(color: Colors.red)),
                          content: Text("Are you sure, you want to delete this data?"),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context); // Close the confirmation dialog first

                                bool isDeleted = await ProductApi().deleteProduct(widget.product['productID'].toString());

                                bool? result = await showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                        isDeleted ? "SUCCESS!!" : "FAILURE!!",
                                        style: TextStyle(color: isDeleted ? Colors.green : Colors.red),
                                      ),
                                      content: Text(
                                        isDeleted
                                            ? "Data deleted successfully!!"
                                            : "Deletion failed!! Try again!!",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context,true);
                                          },
                                          child: Text("OK"),
                                        )
                                      ],
                                    );
                                  },
                                );

                                if (result == true) {
                                  widget.onDelete(); // Refresh the UI
                                }

                              },
                              child: Text("Yes"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("No"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}

class User extends StatefulWidget {
  Map<String, dynamic> user=new Map();
  VoidCallback onDelete;

  User({
    required this.user,
    required this.onDelete
  });

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black87,
      surfaceTintColor: Colors.purple.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.user['userName'],
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.brown.shade700,
                        fontWeight: FontWeight.bold
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(widget.user['email'], style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 5),
                  Text(widget.user['contactNo'], style: TextStyle(color: Colors.grey))
                ],
              ),
            ),
            Column(
              children: [
                IconButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserFormPage(user: widget.user),))
                      .then((value) {
                    if(value){
                      setState(() {

                      });
                    }
                  }
                  );
                }, icon: Container(
                  child: Icon(Icons.edit_note_outlined, color: Colors.green,),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green,width: 2),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  padding: EdgeInsets.all(5),
                )
                ),
                IconButton(
                  onPressed: () async {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text("DELETE!!", style: TextStyle(color: Colors.red)),
                          content: Text("Are you sure, you want to delete this data?"),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context); // Close the confirmation dialog first

                                bool isDeleted = await UserApi().deleteUser(widget.user['userID'].toString());

                                bool? result = await showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                        isDeleted ? "SUCCESS!!" : "FAILURE!!",
                                        style: TextStyle(color: isDeleted ? Colors.green : Colors.red),
                                      ),
                                      content: Text(
                                        isDeleted
                                            ? "Data deleted successfully!!"
                                            : "Deletion failed!! Try again!!",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context,true);
                                          },
                                          child: Text("OK"),
                                        )
                                      ],
                                    );
                                  },
                                );

                                if (result == true) {
                                  widget.onDelete(); // Refresh the UI
                                }

                              },
                              child: Text("Yes"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("No"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}

class Order extends StatefulWidget {
  Map<String, dynamic> order=new Map();
  VoidCallback onDelete;

  Order({
    required this.order,
    required this.onDelete
  });

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black87,
      surfaceTintColor: Colors.purple.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.order['productName'],
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.brown.shade700,
                        fontWeight: FontWeight.bold
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(widget.order['userName'], style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 5),
                  Text("Quantity : "+widget.order['quantity'].toString(), style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 5),
                  Text("Total Amount : \u{20B9}"+widget.order['totalAmount'].toString(), style: TextStyle(color: Colors.grey))
                ],
              ),
            ),
            Column(
              children: [
                IconButton(onPressed: () async {
                  var product=await ProductApi().getProductByProductID(widget.order['productID']);

                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(product: product,loggedUserID:
                      widget.order['userID'],order: widget.order),))
                      .then((value) {
                    if(value){
                      setState(() {

                      });
                    }
                  }
                  );
                }, icon: Container(
                  child: Icon(Icons.edit_note_outlined, color: Colors.green,),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green,width: 2),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  padding: EdgeInsets.all(5),
                )
                ),
                IconButton(
                  onPressed: () async {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text("DELETE!!", style: TextStyle(color: Colors.red)),
                          content: Text("Are you sure, you want to delete this data?"),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context); // Close the confirmation dialog first

                                bool isDeleted = await OrderApi().deleteOrder(widget.order['orderID'].toString());

                                bool? result = await showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                        isDeleted ? "SUCCESS!!" : "FAILURE!!",
                                        style: TextStyle(color: isDeleted ? Colors.green : Colors.red),
                                      ),
                                      content: Text(
                                        isDeleted
                                            ? "Data deleted successfully!!"
                                            : "Deletion failed!! Try again!!",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context,true);
                                          },
                                          child: Text("OK"),
                                        )
                                      ],
                                    );
                                  },
                                );

                                if (result == true) {
                                  widget.onDelete(); // Refresh the UI
                                }

                              },
                              child: Text("Yes"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("No"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}