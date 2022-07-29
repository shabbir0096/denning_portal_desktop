

import 'dart:async';
import 'dart:io';

import 'package:denning_portal/services/utilities/app_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../custom_widgets/scaffold_messenge_snackbar.dart';
import '../screens/login_screens/email_login.dart';
import '../services/utilities/authication_check.dart';
import '../services/utilities/basic_auth.dart';

class ChatsController {
  static Future chatMessage(String type , BuildContext context) async {
    var convertedData;
    String token ="";
    String studentId = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
    studentId = prefs.getString('studentId')!;
    try {

      final response = await http.get(
        Uri.parse(
            "${AppUrl
                .baseUrl}messages_data?auth_token=${token}&student_id=${studentId}&type=${type}"),
        headers: <String, String>{'authorization': BasicAuth.basicAuth},
      );

      if (response.statusCode == 200) {
        convertedData = json.decode(response.body);
        if(convertedData['status'] == 200){
          return convertedData;
        }
        else if (convertedData['status'] == 401 && convertedData['message'] == 'auth_token_expired') {
          final pref = await SharedPreferences.getInstance();
          await pref.remove('studentId');
          await pref.remove('image');
          await pref.remove('studentCode');
          await pref.remove('email');
          await pref.remove('address');
          await pref.remove('phone');
          await pref.remove('phoneFormatted');
          await pref.remove('name');
          await pref.remove('birthday');
          await pref.remove('gender');
          await pref.remove('validity');
          await pref.remove('birthday');
          await pref.remove('token');
          await pref.remove('status');

          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => EmailLogin()));
          CustomScaffoldWidget.buildErrorSnackbar(context,
              "Your Session has been expired, please try to login again");
        }
        else if (convertedData['status'] == 401){
          CustomScaffoldWidget.buildErrorSnackbar(
              context, "${convertedData['message']}");
        }
        else if(convertedData['status'] == 404){
          CustomScaffoldWidget.buildErrorSnackbar(context, "${convertedData['message']}");
        } else {
          CustomScaffoldWidget.buildErrorSnackbar(context, "Something went wrong");
        }
      } else {
        AuthChecker.exceptionHandling(context, response.statusCode);
      }
    }on TimeoutException catch (e) {
      CustomScaffoldWidget.buildErrorSnackbar(context, "Time out try again");
    } on SocketException catch (e) {
      CustomScaffoldWidget.buildErrorSnackbar(
          context, "Please enable your internet connection");
    } on Error catch (e) {
      CustomScaffoldWidget.buildErrorSnackbar(context, "Something went wrong");
    }
  }



}
