import 'dart:convert';

import 'package:http/http.dart' as http;

class OrderApi{
  Future<List<dynamic>> getOrders() async {
    var data=await http.get(Uri.parse("http://localhost:5053/api/Order"));
     // var data=await http.get(Uri.parse("http://192.168.246.172:5053/api/Order"));
    return jsonDecode(data.body);
  }

  Future<List<dynamic>> getOrderByUserID(int UserID) async {
    var data=await http.get(Uri.parse("http://localhost:5053/api/Order/OrdersByUser/"+UserID.toString()));
     // var data=await http.get(Uri.parse("http://192.168.246.172:5053/api/Order/OrdersByUser/"+UserID.toString()));

    if(data.statusCode==404){
      return [];
    }

    return jsonDecode(data.body);
  }

  Future<bool> deleteOrder(String OrderID) async {
    var response = await http.delete(Uri.parse("http://localhost:5053/api/Order/"+OrderID.toString()));
     // var response = await http.delete(Uri.parse("http://192.168.246.172:5053/api/Order/"+OrderID.toString()));


    if(response.statusCode==204){
      return true;
    };

    return false;
  }

  Future<bool> addOrder(Map<String,dynamic> map) async {
    var response = await http.post(Uri.parse("http://localhost:5053/api/Order/"),body: jsonEncode(map),headers: {"Content-Type": "application/json"});
    // var response = await http.post(Uri.parse("http://192.168.246.172:5053/api/Order/"),body: jsonEncode(map),headers: {"Content-Type": "application/json"});

    if(response.statusCode==200){
      return true;
    };

    return false;
  }

  Future<bool> updateOrder(Map<String,dynamic> map,int OrderID) async {
    var response = await http.put(Uri.parse("http://localhost:5053/api/Order/"+OrderID.toString()),body: jsonEncode(map),headers: {"Content-Type": "application/json"});
    // var response = await http.put(Uri.parse("http://192.168.246.172:5053/api/Order/"+OrderID.toString()),body: jsonEncode(map),headers: {"Content-Type": "application/json"});

    if(response.statusCode==204){
      return true;
    };

    return false;
  }
}