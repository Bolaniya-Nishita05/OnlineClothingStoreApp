import 'dart:convert';

import 'package:http/http.dart' as http;

class BrandApi{
  Future<List<dynamic>> getBrands() async {
    var data=await http.get(Uri.parse("http://localhost:5053/api/Brand"));
     // var data=await http.get(Uri.parse("http://192.168.246.172:5053/api/Brand"));
    return jsonDecode(data.body);
  }

  Future<bool> deleteBrand(String BrandID) async {
    var response = await http.delete(Uri.parse("http://localhost:5053/api/Brand/"+BrandID.toString()));
    // var response = await http.delete(Uri.parse("http://192.168.246.172:5053/api/Brand/"+BrandID.toString()));

    if(response.statusCode==204){
      return true;
    };

    return false;
  }

  Future<bool> addBrand(Map<String,dynamic> map) async {
    var response = await http.post(Uri.parse("http://localhost:5053/api/Brand/"),body: jsonEncode(map),headers: {"Content-Type": "application/json"});
     // var response = await http.post(Uri.parse("http://192.168.246.172:5053/api/Brand/"),body: jsonEncode(map),headers: {"Content-Type": "application/json"});

    if(response.statusCode==200){
      return true;
    };

    return false;
  }

  Future<bool> updateBrand(Map<String,dynamic> map,int BrandID) async {
    var response = await http.put(Uri.parse("http://localhost:5053/api/Brand/"+BrandID.toString()),body: jsonEncode(map),headers: {"Content-Type": "application/json"});
     // var response = await http.put(Uri.parse("http://192.168.246.172:5053/api/Brand/"+BrandID.toString()),body: jsonEncode(map),headers: {"Content-Type": "application/json"});

    if(response.statusCode==204){
      return true;
    };

    return false;
  }
}