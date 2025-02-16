import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineclothingstoreapp/LoginPage.dart';

class HomePage extends StatefulWidget
{
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image.network("https://st.depositphotos.com/1003840/1806/i/450/depositphotos_18067151-stock-photo-young-woman-in-casual-clothes.jpg",
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Row(
              children: [
                Column(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container()
                    ),
                    Expanded(
                        child: Container(
                          color: Colors.white70,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Text("Choose Your\nstyle now",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  // fontSize: 45,
                                  fontSize: MediaQuery.of(context).size.height*0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("Price \$200",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  // fontSize: 18,
                                    fontSize: MediaQuery.of(context).size.height*0.02,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(),));
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(color: Colors.black87,borderRadius: BorderRadius.circular(10)),
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height*0.05,
                                  child: Center(
                                    child: Text("Login",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: MediaQuery.of(context).size.height*0.025
                                      ),
                                    ),
                                  ),
                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                ),
                              )
                            ],
                          ),
                        )
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}