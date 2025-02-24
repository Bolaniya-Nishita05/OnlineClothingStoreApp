import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineclothingstoreapp/AdminListPage.dart';
import 'package:onlineclothingstoreapp/DashboardListPage.dart';
import 'package:onlineclothingstoreapp/DetailPage.dart';
import 'package:onlineclothingstoreapp/api/DashboardApi.dart';
import 'package:onlineclothingstoreapp/api/FavouriteApi.dart';
import 'package:onlineclothingstoreapp/api/OrderApi.dart';
import 'package:onlineclothingstoreapp/api/ProductApi.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

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
        title: Text("Dashboard"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.dashboard_outlined, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder(
              future: DashboardApi().getDashboardData(),
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
                    var counts=snapshot.data!['counts'];

                    return Column(
                      children: [
                          SizedBox(height: 10,),
                          Expanded(
                            flex: 3,
                            child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  childAspectRatio: 2,
                                ),
                                itemCount: counts.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 15,
                                    shadowColor: Colors.black87,
                                    surfaceTintColor: Colors.purple.shade100,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Text(counts[index]['metric'],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.brown.shade700,
                                                  fontWeight: FontWeight.bold
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(counts[index]['value'].toString(),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey.shade700
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.center,
                                      ),
                                    ),
                                  );
                                },
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            child: Text("Statistical Data",
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              ),
                            ),
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(vertical: 30),
                          ),
                          Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardListPage(list: snapshot.data!['recentOrders'],listName: "Recent Orders",),));
                                },
                                child: Container(
                                  child: Text("Recent Orders",
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.height*0.02,
                                        color: Colors.orange.shade700,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height*0.1,
                                  margin: EdgeInsets.fromLTRB(0,0,0,10),
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(border: Border.all(
                                    color: Colors.black87,
                                    style: BorderStyle.solid,)
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                              )
                          ),
                          SizedBox(height: 10,),
                          Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardListPage(list: snapshot.data!['recentProducts'],listName: "Recent Products",),));
                                },
                                child: Container(
                                  child: Text("Recent Products",
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.height*0.02,
                                        color: Colors.orange.shade700,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height*0.1,
                                  margin: EdgeInsets.fromLTRB(0,0,0,10),
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(border: Border.all(
                                    color: Colors.black87,
                                    style: BorderStyle.solid,)
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                              )
                          ),
                          SizedBox(height: 10,),
                          Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardListPage(list: snapshot.data!['topUsers'],listName: "Top Users",),));
                                },
                                child: Container(
                                  child: Text("Top Users",
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.height*0.02,
                                        color: Colors.orange.shade700,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height*0.1,
                                  margin: EdgeInsets.fromLTRB(0,0,0,10),
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(border: Border.all(
                                    color: Colors.black87,
                                    style: BorderStyle.solid,)
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                              )
                          ),
                          SizedBox(height: 10,),
                          Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardListPage(list: snapshot.data!['topSellingProducts'],listName: "Top Selling Products",),));
                                },
                                child: Container(
                                  child: Text("Top Selling Prodcuts",
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.height*0.02,
                                        color: Colors.orange.shade700,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height*0.1,
                                  margin: EdgeInsets.fromLTRB(0,0,0,10),
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(border: Border.all(
                                    color: Colors.black87,
                                    style: BorderStyle.solid,)
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                              )
                          ),
                        SizedBox(height: 30,)
                      ]
                    );

                  }

                  else {
                    return Center(
                        child: Text("Dashboard Data List is Empty......",
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