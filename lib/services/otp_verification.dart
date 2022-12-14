import 'package:denning_portal/screens/student_screens/otp_screens/otp_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import '../utils/colors.dart';


class OtpServices{
  Future postOtpRequest( phoneFormatted,context) async{
    var rng = Random();
    if (kDebugMode) {
      print(phoneFormatted);
    }
    int msg=rng.nextInt(9000)+1000;


    Map data = {"id": "rchdenning", "pass": "ricahoni","to":"$phoneFormatted","msg":"Your OTP is $msg\nPlease Donot share it with anyone.","lang":"english","mask":"denning"};

     // String body = json.encode(data);

    http.Response response = await http.post(
        Uri.parse("http://outreach.pk/api/sendsms.php/sendsms/url?"),
body: data
        // headers: {HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Authoriz $token"},
        );
    if (kDebugMode) {
      print(response.body);
    }

    if(response.statusCode == 300){
      if (kDebugMode) {
        print("Successfully send number");
      }
      // prefs.setInt('msg', msg);



    }
    else{
      if (kDebugMode) {
        print("error");
      }
    }


   Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpResponse(msg ,  phoneFormatted)));//
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "OTP has been sent to your $phoneFormatted",
        style: const TextStyle(
            fontSize: 14,
            color: white,
            fontFamily: "Poppins-Regular"),
      ),
      backgroundColor:purple,
    ));
  }


}