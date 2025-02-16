import 'package:flutter/material.dart';
import 'package:onlineclothingstoreapp/AdminListPage.dart';
import 'package:onlineclothingstoreapp/BrandFormPage.dart';
import 'package:onlineclothingstoreapp/CategoryFormPage.dart';
import 'package:onlineclothingstoreapp/HomePage.dart';
import 'package:onlineclothingstoreapp/ListPage.dart';
import 'package:onlineclothingstoreapp/LoginPage.dart';
import 'package:onlineclothingstoreapp/ProductFormPage.dart';
import 'package:onlineclothingstoreapp/UserFormPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Widget> nextScreen() async {
    SharedPreferences pref=await SharedPreferences.getInstance();

    // var username=pref.getString("Username");
    // var password=pref.getString("Password");

    var validUserId=pref.getInt("UserID");
    var remember=pref.getBool("Remember");

    if(remember ?? false){
      return ListPage(validUserId!);
    }

    return HomePage();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          appBarTheme: AppBarTheme(
              elevation: 5,
              backgroundColor: Colors.brown.shade700,
              centerTitle: true,
              shadowColor: Colors.black87,
              titleTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.height*0.03
              ),
          ),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: //HomePage()
        //ListPage()
        //DetailPage()
        //LoginPage()
        //Demo()
        //ProfilePage()
        //CartScreen()
        //UserFormPage()
        //CategoryFormPage(category: null,)
        //BrandFormPage(brand: null,)
        //ProductFormPage(product: null,)
        //AdminListPage(listType: "Product",)
        FutureBuilder<Widget>(
          future: nextScreen(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return snapshot.data!;
            }
            else{
              return CircularProgressIndicator(color: Colors.orange.shade700,);
            }
          },
        )
    );
  }
}
