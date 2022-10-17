import 'dart:async';
import 'dart:io';
import 'package:denning_portal/screens/login_screens/forget_screen.dart';
import 'package:denning_portal/screens/login_screens/image_verification_desktop.dart';
import 'package:denning_portal/services/utilities/app_url.dart';
import 'package:denning_portal/services/utilities/basic_auth.dart';
import 'package:denning_portal/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_textStyle.dart';
import '../../custom_widgets/scaffold_messenge_snackbar.dart';
import '../../models/LoginModel.dart';
import '../../providers/internet_checker.dart';
import '../../providers/theme.dart';
import '../../services/utilities/authication_check.dart';

class EmailLogin extends StatefulWidget {
  const EmailLogin({Key? key}) : super(key: key);

  @override
  State<EmailLogin> createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  bool isChecked = false;
  bool buttonClicked = false;
  bool forEye = false;

  bool isPassword = true;

  //String name,email,phone;
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loader = false;
  String? email = "";
  String? email2 = "";

  String? password = "";
  String? password2 = "";

  Future<LoginModel?>? postData() async {
    setState(() {
      loader = true;
    });

    try {


      Map data = {"email": email, "password": password};
      http.Response response = await http
          .post(
        Uri.parse("${AppUrl.login}"),
        headers: <String, String>{'authorization': BasicAuth.basicAuth},
        body: data,
      )
          .timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        if(response.body.isNotEmpty) {
          final result = json.decode(response.body);
          if (result['status'] == 200) {
            final loginModelValues = LoginModel.fromJson(result);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('studentId', loginModelValues.studentId!);
            prefs.setString('image', loginModelValues.image!);
            prefs.setString('studentCode', loginModelValues.studentCode!);
            prefs.setString('name', loginModelValues.name!);
            prefs.setString('email', loginModelValues.email!);
            prefs.setString('address', loginModelValues.address!);
            prefs.setString('phone', loginModelValues.phone!);
            prefs.setString('phoneFormatted', loginModelValues.phoneFormatted!);
            prefs.setString('name', loginModelValues.name!);
            prefs.setString('birthday', loginModelValues.birthday!);
            prefs.setString('gender', loginModelValues.gender!);
            prefs.setBool('validity', loginModelValues.validity!);
            prefs.setString('token', loginModelValues.token!);
            prefs.setString('academicYear', loginModelValues.academicYear!);
            loginModelValues.programmeName == null ? prefs.setString('programmeName','') : prefs.setString('programmeName',loginModelValues.programmeName!);
            loginModelValues.schoolName == null ? prefs.setString('schoolName',"Denning") : prefs.setString('schoolName',loginModelValues.schoolName! );
            loginModelValues.schoolLogo == null ? prefs.setString('schoolLogo',"assets/images/denning_logo_white.png") : prefs.setString('schoolLogo',loginModelValues.schoolLogo! );
            prefs.setString('studentQrcode', loginModelValues.studentQrcode!);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ImageVerificationDesktop(
                      token: "${loginModelValues.token}",
                    )),
                    (Route<dynamic> route) => false);
            CustomScaffoldWidget.buildSuccessSnackbar(
                context, "${result["message"]}");
          } else if (result['status'] == 401) {
            CustomScaffoldWidget.buildErrorSnackbar(
                context, "${result["message"]}");
          }    else if(result['status'] == 404){
            CustomScaffoldWidget.buildErrorSnackbar(context, "${result['message']}");
          } else {
            CustomScaffoldWidget.buildErrorSnackbar(
                context, "${result["message"]}");
          }
        } }else {
        AuthChecker.exceptionHandling(context, response.statusCode);
      }
    } on TimeoutException catch (e) {
      CustomScaffoldWidget.buildErrorSnackbar(context, "Time out try again");
    } on SocketException catch (e) {
      CustomScaffoldWidget.buildErrorSnackbar(
          context, "Please enable your internet connection $e");
    } on Error catch (e) {
      CustomScaffoldWidget.buildErrorSnackbar(
          context, "Something went wrong");
    }
  }

  Future<void> getUser() async {
    SharedPreferences remeberMePrefs = await SharedPreferences.getInstance();
    setState(() {
      emailController.text = remeberMePrefs.getString('email2')!;
      passwordController.text = remeberMePrefs.getString('password')!;
      isChecked = remeberMePrefs.getBool("remember_me")!;
      if (isChecked == false) {
        setState(() {
          isChecked = false;

          remeberMePrefs.remove("email2");
          remeberMePrefs.remove("password");
          remeberMePrefs.remove("remember_me");
        });
      } else {
        setState(() {
          isChecked = true;
        });
      }
    });
  }

  void _handleRemeberme(bool? value) {
    setState(() {
      if (value == false) {
        isChecked = value!;
        SharedPreferences.getInstance().then(
              (remeberMePrefs) {
            remeberMePrefs.setBool("remember_me", false);
            remeberMePrefs.setString('email2', "");
            remeberMePrefs.setString('password', "");
          },
        );
      } else {
        isChecked = value!;
        SharedPreferences.getInstance().then(
              (remeberMePrefs) {
            remeberMePrefs.setBool("remember_me", true);
            remeberMePrefs.setString('email2', emailController.text);
            remeberMePrefs.setString('password', passwordController.text);
          },
        );
      }
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    final theme = Provider.of<ThemeChanger>(context);
    final isOnline = Provider.of<ConnectivityService>(context).isOnline;

    return Scaffold(
      backgroundColor: theme.isDark ? black : white,
      body: Stack(
        children: [
          Container(
            height: 690.h,
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding:
                    EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 40.h,
                          ),
                          Image.asset(
                            theme.isDark
                                ? "assets/images/denning_logo_white.png"
                                : "assets/images/denning_logo_black.png",
                            width: 160.w,
                            height: 160.h,
                            fit: BoxFit.contain,
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
                                width: 10.w,
                              ),
                              Text(
                                "Login",
                                style: CustomTextStyle.heading1(
                                    context, theme.isDark ? white : black),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Padding(
                            padding: EdgeInsets.all(_width * 0.01),
                            child: Theme(
                              child: TextFormField(
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.left,
                                autofocus: false,
                                controller: emailController,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                cursorColor: theme.isDark ? white : black,
                                style: TextStyle(
                                    color: theme.isDark ? white : black),
                                decoration: InputDecoration(
                                    contentPadding:
                                    EdgeInsets.symmetric(vertical: 20),
                                    labelText: "Enter your email",
                                    fillColor: white,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: theme.isDark ? white : black,
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    enabledBorder: new OutlineInputBorder(
                                      borderRadius:
                                      new BorderRadius.circular(10.0),
                                      borderSide: new BorderSide(
                                          color: theme.isDark ? white : black),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: errorColor,
                                        )),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: errorColor,
                                      ),
                                    ),
                                    alignLabelWithHint: true,
                                    errorStyle: TextStyle(color: errorColor),
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.mail,
                                      color: theme.isDark ? white : black,
                                    ),
                                    hintText: "Enter your email",
                                    hintStyle: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                    ),
                                    labelStyle: TextStyle(
                                        color: theme.isDark ? white : black,
                                        fontFamily: "Poppins-Regular",
                                        fontSize: 12.sp)),
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
                                },
                              ),
                              data: Theme.of(context).copyWith(
                                primaryColor: theme.isDark ? white : black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: EdgeInsets.all(_width * 0.01),
                            child: Theme(
                              child: TextFormField(
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.left,
                                autofocus: false,
                                controller: passwordController,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                cursorColor: theme.isDark ? white : black,
                                obscureText: isPassword,
                                style: TextStyle(
                                    color: theme.isDark ? white : black),
                                decoration: InputDecoration(
                                    contentPadding:
                                    EdgeInsets.symmetric(vertical: 20),
                                    labelText: "Enter your password",
                                    fillColor: white,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: theme.isDark ? white : black,
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    enabledBorder: new OutlineInputBorder(
                                      borderRadius:
                                      new BorderRadius.circular(10.0),
                                      borderSide: new BorderSide(
                                          color: theme.isDark ? white : black),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: errorColor,
                                        )),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: errorColor,
                                      ),
                                    ),
                                    alignLabelWithHint: true,
                                    errorStyle: TextStyle(color: errorColor),
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: theme.isDark ? white : black,
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isPassword = !isPassword;
                                        });
                                      },
                                      child: isPassword == false
                                          ? Icon(
                                        Icons.visibility,
                                        color:
                                        theme.isDark ? white : black,
                                      )
                                          : Icon(
                                        Icons.visibility_off,
                                        color:
                                        theme.isDark ? white : black,
                                      ),
                                    ),
                                    hintText: "Enter your password",
                                    hintStyle: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                    ),
                                    labelStyle: TextStyle(
                                        color: theme.isDark ? white : black,
                                        fontFamily: "Poppins-Regular",
                                        fontSize: 12.sp)),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter your password';
                                  }
                                  return null;
                                },
                                onSaved: (String? value) {
                                  password = value!;
                                },
                              ),
                              data: Theme.of(context).copyWith(
                                primaryColor: theme.isDark ? white : black,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: _handleRemeberme,
                                side: BorderSide(
                                  color: theme.isDark ? white : black,
                                ),
                                checkColor: theme.isDark ? black : white,
                                hoverColor: theme.isDark ? white : black,
                                activeColor: theme.isDark ? white : black,
                                materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                              ),
                              Text(
                                "Remember me",
                                style: CustomTextStyle.bodyRegular(
                                    context, theme.isDark ? white : black),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgetScreen()));
                                },
                                child: Text(
                                  "Forget Password ?",
                                  style: CustomTextStyle.bodyRegular(
                                      context, theme.isDark ? white : black),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          CustomButtonW(
                            buttonText: "Login",
                            isChecked: isChecked,
                            buttonClicked: buttonClicked,
                            onPress: () async {
                              if (isOnline! == false) {
                                CustomScaffoldWidget.buildErrorSnackbar(context,
                                    "Please enable your internet connection");
                              } else if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                postData();
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
