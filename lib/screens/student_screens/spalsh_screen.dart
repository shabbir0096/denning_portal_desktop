import 'dart:async';
import 'package:denning_portal/screens/login_screens/email_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';
import '../../providers/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const EmailLogin()),
      );
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 200.h,),
          Center(
            child: Image.asset(
              theme.isDark?
              "assets/images/denning_logo_white.png":"assets/images/denning_logo_black.png",
              height: 200.h,
              width: 180.w,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          const Spacer(),
          CircularProgressIndicator(
            color:  theme.isDark? white: black,
          ),
          SizedBox(height: 30.h,),
        ],
      ),
    );
  }
}
