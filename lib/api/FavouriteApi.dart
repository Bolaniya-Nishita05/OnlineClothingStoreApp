import 'dart:convert';

import 'package:http/http.dart' as http;

class FavouriteApi{
  Future<List<dynamic>> getFavourites() async {
    var data=await http.get(Uri.parse("http://localhost:5053/api/Favourite"));
    // var data=await http.get(Uri.parse("http://192.168.246.172:5053/api/Favourite"));
    return jsonDecode(data.body);
  }

  Future<List<dynamic>> getFavouriteByUserID(int UserID) async {
    var data=await http.get(Uri.parse("http://localhost:5053/api/Favourite/FavouritesByUser/"+UserID.toString()));
    // var data=await http.get(Uri.parse("http://192.168.246.172:5053/api/Favourite/FavouritesByUser/"+UserID.toString()));

    if(data.statusCode==404){
      return [];
    }

    return jsonDecode(data.body);
  }

  Future<bool> deleteFavourite(String FavouriteID) async {
    var response = await http.delete(Uri.parse("http://localhost:5053/api/Favourite/"+FavouriteID.toString()));
    // var response = await http.delete(Uri.parse("http://192.168.246.172:5053/api/Favourite/"+FavouriteID.toString()));


    if(response.statusCode==204){
      return true;
    };

    return false;
  }

  Future<bool> addFavourite(Map<String,dynamic> map) async {
    var response = await http.post(Uri.parse("http://localhost:5053/api/Favourite/"),body: jsonEncode(map),headers: {"Content-Type": "application/json"});
    // var response = await http.post(Uri.parse("http://192.168.246.172:5053/api/Favourite/"),body: jsonEncode(map),headers: {"Content-Type": "application/json"});

    if(response.statusCode==200){
      return true;
    };

    return false;
  }
}