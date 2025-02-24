import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineclothingstoreapp/AdminListPage.dart';
import 'package:onlineclothingstoreapp/CartPage.dart';
import 'package:onlineclothingstoreapp/CategoryFormPage.dart';
import 'package:onlineclothingstoreapp/DashboardPage.dart';
import 'package:onlineclothingstoreapp/DetailPage.dart';
import 'package:onlineclothingstoreapp/FavouritePage.dart';
import 'package:onlineclothingstoreapp/ProductListPage.dart';
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

  var imgList=[
    "https://i.mdel.net/i/db/2017/7/728816/728816-800w.jpg",
    "https://images.unsplash.com/photo-1575936123452-b67c3203c357?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D",
    "https://www.shutterstock.com/image-photo/stylish-man-wearing-sunglasses-white-260nw-1562565541.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDY828-ftxjCNjjY9II8r2LCDdBTCsF3ntp2aVGZPViVLx6zPOl-A9DObcI89oVDyiG7s&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRORIqjGDpr-_rGWoFSWCK4AAgbfeyASupPA&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTI0K8WemfmhTsQOVq8jJnnWCTMNoH5G6LYvA&usqp=CAU",
    "https://st.depositphotos.com/1003840/1806/i/450/depositphotos_18067151-stock-photo-young-woman-in-casual-clothes.jpg"
  ];

  var carousalController=new CarouselController();
  var currentSlide=0;

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
                flex: 5,
                child: Container(
                  child:Column(
                      children: [
                        Expanded(
                          child: CarouselSlider(
                            carouselController: carousalController,
                            options: CarouselOptions(
                              enableInfiniteScroll: true,
                              viewportFraction: 1,
                              enlargeCenterPage: true,
                              enlargeFactor: 10,
                              autoPlay: true,
                              autoPlayAnimationDuration: Duration(seconds: 1),
                              autoPlayInterval: Duration(seconds: 2),
                              autoPlayCurve: Easing.linear,
                              pauseAutoPlayInFiniteScroll: false,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentSlide=index;
                                });
                              },
                            ),
                            items: imgList.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    child: ClipRRect(
                                      child: Image.network(i,
                                        fit: BoxFit.fill,
                                        width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height*0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: imgList.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () => carousalController.animateToPage(entry.key),
                              child: Container(
                                  width: MediaQuery.of(context).size.width*0.015,
                                  height: MediaQuery.of(context).size.height*0.015,
                                  margin: EdgeInsets.symmetric(horizontal: 2,vertical: 2),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.amber.withOpacity(currentSlide == entry.key ? 0.9 : 0.4))
                              ),
                            );
                          }).toList(),
                        )
                      ]
                  ),
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                ),
              ),
              Expanded(
                child: Container(
                  child: Text("Brands Recommended for you",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height*0.025,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(20, 0, 10, 10),
                ),
              ),
              Expanded(
                  flex: 4,
                  child: FutureBuilder<List<dynamic>>(
                    future: BrandApi().getBrands(),
                    builder: (context, snapshot) {
                        if(snapshot.hasData){
                        return Container(
                          child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductListPage(loggedUserId: loggedUserId,BrandID: snapshot.data![index]['brandId'],CategoryID: 0,),));
                                  },
                                  child: Container(
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
                                  ),
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
              ),
              SizedBox(height: 10,),
              Expanded(
                child: Container(
                  child: Text("Categories",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height*0.025,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
                ),
              ),
              Expanded(
                flex: 5,
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
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 2,
                          ),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  categoryName=categories[index]['categoryName'].toString();
                                  categoryID=categories[index]['categoryId'];
                                });
                                
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ProductListPage(loggedUserId: loggedUserId,CategoryID: categories[index]['categoryId'],),));
                              },
                              child: Container(
                                child: Text(categories[index]['categoryName'].toString(),
                                  style: TextStyle(
                                      color: categoryName==categories[index]['categoryName'].toString()?Colors.white:Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context).size.height*0.018,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
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
              SizedBox(height: 20,)
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
              leading: Icon(Icons.dashboard_outlined),
              title: Text("Dashboard"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardPage(),));
              },
            ),
            Divider(),
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