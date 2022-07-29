import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/colors.dart';

class CustomScaffoldWidget {
  CustomScaffoldWidget._();
  static buildErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white,
            fontFamily: "Poppins-Regular"),
      ),
      backgroundColor: errorColor,
    ));
  }
  static buildSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white,
            fontFamily: "Poppins-Regular"),
      ),
      backgroundColor: blue,
    ));
  }
}