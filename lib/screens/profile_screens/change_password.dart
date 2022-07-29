import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../custom_widgets/custom_button.dart';
import '../../../custom_widgets/custom_textFormField.dart';
import '../../../utils/colors.dart';
import '../../custom_widgets/custom_textStyle.dart';
import '../../custom_widgets/scaffold_messenge_snackbar.dart';
import '../../providers/internet_checker.dart';
import '../../services/utilities/app_url.dart';
import '../../services/utilities/authication_check.dart';
import '../../services/utilities/basic_auth.dart';
import '../../providers/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../login_screens/email_login.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  String? token = "";
  String? studentId = "";
  bool isChecked = false;
  bool buttonClicked = false;
  bool isPassword = true;
  bool isNewPassword = true;
  bool isConfirmPassword = true;
  String? currentPassword = "";
  String? newPassword = "";
  String? confirmPassword = "";
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool spin = false;

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token')!;
      studentId = prefs.getString('studentId');
    });
  }

  Future changePassword() async {
    if (newPassword == confirmPassword) {
      var convertedData;

      setState(() {
        spin = true;
      });

      try {
        Map data = {
          "student_id": "${studentId}",
          "auth_token": "${token}",
          "current_password": "${currentPassword}",
          "new_password": "${newPassword}",
          "confirm_password": "${confirmPassword}"
        };
        final response = await http
            .post(
          Uri.parse("${AppUrl.baseUrl}change_password"),
          headers: <String, String>{'authorization': BasicAuth.basicAuth},
          body: data,
        )
            .timeout(const Duration(seconds: 60));

        if (response.statusCode == 200) {
          convertedData = json.decode(response.body);
          if(convertedData['status'] == 200){
            CustomScaffoldWidget.buildSuccessSnackbar(
                context, "${"${convertedData['message']}"}");
            setState(() {
              spin = false;
            });
            return convertedData;
          }
          else if (convertedData['status'] == 401 &&
              convertedData['message'] == 'auth_token_expired') {
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
            CustomScaffoldWidget.buildErrorSnackbar(context,
                "Your Session has been expired, please try to login again");
          }
          else if (convertedData['status'] == 401){
            CustomScaffoldWidget.buildErrorSnackbar(context,
                "${convertedData['message']}");
            setState(() {
              spin = false;
            });
          }
          else if(convertedData['status'] == 404){
            CustomScaffoldWidget.buildErrorSnackbar(context, "${convertedData['message']}");
          }

        } else {
          AuthChecker.exceptionHandling(context, response.statusCode);
        }
      } on TimeoutException catch (e) {
        CustomScaffoldWidget.buildErrorSnackbar(context, "Time out try again");
      } on SocketException catch (e) {
        CustomScaffoldWidget.buildErrorSnackbar(
            context, "Please enable your internet connection");
      } on Error catch (e) {
        CustomScaffoldWidget.buildErrorSnackbar(
            context, "Something went wrong");
      }
    } else {
      CustomScaffoldWidget.buildErrorSnackbar(
          context, "New Password and Confirm Password does not match");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
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
      appBar: AppBar(
        title: Text(
          "Change Password",
          style: CustomTextStyle.AppBarHeading(
              context, theme.isDark ? white : black),
        ),
        elevation: 0,
        backgroundColor: theme.isDark ? cardColor : whiteBottomBar,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 50.h,
                        child: VerticalDivider(
                          color: theme.isDark ? white : black,
                          thickness: 5,
                        ),
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      Text(
                        "Change Password",
                        style: CustomTextStyle.headingSemiBold(
                            context, theme.isDark ? white : black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  CustomTextField(
                      cursorColor: theme.isDark ? white : black,
                      gestureDetector: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPassword = !isPassword;
                          });
                        },
                        child: isPassword == false
                            ? Icon(
                          Icons.visibility,
                          color: theme.isDark ? white : black,
                        )
                            : Icon(
                          Icons.visibility_off,
                          color: theme.isDark ? white : black,
                        ),
                      ),
                      autofocus: true,
                      isPassword: isPassword,
                      labelText: "Current password",
                      hintText: "Current password",
                      icon: Icon(
                        Icons.lock,
                        color: theme.isDark ? white : black,
                      ),
                      controller: _currentPasswordController,
                      onchanged: () {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your current password';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        currentPassword = value!;
                        // ,
                      }),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomTextField(
                      cursorColor: theme.isDark ? white : black,
                      gestureDetector: GestureDetector(
                        onTap: () {
                          setState(() {
                            isNewPassword = !isNewPassword;
                          });
                        },
                        child: isNewPassword == false
                            ? Icon(
                          Icons.visibility,
                          color: theme.isDark ? white : black,
                        )
                            : Icon(
                          Icons.visibility_off,
                          color: theme.isDark ? white : black,
                        ),
                      ),
                      autofocus: true,
                      isPassword: isNewPassword,
                      labelText: "New password",
                      hintText: "New password",
                      icon: Icon(
                        Icons.lock,
                        color: theme.isDark ? white : black,
                      ),
                      controller: _newPasswordController,
                      onchanged: () {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter new password';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        newPassword = value!;
                      }),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomTextField(
                      cursorColor: theme.isDark ? white : black,
                      gestureDetector: GestureDetector(
                        onTap: () {
                          setState(() {
                            isConfirmPassword = !isConfirmPassword;
                          });
                        },
                        child: isConfirmPassword == false
                            ? Icon(
                          Icons.visibility,
                          color: theme.isDark ? white : black,
                        )
                            : Icon(
                          Icons.visibility_off,
                          color: theme.isDark ? white : black,
                        ),
                      ),
                      autofocus: true,
                      isPassword: isConfirmPassword,
                      labelText: "Confirm new password",
                      hintText: "Confirm new password",
                      icon: Icon(
                        Icons.lock,
                        color: theme.isDark ? white : black,
                      ),
                      controller: _confirmPasswordController,
                      onchanged: () {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter confirm password';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        confirmPassword = value!;
                        // ,
                      }),
                  SizedBox(
                    height: 20.h,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  spin == true
                      ? Center(
                      child: CircularProgressIndicator(
                        color: theme.isDark ? white : black,
                      ))
                      : CustomButtonW(
                    buttonText: "Change password",
                    isChecked: isChecked,
                    buttonClicked: buttonClicked,
                    onPress: () {
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
                        changePassword();
                        _formKey.currentState!.reset();

                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
