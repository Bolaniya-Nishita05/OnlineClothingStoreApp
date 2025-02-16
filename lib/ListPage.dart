import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineclothingstoreapp/AdminListPage.dart';
import 'package:onlineclothingstoreapp/CartPage.dart';
import 'package:onlineclothingstoreapp/CategoryFormPage.dart';
import 'package:onlineclothingstoreapp/DetailPage.dart';
import 'package:onlineclothingstoreapp/FavouritePage.dart';
import 'package:onlineclothingstoreapp/ProfilePage.dart';
import 'package:onlineclothingstoreapp/api/BrandApi.dart';
import 'package:onlineclothingstoreapp/api/CategoryApi.dart';
import 'package:onlineclothingstoreapp/api/ProductApi.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ListPage extends StatefulWidget
{
  @override
  State<ListPage> createState() => _ListPageState();

  int? loggedUserId;

  ListPage(int loggedUserId)
  {
    this.loggedUserId=loggedUserId;
  }
}

class _ListPageState extends State<ListPage> {
  var name=new TextEditingController();
  var categoryID,categoryName;
  var selectedIndex=0;
  var loggedUserId;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState()
  {
    super.initState();

    this.loggedUserId=widget.loggedUserId;

    categoryName="All";
    categoryID=0;
  }

  Future<List<dynamic>> renderProducts(int CategoryID)
  {
    return CategoryID==0?ProductApi().getProducts():ProductApi().getProductsByCategoryID(CategoryID);
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu_open_rounded, color: Colors.white),
            onPressed: () {
              if(loggedUserId==10){
                _scaffoldKey.currentState?.openDrawer();
              }
            },
          ),
          title: Text("Shop"),
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
              Expanded(
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
                                    categoryName=categories[index]['categoryName'].toString();
                                    categoryID=categories[index]['categoryId'];
                                  });
                                },
                                child: Container(
                                  child: Text(categories[index]['categoryName'].toString(),
                                    style: TextStyle(
                                        color: categoryName==categories[index]['categoryName'].toString()?Colors.white:Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  margin: index==0?EdgeInsets.fromLTRB(0,0,10,0):EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: categoryName==categories[index]['categoryName'].toString()
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
              ),
              Expanded(
                  flex: 4,
                  child: FutureBuilder(future: renderProducts(categoryID), builder: (context, snapshot) {
                    if(snapshot.hasData){
                      if(snapshot.data!.isNotEmpty){
                        return Padding(
                            padding: const EdgeInsets.all(20),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
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
                                    margin: index==0?EdgeInsets.fromLTRB(0,0,10,10):EdgeInsets.fromLTRB(10, 0, 10, 10),
                                    child: Container(
                                      child: Column(
                                          children: [
                                            ClipRRect(
                                              child: Image.network(
                                                snapshot.data![index]['imgUrl'].toString(),
                                                fit: BoxFit.fill,
                                                height: MediaQuery.of(context).size.height*0.2,
                                                width: MediaQuery.of(context).size.width*0.3,
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
                                            Row(
                                              children: [
                                                Container(
                                                  child: Text('\u{20B9}${snapshot.data![index]['price'].toString()}',
                                                    style: TextStyle(
                                                        color: Colors.orange.shade900,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                  width: MediaQuery.of(context).size.width*0.3,
                                                  padding: EdgeInsets.only(left:20),
                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    Map<String,dynamic> favourite = new Map();

                                                    // setState(() {
                                                    //   l2[index].isLiked=!l2[index].isLiked;
                                                    // });
                                                  },
                                                  child: Container(
                                                    child: Icon(
                                                      Icons.favorite_border_outlined,
                                                      color: Colors.orange.shade700,
                                                      size: 15,
                                                    ),
                                                    padding: EdgeInsets.only(right: 10),
                                                  ),
                                                )
                                              ],
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Expanded(
                child: Container(
                  child: Text("Brands Recommended for you",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(20, 0, 10, 10),
                ),
              ),
              Expanded(
                  flex: 5,
                  child: FutureBuilder<List<dynamic>>(
                    future: BrandApi().getBrands(),
                    builder: (context, snapshot) {
                        if(snapshot.hasData){
                        return Container(
                          child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Text(snapshot.data![index]['brandName'],
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.height*0.018,
                                              color: Colors.orange.shade700,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        width: MediaQuery.of(context).size.width,
                                      ),
                                      Container(
                                        child: Text(snapshot.data![index]['description'],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.height*0.018,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        width: MediaQuery.of(context).size.width,
                                      ),
                                    ],
                                  ),
                                  width: MediaQuery.of(context).size.width*0.2,
                                  margin: EdgeInsets.fromLTRB(20,0,20,10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(border: Border.all(
                                    color: Colors.black87,
                                    style: BorderStyle.solid,)),
                                );
                              },
                            ),
                        );
                        }
                        else{
                          return Center(child: CircularProgressIndicator(color: Colors.blueAccent,));
                        }
                      }
                    )
                  )
                ]
              ),
        ),
      ),
      drawer: Drawer(
        elevation: 50,
        shadowColor: Colors.brown,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: DrawerHeader(
                  decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.brown.shade900,Colors.brown.shade700,Colors.brown.shade500,Colors.brown.shade100],begin: Alignment.topLeft,tileMode: TileMode.clamp,)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage("https://images.unsplash.com/photo-1495344517868-8ebaf0a2044a?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8c2VhcmNofGVufDB8fDB8fHww"),
                        radius: 40,
                      ),
                      Text("JohnDoe",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 2)),
                      Text("john.doe@example.com",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 2)),
                    ],
                  )
              ),
            ),
            ListTile(
              leading: Icon(Icons.category_outlined),
              title: Text("Categories"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminListPage(listType: "Category"),));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.brightness_auto_outlined),
              title: Text("Brands"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminListPage(listType: "Brand"),));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.inventory_2_outlined),
              title: Text("Products"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminListPage(listType: "Product"),));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.account_box_outlined),
              title: Text("Users"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminListPage(listType: "User"),));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.list_alt),
              title: Text("Orders"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminListPage(listType: "Order"),));
              },
            ),
            Divider()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined,), label: "",tooltip: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined,), label: "",tooltip: "Details"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border,), label: "",tooltip: "Liked"),
          BottomNavigationBarItem(icon: Icon(Icons.perm_identity,), label: "",tooltip: "Profile"),
        ],
        showSelectedLabels: false,
        currentIndex: selectedIndex,
        selectedItemColor: Colors.amber.shade800,
        unselectedItemColor: Colors.grey.shade700,
        selectedIconTheme: IconThemeData(size: 35,),
        onTap: (value) {
          setState(() {
            selectedIndex=value;

            if (selectedIndex==1){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage(loggedUserId),))
                  .then((value) {
                    if(value){
                      setState(() {
                        selectedIndex=0;
                      });
                    }
                  }
                );
            }

            if (selectedIndex==2){
              Navigator.push(context, MaterialPageRoute(builder: (context) => FavouritePage(loggedUserId),))
                  .then((value) {
                if(value){
                  setState(() {
                    selectedIndex=0;
                  });
                }
              }
              );
            }

            if (selectedIndex==3){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(loggedUserId),))
                  .then((value) {
                    if(value){
                      setState(() {
                        selectedIndex=0;
                      });
                    }
                  }
                );
            }
          });
        },
      ),
    );
  }
}