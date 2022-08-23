import 'dart:async';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../custom_widgets/custom_textStyle.dart';
import '../../../custom_widgets/scaffold_messenge_snackbar.dart';
import '../../../providers/internet_checker.dart';
import '../../../services/utilities/app_url.dart';
import '../../../services/utilities/authication_check.dart';
import '../../../services/utilities/basic_auth.dart';
import '../../../utils/colors.dart';
import '../../../providers/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../login_screens/email_login.dart';
class AddInquiry extends StatefulWidget {
  const AddInquiry({Key? key}) : super(key: key);

  @override
  State<AddInquiry> createState() => _AddInquiryState();
}

class _AddInquiryState extends State<AddInquiry> {
  bool attachmentClicked = false;
  bool buttonClicked = false;
  var depart ="Select Department";
  var prior ="Select Priority";
  String? studentId;
  String? token;
  String? status;
  String? subject;
  String? inquiry;
  bool loader_visible = false;
  final List<String> departments = [
    "admin-3",
    'teacher-5',
    'student_affair-1',
  ];
  final List<String> departments_show = [
    "Admin",
    'Teacher',
    'Student Affair',
  ];
  final List<String> priority = [
    "High",
    'Medium',
    'Low',
  ];
  String? department_name = 'Select Department';
  String? priority_name = "Select Priority";

  final _formKey = GlobalKey<FormState>();
  String dropdownValue = 'One';
  PlatformFile? objFile;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // token = prefs.getString('token')!;
      // studentId = prefs.getString('studentId')!;
      // status = prefs.getString('status')!;
    });
  }

  void uploadSelectedFile() async {
    String dateTimeSend = dateFormat.format(DateTime.now());
    //---Create http package multipart request object
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse("${AppUrl.baseUrl}set_messages"),
      );

      request.headers
          .addAll(<String, String>{'authorization': BasicAuth.basicAuth});

      //-----add other fields if needed
      request.fields["type"] = "inquiry";
      request.fields["inquiry_thread_code"] = '';
      request.fields["subject"] = "${subject}";
      request.fields["priority"] = "${prior}";
      request.fields["inquiry"] = "${inquiry}";
      request.fields["status"] = "${status}";
      request.fields["sender"] = "student-${studentId}";
      request.fields["reciever"] = "${depart}";
      request.fields["timestamp"] = "${dateTimeSend}";
      request.fields["read_status"] = "0";
      request.fields["student_id"] = "${studentId}";
      request.fields["auth_token"] = "${token}";

      if (objFile == null) {
        request.fields["attached_file_name"] = '';
      } else {
        request.files.add(http.MultipartFile(
            "attached_file_name", objFile!.readStream!, objFile!.size,
            filename: objFile!.name));
      }

      //-------Send request
      var resp = await request.send();
      if (resp.statusCode == 200) {
        //------Read response
        showToast();
        var response = await http.Response.fromStream(resp);
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        if (result['status'] == 200) {
          CustomScaffoldWidget.buildSuccessSnackbar(
              context, "${result['message']}");
          Navigator.pop(context);
        } else if (result['status'] == 401 &&
            result['message'] == 'auth_token_expired') {
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
        }else if(result['status'] == 401) {
          CustomScaffoldWidget.buildErrorSnackbar(
              context, "${ result['message']}");
        }
      } else {
        AuthChecker.exceptionHandling(context, resp.statusCode);
      }
    } on TimeoutException  {
      CustomScaffoldWidget.buildErrorSnackbar(context, "Time out try again");
    } on SocketException {
      CustomScaffoldWidget.buildErrorSnackbar(
          context, "Please enable your internet connection");
    } on Error {
      CustomScaffoldWidget.buildErrorSnackbar(context, "Something went wrong");
    }
  }
  void showToast() {

    setState(() {
      loader_visible = false;

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    final isOnline = Provider.of<ConnectivityService>(context).isOnline;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Inquiry",
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
      body: Padding(
        padding: EdgeInsets.only(left: 15.w, right: 15.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  height: 55.h,
                  child: DropdownButtonFormField2(
                    focusColor: theme.isDark ? cardColor : whiteBottomBar,
                    decoration: InputDecoration(
                      fillColor: theme.isDark ? cardColor : white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: theme.isDark ? white : black, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        borderSide:
                        new BorderSide(color: theme.isDark ? white : black),
                      ),
                      border: InputBorder.none,
                      hintStyle: CustomTextStyle.bodyRegular(
                          context, theme.isDark ? white : black),
                      labelStyle: CustomTextStyle.bodyRegular(
                          context, theme.isDark ? white : black),
                    ),
                    isExpanded: true,
                    hint: Text(
                      '${department_name}',
                      style: TextStyle(
                          color: theme.isDark ? white : black,
                          fontFamily: "Poppins-Regular",
                          fontSize: 13.sp),
                    ),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: theme.isDark ? white : black,
                    ),
                    iconSize: 25.sp,
                    buttonPadding: EdgeInsets.only(left: 5.w, right: 5.w),
                    dropdownDecoration: BoxDecoration(
                        color: theme.isDark ? cardColor : whiteBottomBar,
                        border: Border.all(color: theme.isDark ? white : black),
                        borderRadius: BorderRadius.circular(10.0)),
                    items: departments_show
                        .map((item) => DropdownMenuItem<String>(
                      value: item,
                      onTap: () => null,
                      enabled: true,
                      child: Text(
                        item,
                        style: CustomTextStyle.bodyRegular(
                            context, theme.isDark ? white : black),
                      ),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        if (value.toString() == "Admin") {
                          depart = departments[0];
                        } else if (value.toString() == "Teacher") {
                          depart = departments[1];
                        } else {
                          depart = departments[2];
                        }
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  height: 55.h,
                  child: DropdownButtonFormField2(
                    focusColor: theme.isDark ? cardColor : whiteBottomBar,
                    decoration: InputDecoration(
                      fillColor: theme.isDark ? white : black,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: theme.isDark ? white : black, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        borderSide:
                        new BorderSide(color: theme.isDark ? white : black),
                      ),
                      border: InputBorder.none,
                      hintStyle: CustomTextStyle.bodyRegular(
                          context, theme.isDark ? white : black),
                      labelStyle: CustomTextStyle.bodyRegular(
                          context, theme.isDark ? white : black),
                    ),
                    isExpanded: true,
                    hint: Text(
                      '$priority_name',
                      style: TextStyle(
                          color: theme.isDark ? white : black,
                          fontFamily: "Poppins-Regular",
                          fontSize: 13.sp),
                    ),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: theme.isDark ? white : black,
                    ),
                    iconSize: 25.sp,
                    buttonPadding: EdgeInsets.only(left: 5.w, right: 5.w),
                    dropdownDecoration: BoxDecoration(
                        color: theme.isDark ? cardColor : whiteBottomBar,
                        border: Border.all(color: theme.isDark ? white : black),
                        borderRadius: BorderRadius.circular(10.0)),
                    items: priority
                        .map((item) => DropdownMenuItem<String>(
                      value: item,
                      onTap: () => null,
                      enabled: true,
                      child: Text(
                        item,
                        style: CustomTextStyle.bodyRegular(
                            context, theme.isDark ? white : black),
                      ),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        prior = value.toString();
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Theme(
                  child: TextFormField(
                    cursorColor: theme.isDark ? white : black,
                    style: TextStyle(color: theme.isDark ? white : black),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: "Subject",
                      fillColor: theme.isDark ? white : black,
                      contentPadding: EdgeInsets.only(right: 25.0 , left: 25.0 ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: theme.isDark ? white : black, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        borderSide:
                        new BorderSide(color: theme.isDark ? white : black),
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
                      hintText: "Enter your subject",
                      hintStyle: CustomTextStyle.bodyRegular(
                          context, theme.isDark ? white : black),
                      alignLabelWithHint: true,
                      labelStyle: CustomTextStyle.bodyRegular(
                          context, theme.isDark ? white : black),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter subject';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      subject = value;
                    },
                  ),
                  data: Theme.of(context).copyWith(
                    primaryColor: theme.isDark ? white : black,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Theme(
                  child: Container(
                    height: 150.h,
                    width: double.infinity,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 10,
                      cursorColor: theme.isDark ? white : black,
                      style: TextStyle(color: theme.isDark ? white : black),
                      decoration: InputDecoration(
                        labelText: "Write your inquiry",
                        contentPadding: EdgeInsets.only(right: 25.0 , left: 25.0 , top: 30.0 , bottom: 20.0),
                        fillColor: theme.isDark ? white : black,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: theme.isDark ? white : black, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: new BorderSide(
                              color: theme.isDark ? white : black),
                        ),
                        errorBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
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
                        hintText: "Your Inquiry",
                        hintStyle: CustomTextStyle.bodyRegular(
                            context, theme.isDark ? white : black),
                        alignLabelWithHint: true,
                        labelStyle: CustomTextStyle.bodyRegular(
                            context, theme.isDark ? white : black),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please write query';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        inquiry = value;
                      },
                    ),
                  ),
                  data: Theme.of(context).copyWith(
                    primaryColor: theme.isDark ? white : black,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    objFile != null
                        ? Flexible(
                      child: Text(
                        "Attached ${objFile?.name}",
                        style: TextStyle(
                            color: theme.isDark ? white : black,
                            fontFamily: "Poppins-Regular",
                            fontSize: 12),
                        maxLines:  2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                        : Text(
                      "No file selected",
                      style: TextStyle(
                          color: Colors.red,
                          fontFamily: "Poppins-Regular",
                          fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40.h,
                ),
                Row(
                  children: [
                    Tooltip(
                      message: "Attach File",
                      textStyle: TextStyle(color: Colors.red),
                      height: 20,
                      child: FloatingActionButton(
                        onPressed: () async {
                          var result = await FilePicker.platform.pickFiles( type: FileType.custom,
                              allowedExtensions: [
                                'jpg',
                                'pdf',
                                'png',
                                'gif'
                              ],
                              withReadStream:
                              true // this will return PlatformFile object with read stream
                          );

                          if (result != null) {
                            setState(() {
                              objFile = result.files.single;
                            });
                          } else {
                            objFile = null;
                          }
                        },
                        child: Icon(
                          Icons.attach_file_rounded,
                          color: white,
                          size: 21.sp,
                        ),
                        backgroundColor: purple,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: Container(
                        height: 50.h,
                        child: MaterialButton(
                          elevation: 0,
                          child: loader_visible ? CircularProgressIndicator(color: theme.isDark ? black : white) : Text(
                            'Send',
                            style: CustomTextStyle.bodyRegular(
                                context, theme.isDark ? black : white),
                          ),
                          textColor: theme.isDark ? black : white,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          color: theme.isDark ? white : black,
                          onPressed: () {

                            var file_size = objFile?.size;
                            if (isOnline! == false) {
                              CustomScaffoldWidget.buildErrorSnackbar(context,
                                  "Please enable your internet connection");
                            } else if(file_size != null && file_size> 1000000){
                              CustomScaffoldWidget.buildErrorSnackbar(
                                  context, "image size is too large select less than 1 MB");
                            }else if (depart == 'Select Department'){
                              CustomScaffoldWidget.buildErrorSnackbar(context, "Select Department");
                            }else if (prior == 'Select Priority'){
                              CustomScaffoldWidget.buildErrorSnackbar(context, "Select Priority");
                            } else {
                              setState(() {
                                loader_visible = true;
                              });
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                uploadSelectedFile();
                                _formKey.currentState!.reset();
                              }
                              else {
                                loader_visible = false;
                              }
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}