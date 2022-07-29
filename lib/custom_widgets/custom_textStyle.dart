import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CustomTextStyle {
  var textColr;
  static TextStyle? AppBarHeading(BuildContext context  , textColor) {
    return Theme.of(context).textTheme.headline1?.copyWith(fontSize: 18.0.sp , color: textColor, fontFamily: "Poppins-SemiBold");
  }
  static TextStyle? heading1(BuildContext context,textColor) {
    return Theme.of(context).textTheme.headline1?.copyWith(fontSize: 27.0.sp , color: textColor, fontFamily: "Poppins-Regular");
  }
  static TextStyle? headingBold(BuildContext context,textColor) {
    return Theme.of(context).textTheme.headline1?.copyWith(fontSize: 20.0.sp , color: textColor, fontFamily: "Poppins-Bold");
  }
  static TextStyle? headingSemiBold(BuildContext context,textColor) {
    return Theme.of(context).textTheme.headline1?.copyWith(fontSize: 20.0.sp , color: textColor, fontFamily: "Poppins-SemiBold");
  }
  static TextStyle? headingRegular(BuildContext context,textColor) {
    return Theme.of(context).textTheme.headline1?.copyWith(fontSize: 20.0.sp ,  color: textColor,fontFamily: "Poppins-Regular");
  }
  static TextStyle? headingBold2(BuildContext context,textColor) {
    return Theme.of(context).textTheme.headline1?.copyWith(fontSize: 17.0.sp , color: textColor, fontFamily: "Poppins-Bold");
  }
  static TextStyle? headingSemiBold2(BuildContext context,textColor) {
    return Theme.of(context).textTheme.headline1?.copyWith(fontSize: 17.0.sp , color: textColor, fontFamily: "Poppins-SemiBold");
  }
  static TextStyle? headingRegular2(BuildContext context,textColor) {
    return Theme.of(context).textTheme.headline1?.copyWith(fontSize: 17.0.sp ,  color: textColor,fontFamily: "Poppins-Regular");
  }
  static TextStyle? titleBold(BuildContext context,textColor) {
    return Theme.of(context).textTheme.headline1?.copyWith(fontSize: 16.0.sp , color: textColor, fontFamily: "Poppins-Bold");
  }
  static TextStyle? titleSemiBold(BuildContext context,textColor) {
    return Theme.of(context).textTheme.headline1?.copyWith(fontSize: 15.0.sp , color: textColor, fontFamily: "Poppins-SemiBold");
  }
  static TextStyle? titleRegular(BuildContext context,textColor) {
    return Theme.of(context).textTheme.headline1?.copyWith(fontSize: 16.0.sp , color: textColor, fontFamily: "Poppins-Regular");
  }
  static TextStyle? bodyBold(BuildContext context,textColor) {
    return Theme.of(context).textTheme.headline1?.copyWith(fontSize: 14.0.sp , color: textColor, fontFamily: "Poppins-Bold");
  }
  static TextStyle? bodySemiBold(BuildContext context,textColor) {
    return Theme.of(context).textTheme.headline1?.copyWith(fontSize: 14.0.sp ,  color: textColor,fontFamily: "Poppins-SemiBold");
  }
  static TextStyle? bodySemiBold2(BuildContext context,textColor) {
    return Theme.of(context).textTheme.headline1?.copyWith(fontSize: 13.0.sp ,  color: textColor,fontFamily: "Poppins-SemiBold");
  }
  static TextStyle? bodyRegular(BuildContext context,textColor) {
    return Theme.of(context).textTheme.headline1?.copyWith(fontSize: 14.0.sp , color: textColor, fontFamily: "Poppins-Regular");
  }
  static TextStyle? bodyRegular2(BuildContext context,textColor) {
    return Theme.of(context).textTheme.headline1?.copyWith(fontSize: 12.0.sp , color: textColor, fontFamily: "Poppins-Regular");
  }
  static TextStyle? bodyRegularUnderline(BuildContext context,textColor) {
    return Theme.of(context).textTheme.headline1?.copyWith(fontSize: 14.0.sp , color: textColor, fontFamily: "Poppins-Regular", decoration: TextDecoration.underline,);
  }
  static TextStyle? bodyRegular2Underline(BuildContext context,textColor) {
    return Theme.of(context).textTheme.headline1?.copyWith(fontSize: 12.0.sp , color: textColor, fontFamily: "Poppins-Regular", decoration: TextDecoration.underline,);
  }
  static TextStyle? bodyRegular3(BuildContext context,textColor) {
    return Theme.of(context).textTheme.headline1?.copyWith(fontSize: 10.0.sp ,  color: textColor,fontFamily: "Poppins-Regular");
  }
  static TextStyle? bodyRegular4(BuildContext context,textColor) {
    return Theme.of(context).textTheme.headline1?.copyWith(fontSize: 8.0.sp , color: textColor, fontFamily: "Poppins-Regular");
  }
}