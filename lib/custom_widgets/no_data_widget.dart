import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';
import '../providers/theme.dart';
Widget noDataWidget(String message , BuildContext context ) {
  final theme = Provider.of<ThemeChanger>(context);

  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Container(
        //     height: 100.h,
        //     width:100.w,child: Image.asset(("assets/icons/$imageName"))),
        // SizedBox(
        //   height: 20,
        // ),
        Text(
          '$message',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: theme.isDark? white: black,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}