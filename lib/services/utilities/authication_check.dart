import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../custom_widgets/scaffold_messenge_snackbar.dart';
import '../../screens/login_screens/email_login.dart';


class AuthChecker{
  static void  exceptionHandling(BuildContext context, int statusCode) async{
    if(statusCode == 401 ) {
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
      CustomScaffoldWidget.buildErrorSnackbar(context, "Your Session has been expired, please try to login again");
    }
    else if (statusCode == 404){
      CustomScaffoldWidget.buildErrorSnackbar(context, "Data not Found");
    }
    else if (statusCode == 408){
      CustomScaffoldWidget.buildErrorSnackbar(context, "Data not Found");
    }
    else if (statusCode == 500){
      CustomScaffoldWidget.buildErrorSnackbar(context, "Internal Server Error");
    }
  }
}