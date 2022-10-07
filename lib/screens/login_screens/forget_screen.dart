import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_textFormField.dart';
import '../../custom_widgets/custom_textStyle.dart';
import '../../providers/internet_checker.dart';
import '../../services/utilities/basic_auth.dart';
import '../../utils/colors.dart';
import '../../providers/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'email_login.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({Key? key}) : super(key: key);

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  String? email = "";
  bool isChecked = false;
  bool buttonClicked = false;
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool spin = false;

  Future forgetPassword() async {
    dynamic convertedData;

    setState(() {
      spin = true;
    });
    Map data = {"email": "$email"};
    final response = await http.post(
      Uri.parse("https://denningportal.com/app/api/appapi/forgot_password"),
      headers: <String, String>{'authorization': BasicAuth.basicAuth},
      body: data,
    );

    if (response.statusCode == 200) {
      convertedData = json.decode(response.body);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 10),
        content: Text(
          "${convertedData['message']}",
          style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white,
              fontFamily: "Poppins-Regular"),
        ),
        backgroundColor: purple,
      ));
      setState(() {
        spin = false;
      });
      return convertedData;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "User ${convertedData['message']}",
          style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white,
              fontFamily: "Poppins-Regular"),
        ),
        backgroundColor: errorColor,
      ));
    }
  }
@override
  void dispose() {
    // TODO: implement dispose
  _emailController.dispose();
  super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    // final _height = MediaQuery.of(context).size.height -
    //     MediaQuery.of(context).padding.top -
    //     kToolbarHeight;
    // final _width = MediaQuery.of(context).size.width;
    final theme = Provider.of<ThemeChanger>(context);
    final isOnline = Provider.of<ConnectivityService>(context).isOnline;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Forgot Password",
          style: CustomTextStyle.AppBarHeading(
              context, theme.isDark ? white : black),
        ),
        elevation: 0,
        backgroundColor: theme.isDark ? cardColor : whiteBottomBar,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const EmailLogin()));
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18.sp,
            )),
        iconTheme: IconThemeData(color: theme.isDark ? white : black),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                top: 50.h, bottom: 20.h, left: 20.w, right: 20.w),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      theme.isDark
                          ? "assets/images/denning_logo_white.png"
                          : "assets/images/denning_logo_black.png",
                      width: 160.w,
                      height: 160.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 50.h,
                        child: VerticalDivider(
                          color: theme.isDark ? white : black,
                          thickness: 4,
                        ),
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      Text(
                        "Forget Password",
                        style: CustomTextStyle.heading1(
                            context, theme.isDark ? white : black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  CustomTextField(
                    cursorColor: theme.isDark ? white : black,
                    autofocus: true,
                    labelText: "Enter your email",
                    hintText: "Enter your email",
                    icon: Icon(
                      Icons.mail,
                      color: theme.isDark ? white : black,
                    ),
                    controller: _emailController,
                    onchanged: () {},
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                        return 'Enter a valid email!';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      email = value!;
                      return email;
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  spin == true
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: white,
                        ))
                      : CustomButtonW(
                          buttonText: "Send",
                          isChecked: isChecked,
                          buttonClicked: buttonClicked,
                          onPress: () async {
                            if (isOnline! == false) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                elevation: 1,
                                dismissDirection: DismissDirection.startToEnd,
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                  "Please enable your internet connection",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: white,
                                      fontFamily: "Poppins-Regular"),
                                ),
                                backgroundColor: Colors.red,
                              ));
                            } else if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              forgetPassword();
                              _formKey.currentState!.reset();
                            } else {

                            }
                          }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
