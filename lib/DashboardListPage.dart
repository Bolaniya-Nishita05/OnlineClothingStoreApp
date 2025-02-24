import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardListPage extends StatefulWidget {
  @override
  State<DashboardListPage> createState() => _DashboardListPageState();

  List<dynamic>? list;
  String? listName;

  DashboardListPage({required List<dynamic> list, required String listName})
  {
    this.list=list;
    this.listName=listName;
  }
}

class _DashboardListPageState extends State<DashboardListPage> {
  var list;

  @override
  void initState()
  {
    super.initState();

    this.list=widget.list;
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
        title: Text(widget.listName!),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.list_alt, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 10),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: list.length,
            itemBuilder: (context, index) {

              if(widget.listName=="Recent Orders") {
                return RecentOrders(map: list[index]);
              }
              else if(widget.listName=="Recent Products") {
                return RecentProducts(map: list[index]);
              }
              else if(widget.listName=="Top Users") {
                return TopUsers(map: list[index]);
              }
              else if(widget.listName=="Top Selling Products") {
                return TopSellingProducts(map: list[index]);
              }
              else{
                return Text("No such data found");
              }
            },
          )
        ),
      ),
    );
  }
}

class RecentOrders extends StatefulWidget {
  Map<String, dynamic> map=new Map();

  RecentOrders({
    required this.map
  });

  @override
  State<RecentOrders> createState() => _RecentOrdersState();
}

class _RecentOrdersState extends State<RecentOrders> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Text(widget.map['userName'],
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height*0.018,
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.bold
              ),
            ),
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            child: Text(widget.map['productName'],
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height*0.018,
                color: Colors.grey.shade600,
              ),
            ),
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            child: Text("Total Amount : \u{20B9}"+widget.map['totalAmount'].toString(),
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
      margin: EdgeInsets.fromLTRB(0,0,0,10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(
        color: Colors.black87,
        style: BorderStyle.solid,)),
    );
  }
}

class RecentProducts extends StatefulWidget {
  Map<String, dynamic> map=new Map();

  RecentProducts({
    required this.map
  });

  @override
  State<RecentProducts> createState() => _RecentProductsState();
}

class _RecentProductsState extends State<RecentProducts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Text(widget.map['productName'],
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height*0.018,
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.bold
              ),
            ),
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            child: Text("Price : \u{20B9}"+widget.map['price'].toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height*0.018,
                color: Colors.grey.shade600,
              ),
            ),
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            child: Text("Stock Quantity : "+widget.map['stockQuantity'].toString(),
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
      margin: EdgeInsets.fromLTRB(0,0,0,10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(
        color: Colors.black87,
        style: BorderStyle.solid,)),
    );
  }
}

class TopUsers extends StatefulWidget {
  Map<String, dynamic> map=new Map();

  TopUsers({
    required this.map
  });

  @override
  State<TopUsers> createState() => _TopUsersState();
}

class _TopUsersState extends State<TopUsers> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Text(widget.map['userName'],
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height*0.018,
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.bold
              ),
            ),
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            child: Text("Total Orders : "+widget.map['totalOrders'].toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height*0.018,
                color: Colors.grey.shade600,
              ),
            ),
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            child: Text("Email : "+widget.map['email'].toString(),
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
      margin: EdgeInsets.fromLTRB(0,0,0,10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(
        color: Colors.black87,
        style: BorderStyle.solid,)),
    );
  }
}


class TopSellingProducts extends StatefulWidget {
  Map<String, dynamic> map=new Map();

  TopSellingProducts({
    required this.map
  });

  @override
  State<TopSellingProducts> createState() => _TopSellingProductsState();
}

class _TopSellingProductsState extends State<TopSellingProducts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Text(widget.map['productName'],
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height*0.018,
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.bold
              ),
            ),
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            child: Text("Total Sold Quantity : "+widget.map['totalSoldQuantity'].toString(),
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
      margin: EdgeInsets.fromLTRB(0,0,0,10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(
        color: Colors.black87,
        style: BorderStyle.solid,)),
    );
  }
}