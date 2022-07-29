import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';
import '../providers/theme.dart';

class CustomTextField extends StatelessWidget {
  final String labelText, hintText;
  final TextEditingController controller;
  TextInputType? keyboardType;
  final bool autofocus;
  final bool isPassword , readOnlyField;
  final Icon icon;
  final Color cursorColor;
  GestureDetector? gestureDetector;
  final VoidCallback onchanged;
  String? Function(String?)? validator;
  String? Function(String?)? onSaved;

  CustomTextField({Key? key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.keyboardType,
    this.autofocus = false,
    required this.onchanged,
    required this.icon,
    required this.cursorColor,
    this.gestureDetector,
    this.isPassword = false, this.readOnlyField = false ,required this.validator ,  this.onSaved})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    final _height = MediaQuery
        .of(context)
        .size
        .height -
        MediaQuery
            .of(context)
            .padding
            .top -
        kToolbarHeight;
    final _width = MediaQuery
        .of(context)
        .size
        .width;
    return Padding(
      padding: EdgeInsets.all(_width * 0.01),
      child: Theme(
        child: TextFormField(
          enabled: true,
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.left,
          autofocus: false,
          readOnly: readOnlyField,
          keyboardType: keyboardType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          cursorColor: cursorColor,
          obscureText: isPassword,
          style: TextStyle(color: theme.isDark? white: black),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 20),
              labelText: labelText,
              fillColor: white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.isDark? white: black, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(10.0),
                borderSide: new BorderSide(color: theme.isDark? white: black),
              ),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                    width: 1,
                    color: errorColor,
                  )),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                  width: 1,
                  color: errorColor,
                ),
              ),


              alignLabelWithHint: true,
              errorStyle: TextStyle(color: errorColor),
              border: InputBorder.none,
              prefixIcon: icon,
              suffixIcon: gestureDetector,
              hintText: hintText,
              hintStyle: TextStyle(
                  fontFamily: "Poppins-Regular", fontSize: 12.sp, color: Colors.grey,),
              labelStyle: TextStyle(
                  color: theme.isDark? white: black,
                  fontFamily: "Poppins-Regular",
                  fontSize: 12.sp)),
          validator: validator,
          onSaved: onSaved,
        ),
        data: Theme.of(context).copyWith(
          primaryColor: theme.isDark? white: black,
        ),
      ),
    );
  }
}