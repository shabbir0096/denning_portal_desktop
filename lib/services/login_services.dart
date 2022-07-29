// import 'package:denning_portal/models/LoginModel.dart';
// import 'package:denning_portal/services/utilities/app_url.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// class LoginServies{
//   Future<LoginModel> fetchWorldStatsRecords() async{
//
//     final response=await  http.get(Uri.parse(AppUrl.login));
//
//     if(response.statusCode == 200){
//       var data=jsonDecode(response.body);
//       return LoginModel.fromJson(data);
//     }
//     else{
//       return throw Exception("Error");
//     }
//
//
//   }
//   Future<List<dynamic>> fetchResultByCountry() async{
//     var data;
//     final response=await  http.get(Uri.parse(AppUrl.countriesList));
//
//     if(response.statusCode == 200){
//       data=jsonDecode(response.body);
//       return data;
//     }
//     else{
//       return throw Exception("Error");
//     }
//
//
//   }
//
//
// }