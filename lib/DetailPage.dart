import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:onlineclothingstoreapp/api/FavouriteApi.dart';
import 'package:onlineclothingstoreapp/api/OrderApi.dart';

class DetailPage extends StatefulWidget
{
  @override
  State<DetailPage> createState() => _DetailPageState();

  Map<String,dynamic>? product;
  Map<String,dynamic>? order;
  int loggedUserID=0;

  DetailPage({Map<String,dynamic>? product,int loggedUserID=0,Map<String,dynamic>? order}){
    if(product!=null){
      this.product=product;
      this.loggedUserID=loggedUserID;
    }

    this.order=order;
  }
}

class _DetailPageState extends State<DetailPage> {
  String Size="S";

  String Color="Red";

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

  Map<String,dynamic> product=new Map();
  int loggedUserID=0;
  Map<String,dynamic> order=new Map();
  int favouriteID=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.product!=null){
      product=widget.product!;
      this.loggedUserID=widget.loggedUserID;
      order['quantity']=1;
    }

    if(widget.order!=null){
      this.order=widget.order!;
      this.Size=this.order['size'];
      this.Color=this.order['color'];
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
        title: Text("Product Details"),
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
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.85,
                      child: Align(
                        child: Text(product['productName'],
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height*0.02,
                                color: Colors.orange.shade900,
                                fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      child: FutureBuilder<List<dynamic>>(
                          future: FavouriteApi().getFavouriteByUserID(loggedUserID),
                          builder: (context, snapshot) {
                            if(snapshot.hasData){

                              for(var favourite in snapshot.data!){
                                if(widget.product!['productID']==favourite['productID']){
                                  favouriteID=favourite['favouriteID'];
                                  break;
                                }
                              }

                              return InkWell(
                                onTap: () async {
                                  if (favouriteID != 0) {
                                    await FavouriteApi().deleteFavourite(favouriteID.toString());

                                    favouriteID = 0;
                                    setState(() {

                                    });
                                  } else {
                                    await FavouriteApi().addFavourite({
                                      'favouriteID': "5",
                                      'productID': widget.product!['productID'],
                                      'userID': loggedUserID,
                                    });

                                    setState(() {

                                    });
                                  }

                                },
                                child: Container(
                                  child: Icon(
                                    favouriteID!=0?Icons.favorite_rounded:Icons.favorite_outline_rounded,
                                    color: Colors.orange.shade900,
                                  ),
                                ),
                              );
                            }
                            else{
                              return Center(child: CircularProgressIndicator(color: Colors.blueAccent,));
                            }
                          }
                      ),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  child:ClipRRect(
                    child: Image.network(widget.product!['imgUrl'],
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.35,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(width: 3,color: Colors.brown.shade700),
                      borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                ),
              ),
              Expanded(
                child: Container(
                  child: Text("Details",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height*0.02,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(20,10,20,10),
                ),
              ),
              Expanded(
                child: Container(
                  child: Text(product['description'],
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height*0.02,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(20,0,20,0),
                ),
              ),Expanded(
                child: Row(
                  children: [
                    Container(
                      child: Text("Category",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height*0.02,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      margin: EdgeInsets.fromLTRB(20,10,20,10),
                    ),
                    Container(
                      child: Text(product['categoryName'],
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: MediaQuery.of(context).size.height*0.02,
                        ),
                      ),
                    ),
                  ],
                ),
              ),Expanded(
                child: Row(
                  children: [
                    Container(
                      child: Text("Brand",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height*0.02,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      margin: EdgeInsets.fromLTRB(20,10,20,10),
                    ),
                    Container(
                      child: Text(product['brandName'],
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: MediaQuery.of(context).size.height*0.02,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      child: Text("Price",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height*0.02,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      margin: EdgeInsets.fromLTRB(20,10,20,10),
                    ),
                    Container(
                      child: Text('\u{20B9}${product['price'].toString()}',
                        style: TextStyle(
                            color: Colors.orange.shade900,
                            fontSize: MediaQuery.of(context).size.height*0.02,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: Text("Sizes",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height*0.02,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(20,0,20,0),
                ),
              ),
              Expanded(
                child: Container(
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            Size="S";
                          });
                        },
                        child: Container(
                          child: Center(
                            child: Text("S",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: MediaQuery.of(context).size.height*0.02,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          height: MediaQuery.of(context).size.height*0.2,
                          width: MediaQuery.of(context).size.width*0.1,
                          decoration: BoxDecoration(
                              border: Border.all(color: Size=="S"?Colors.grey.shade700:Colors.white,width: 2),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            Size="M";
                          });
                        },
                        child: Container(
                          child: Center(
                            child: Text("M",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: MediaQuery.of(context).size.height*0.02,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          height: MediaQuery.of(context).size.height*0.2,
                          width: MediaQuery.of(context).size.width*0.1,
                          decoration: BoxDecoration(
                              border: Border.all(color: Size=="M"?Colors.grey.shade700:Colors.white,width: 2),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          margin: EdgeInsets.fromLTRB(10, 0, 20, 10),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            Size="L";
                          });
                        },
                        child: Container(
                          child: Center(
                            child: Text("L",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: MediaQuery.of(context).size.height*0.02,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          height: MediaQuery.of(context).size.height*0.2,
                          width: MediaQuery.of(context).size.width*0.1,
                          decoration: BoxDecoration(
                              border: Border.all(color: Size=="L"?Colors.grey.shade700:Colors.white,width: 2),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          margin: EdgeInsets.fromLTRB(10, 0, 20, 10),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            Size="XL";
                          });
                        },
                        child: Container(
                          child: Center(
                            child: Text("XL",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: MediaQuery.of(context).size.height*0.02,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          height: MediaQuery.of(context).size.height*0.2,
                          width: MediaQuery.of(context).size.width*0.1,
                          decoration: BoxDecoration(
                              border: Border.all(color: Size=="XL"?Colors.grey.shade700:Colors.white,width: 2),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          margin: EdgeInsets.fromLTRB(10, 0, 20, 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Text("Colours",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height*0.02,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(20,10,20,10),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          Color="Red";
                        });
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(Icons.circle,size: 10,color: Colors.orange.shade900,),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Color=="Red"?Colors.orange.shade900:Colors.white,
                                width: 2)
                        ),
                        margin: EdgeInsets.fromLTRB(20,0,10,10),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Color="Indigo";
                        });
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(Icons.circle,size: 10,color: Colors.indigo,),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Color=="Indigo"?Colors.indigo:Colors.white,
                                width: 2)
                        ),
                        margin: EdgeInsets.fromLTRB(0,0,10,10),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Color="Teal";
                        });
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(Icons.circle,size: 10,color: Colors.teal,),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Color=="Teal"?Colors.teal:Colors.white,
                                width: 2)
                        ),
                        margin: EdgeInsets.fromLTRB(0,0,10,10),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Color="Brown";
                        });
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(Icons.circle,size: 10,color: Colors.brown.shade400,),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Color=="Brown"?Colors.brown.shade400:Colors.white,
                                width: 2)
                        ),
                        margin: EdgeInsets.fromLTRB(0,0,10,10),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(child:
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(child:
                        Text("Quantity",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height*0.02,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ),
                      DropdownButton<int>(
                        value: order['quantity'],
                        items: [
                          DropdownMenuItem(child: Text("1"), value: 1),
                          DropdownMenuItem(child: Text("2"), value: 2),
                          DropdownMenuItem(child: Text("3"), value: 3),
                          DropdownMenuItem(child: Text("4"), value: 4),
                          DropdownMenuItem(child: Text("5"), value: 5),
                          DropdownMenuItem(child: Text("6"), value: 6),
                          DropdownMenuItem(child: Text("7"), value: 7),
                          DropdownMenuItem(child: Text("8"), value: 8),
                          DropdownMenuItem(child: Text("9"), value: 9),
                          DropdownMenuItem(child: Text("10"), value: 10)
                        ],
                        onChanged: (value) {
                          setState(() {
                            order['quantity']=value;
                          });
                        },
                      ),
                    ],
                  ),
                )
              ),
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () async {
                    order['orderID']=order['orderID']??"0";
                    order['productID']=product['productID'];
                    order['userID']=this.loggedUserID;
                    order['totalAmount']=product['price']*order['quantity'];
                    order['size']=this.Size;
                    order['color']=this.Color;

                    var response = widget.order==null
                        ? await OrderApi().addOrder(this.order!)
                        : await OrderApi().updateOrder(this.order!, this.order!['orderID']);

                    if(response){
                      showCupertinoDialog(context: context, builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text("SUCCESS!!",style: TextStyle(color: Colors.green),),
                          content: Text("Cart updated successfully!!"),
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
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.black87,borderRadius: BorderRadius.circular(10)),
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text("ADD TO CART",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: MediaQuery.of(context).size.height*0.02
                        ),
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(20,20,20,20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}