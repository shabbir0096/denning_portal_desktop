import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../utils/colors.dart';
import '../providers/theme.dart';

CustomDialogueBox(context, var title, var desc, AlertType alertType) {
  // Reusable alert style
  final theme = Provider.of<ThemeChanger>(context);
  var alertStyle = AlertStyle(
      backgroundColor: black,
      animationType: AnimationType.grow,
      isCloseButton: true,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(
        color: white,
        fontFamily: "Poppins_Regular" ,fontSize: 12.sp,
      ),
      animationDuration: const Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(
          color: black,
        ),
      ),
      titleStyle: const TextStyle(
        color: white,
        fontFamily: "Poppins_Regular",
      ),
      constraints: BoxConstraints.expand(width: 300.w),
      //First to chars "55" represents transparency of color
      overlayColor: const Color(0x55000000),
      alertElevation: 0,
      alertAlignment: Alignment.center);

  // Alert dialog using custom alert style
  Alert(
    context: context,
    style: alertStyle,
    type: alertType,
    title: title,
    desc: desc,
    buttons: [
      DialogButton(
          child: Text(
            "Ok",
            style: TextStyle(
                color:  theme.isDark ? white : black, fontFamily: "Poppins_Regular", fontSize: 20.sp),
          ),
          onPressed: () => Navigator.pop(context),
          color: white,
          splashColor: Colors.white,
          radius: BorderRadius.circular(10.0)),
    ],
  ).show();
}