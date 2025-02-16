import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineclothingstoreapp/LoginPage.dart';
import 'package:onlineclothingstoreapp/UserFormPage.dart';
import 'package:onlineclothingstoreapp/api/UserApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerList {
  String imgUrl = "";
  String name = "";
  bool isLiked=true;

  VerList(String imgUrl, String name) {
    this.imgUrl = imgUrl;
    this.name=name;
  }
}

class ProfilePage extends StatefulWidget
{
  @override
  State<ProfilePage> createState() => _ProfilePageState();

  int? loggedUserId;

  ProfilePage(int? loggedUserId)
  {
    this.loggedUserId=loggedUserId;
  }
}

class _ProfilePageState extends State<ProfilePage> {
  List<VerList> l=[
    VerList("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRORIqjGDpr-_rGWoFSWCK4AAgbfeyASupPA&usqp=CAU", "Cropped t-shirt"),
    VerList("https://www.nextdirect.com/nxtcms/resource/blob/5821518/d114a8023263017f86b11c206949508e/shackets-data.jpg", "Brown Vest"),
    VerList("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7iPisjeQDmDZOHy1_i9-xfID9ysXay1Hstx6kgtnvpXFJPz276yjImJg-Zqch7RQaAI0&usqp=CAU", "Black Blazer"),
    VerList("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTI0K8WemfmhTsQOVq8jJnnWCTMNoH5G6LYvA&usqp=CAU", "Cropped t-shirt"),
    VerList("https://www.shutterstock.com/image-photo/stylish-man-wearing-sunglasses-white-260nw-1562565541.jpg", "Brown Vest"),
    VerList("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDY828-ftxjCNjjY9II8r2LCDdBTCsF3ntp2aVGZPViVLx6zPOl-A9DObcI89oVDyiG7s&usqp=CAU", "Black Blazer"),
    VerList("https://st.depositphotos.com/1003840/1806/i/450/depositphotos_18067151-stock-photo-young-woman-in-casual-clothes.jpg", "Black Blazer"),
  ];

  var loggedUserId;
  Map<String,dynamic> user=new Map();

  @override
  void initState(){
    super.initState();

    this.loggedUserId=widget.loggedUserId;
  }

  Future<void> logout() async {
    SharedPreferences pref=await SharedPreferences.getInstance();

    pref.remove("UserID");
    pref.remove("Username");
    pref.remove("Password");
    pref.remove("Remember");
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
        title: Text("My Profile"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: InkWell(
                onTap: () {
                  showCupertinoDialog(context: context, builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text("LOG OUT"),
                      content: Text("ARE YOU SURE, YOU WANT TO LOGOUT????"),
                      actions: [
                        TextButton(onPressed: ()  {
                          logout();
                          Navigator.pop(context);
                          setState(() {
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage(),),(route) => false);
                          });
                        }, child: Text("Logout")),
                        TextButton(onPressed: () {
                          Navigator.pop(context);
                        }, child: Text("Cancel"))
                      ],
                    );
                  },);
                },
                child: Icon(Icons.logout_outlined, color: Colors.white)
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 10),
          child: FutureBuilder(
            future: UserApi().getUserByUserID(loggedUserId),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                this.user=snapshot.data!;

                return Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfi3OLFaf3CmUs8kdqX1RHbR5uo2LupG6Gvah4V6YWBgYebRy4LjiNqtbz5qFEmPxRw8Y&usqp=CAU",
                            fit: BoxFit.fill,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container()
                        ),
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              Container(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.amber.shade800,
                                      radius: MediaQuery.of(context).size.height*0.065,
                                    ),
                                    CircleAvatar(
                                      radius: MediaQuery.of(context).size.height*0.06,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage("https://images.unsplash.com/photo-1575936123452-b67c3203c357?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D"),
                                        radius: MediaQuery.of(context).size.height*0.055,
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(100)),
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.fromLTRB(120, 0, 120, 0),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Text(user['userName'],
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.height*0.02,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(user['email'],
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.height*0.02,
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(Icons.location_on_rounded,color: Colors.grey.shade700,),
                                          Text("Rajkot,India",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.height*0.02,
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.w600
                                            ),
                                          )
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserFormPage(user: user,),))
                                        .then((value) {
                                            setState(() {

                                            });
                                          }
                                        );
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(color: Colors.black87,borderRadius: BorderRadius.circular(10)),
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                      child: Text("Edit Details",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: MediaQuery.of(context).size.height*0.02
                                        ),
                                      ),
                                    ),
                                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text("400",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.height*0.025,
                                                color: Colors.amber.shade800,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Text("Liked\nItems",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.height*0.015,
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.bold
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text("\₹4000",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.height*0.025,
                                                color: Colors.amber.shade800,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Text("Balance\nRemaining",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.height*0.015,
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.bold
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text("50",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.height*0.025,
                                                color: Colors.amber.shade800,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Text("Items\nPurchased",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.height*0.015,
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.bold
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: Colors.orange.shade900,))),
                                  child: Text("Liked Items",
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.height*0.03,
                                      color: Colors.orange.shade900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  height: MediaQuery.of(context).size.height*0.08,
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                                ),
                              ),
                              Expanded(
                                  flex: 8,
                                  child: ListView.builder(
                                    itemCount: l.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: ClipRRect(
                                                child: Image.network(l[index].imgUrl,
                                                  fit: BoxFit.fill,
                                                  height: MediaQuery.of(context).size.height*0.07,
                                                  width: MediaQuery.of(context).size.width*0.15,
                                                ),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 5,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        child: Text(l[index].name,
                                                          style: TextStyle(
                                                              fontSize: MediaQuery.of(context).size.height*0.02,
                                                              color: Colors.orange.shade700,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                        width: MediaQuery.of(context).size.width*0.6,
                                                        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                                      ),
                                                      InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                            l[index].isLiked=!l[index].isLiked;
                                                            l.removeAt(index);
                                                          });
                                                        },
                                                        child: Container(
                                                          child: Icon(
                                                            l[index].isLiked?Icons.favorite_outlined:Icons.favorite_border_outlined,
                                                            color: Colors.orange.shade700,
                                                            size: 15,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  ),
                                                  Container(
                                                    child: Text("Casual clothing guide for formals.Ultimate Guide for FASHION",
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: MediaQuery.of(context).size.height*0.02,
                                                        color: Colors.grey.shade600,
                                                      ),
                                                    ),
                                                    width: MediaQuery.of(context).size.width*0.75,
                                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                      );
                                    },
                                  )
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                );
              }
              else{
                return Center(child: CircularProgressIndicator(color: Colors.blueAccent,));
              }
            },
          ),
        ),
      ),
    );
  }
}