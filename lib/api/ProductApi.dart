import 'dart:convert';

import 'package:http/http.dart' as http;

class ProductApi{
  Future<List<dynamic>> getProducts() async {
   var data=await http.get(Uri.parse("http://localhost:5053/api/Product"));
    // var data=await http.get(Uri.parse("http://192.168.246.172:5053/api/Product"));
    return jsonDecode(data.body);
  }

  Future<Map<String,dynamic>> getProductByProductID(int ProductID) async {
    var data=await http.get(Uri.parse("http://localhost:5053/api/Product/"+ProductID.toString()));
     // var data=await http.get(Uri.parse("http://192.168.246.172:5053/api/Product/"+ProductID.toString()));
    return jsonDecode(data.body);
  }

  Future<List<dynamic>> getProductsByCategoryID(int CategoryID) async {
    var data=await http.get(Uri.parse("http://localhost:5053/api/Product/ProductsByCategory/"+CategoryID.toString()));
     // var data=await http.get(Uri.parse("http://192.168.246.172:5053/api/Product/ProductsByCategory/"+CategoryID.toString()));

    if(data.statusCode==404){
      return [];
    }
    return jsonDecode(data.body);
  }

  Future<List<dynamic>> getProductsByBrandID(int BrandID) async {
    var data=await http.get(Uri.parse("http://localhost:5053/api/Product/ProductsByBrand/"+BrandID.toString()));
     // var data=await http.get(Uri.parse("http://192.168.246.172:5053/api/Product/ProductsByBrand/"+BrandID.toString()));

    if(data.statusCode==404){
      return [];
    }
    return jsonDecode(data.body);
  }

  Future<bool> deleteProduct(String ProductID) async {
    var response = await http.delete(Uri.parse("http://localhost:5053/api/Product/"+ProductID.toString()));
    // var response = await http.delete(Uri.parse("http://192.168.246.172:5053/api/Product/"+ProductID.toString()));

    if(response.statusCode==204){
      return true;
    };

    return false;
  }

  Future<bool> addProduct(Map<String,dynamic> map) async {
    var response = await http.post(Uri.parse("http://localhost:5053/api/Product/"),body: jsonEncode(map),headers: {"Content-Type": "application/json"});
    // var response = await http.post(Uri.parse("http://192.168.246.172:5053/api/Product/"),body: jsonEncode(map),headers: {"Content-Type": "application/json"});

    if(response.statusCode==200){
      return true;
    };

    return false;
  }

  Future<bool> updateProduct(Map<String,dynamic> map,int ProductID) async {
    var response = await http.put(Uri.parse("http://localhost:5053/api/Product/"+ProductID.toString()),body: jsonEncode(map),headers: {"Content-Type": "application/json"});
    // var response = await http.put(Uri.parse("http://192.168.246.172:5053/api/Product/"+ProductID.toString()),body: jsonEncode(map),headers: {"Content-Type": "application/json"});

    if(response.statusCode==204){
      return true;
    };

    return false;
  }

  Future<List<dynamic>> getCategoriesDropDown() async {
    var data=await http.get(Uri.parse("http://localhost:5053/api/Product/Categories"));
    // var data=await http.get(Uri.parse("http://192.168.246.172:5053/api/Product/Categories"));

    if(data.statusCode==404){
      return [];
    }

    return jsonDecode(data.body);
  }

  Future<List<dynamic>> getBrandsDropDown() async {
    var data=await http.get(Uri.parse("http://localhost:5053/api/Product/Brands"));
    // var data=await http.get(Uri.parse("http://192.168.246.172:5053/api/Product/Brands"));

    if(data.statusCode==404){
      return [];
    }

    return jsonDecode(data.body);
  }
}