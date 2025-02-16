import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:onlineclothingstoreapp/AdminListPage.dart';

class UserApi{
  Future<List<dynamic>> getUsers() async {
    var data=await http.get(Uri.parse("http://localhost:5053/api/User"));
     // var data=await http.get(Uri.parse("http://192.168.246.172:5053/api/User"));
    return jsonDecode(data.body);
  }

  Future<Map<String,dynamic>> getUserByUserID(int UserID) async {
    var data=await http.get(Uri.parse("http://localhost:5053/api/User/"+UserID.toString()));
     // var data=await http.get(Uri.parse("http://192.168.246.172:5053/api/User/"+UserID.toString()));
    return jsonDecode(data.body);
  }

  Future<bool> deleteUser(String UserID) async {
    var response = await http.delete(Uri.parse("http://localhost:5053/api/User/"+UserID.toString()));
    // var response = await http.delete(Uri.parse("http://192.168.246.172:5053/api/User/"+UserID.toString()));

    if(response.statusCode==204){
      return true;
    };

    return false;
  }

  Future<bool> addUser(Map<String,dynamic> map) async {
    var response = await http.post(Uri.parse("http://localhost:5053/api/User/"),body: jsonEncode(map),headers: {"Content-Type": "application/json"});
     // var response = await http.post(Uri.parse("http://192.168.246.172:5053/api/User/"),body: jsonEncode(map),headers: {"Content-Type": "application/json"});

    if(response.statusCode==200){
      return true;
    };

    return false;
  }

  Future<bool> updateUser(Map<String,dynamic> map,int UserID) async {
    var response = await http.put(Uri.parse("http://localhost:5053/api/User/"+UserID.toString()),body: jsonEncode(map),headers: {"Content-Type": "application/json"});
     // var response = await http.put(Uri.parse("http://192.168.246.172:5053/api/User/"+UserID.toString()),body: jsonEncode(map),headers: {"Content-Type": "application/json"});

    if(response.statusCode==204){
      return true;
    };

    return false;
  }
}