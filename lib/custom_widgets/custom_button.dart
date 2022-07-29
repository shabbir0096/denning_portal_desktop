import 'package:denning_portal/custom_widgets/custom_textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../screens/student_screens/otp_screens/otp_register.dart';
import '../utils/colors.dart';
import '../providers/theme.dart';

class CustomButtonW extends StatelessWidget {
  bool isChecked;
  bool buttonClicked = false;
  VoidCallback onPress;
  String buttonText;

  CustomButtonW(
      {Key? key,
         this.isChecked  = false,
        required this.buttonClicked,
        required this.onPress,
        required this.buttonText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return Center(
      child: Container(
        width: double.infinity,
        height: 50.h,
        child: MaterialButton(
          elevation: 0,
          child: Text(
            buttonText,
            style:CustomTextStyle.titleSemiBold(context , theme.isDark? black: white,),
          ),
          textColor: black,
          shape: RoundedRectangleBorder(
            borderRadius:  BorderRadius.circular(10.0),

          ),
          color:theme.isDark ? white : black,
          onPressed: onPress,
        ),
      ),
    );

  }
}