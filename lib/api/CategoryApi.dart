import 'dart:convert';

import 'package:http/http.dart' as http;

class CategoryApi{
  Future<List<dynamic>> getCategories() async {
    var data=await http.get(Uri.parse("http://localhost:5053/api/Category"));
     // var data=await http.get(Uri.parse("http://192.168.246.172:5053/api/Category"));
    return jsonDecode(data.body);
  }

  Future<bool> deleteCategory(String CategoryID) async {
    var response = await http.delete(Uri.parse("http://localhost:5053/api/Category/"+CategoryID.toString()));
    // var response = await http.delete(Uri.parse("http://192.168.246.172:5053/api/Category/"+CategoryID.toString()));

    if(response.statusCode==204){
      return true;
    };

    return false;
  }

  Future<bool> addCategory(Map<String,dynamic> map) async {
    var response = await http.post(Uri.parse("http://localhost:5053/api/Category/"),body: jsonEncode(map),headers: {"Content-Type": "application/json"});
     // var response = await http.post(Uri.parse("http://192.168.246.172:5053/api/Category/"),body: jsonEncode(map),headers: {"Content-Type": "application/json"});

    if(response.statusCode==200){
      return true;
    };

    return false;
  }

  Future<bool> updateCategory(Map<String,dynamic> map,int CategoryID) async {
    var response = await http.put(Uri.parse("http://localhost:5053/api/Category/"+CategoryID.toString()),body: jsonEncode(map),headers: {"Content-Type": "application/json"});
     // var response = await http.put(Uri.parse("http://192.168.246.172:5053/api/Category/"+CategoryID.toString()),body: jsonEncode(map),headers: {"Content-Type": "application/json"});

    if(response.statusCode==204){
      return true;
    };

    return false;
  }
}