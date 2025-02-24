import 'dart:convert';

import 'package:http/http.dart' as http;

class DashboardApi{
  Future<Map<String,dynamic>> getDashboardData() async {
    var data=await http.get(Uri.parse("http://localhost:5053/api/Dashboard"));
    // var data=await http.get(Uri.parse("http://192.168.246.172:5053/api/Dashboard"));
    return jsonDecode(data.body);
  }
}