
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../custom_widgets/custom_textStyle.dart';
import '../../../services/utilities/basic_auth.dart';
import '../../../utils/colors.dart';
import '../../providers/theme.dart';
import 'package:http/http.dart' as http;


class AddInquiry extends StatefulWidget {
  const AddInquiry({Key? key}) : super(key: key);

  @override
  State<AddInquiry> createState() => _AddInquiryState();
}

class _AddInquiryState extends State<AddInquiry> {
  bool attachmentClicked = false;
  bool buttonClicked = false;
  var depart;
  var prior;

  final List<String> departments = [
    "admin-3",
    'teacher-5',
    'student_affair-1',
  ];
  final List<String> priority = [
    "High",
    'Medium',
    'Low',
  ];
  String? selectedValue;

  final _formKey = GlobalKey<FormState>();
  String dropdownValue = 'One';
  PlatformFile? objFile;

  void uploadSelectedFile() async {
    //---Create http package multipart request object
    final request = http.MultipartRequest(
      "POST",
      Uri.parse("https://denningportal.com/app/api/appapi/set_messages"),
    );

    request.headers
        .addAll(<String, String>{'authorization': BasicAuth.basicAuth});

    //-----add other fields if needed
    request.fields["type"] = "inquiry";
    request.fields["inquiry_thread_code"] = "Rizwan";
    request.fields["subject"] = "abc";
    request.fields["priority"] = "abc";
    request.fields["inquiry"] = "abc";
    request.fields["status"] = "abc";
    request.fields["sender"] = "student";
    request.fields["reciever"] = "admin";
    request.fields["timestamp"] = "222";
    request.fields["read_status"] = "1";
    request.fields["student_id"] = "26";
    request.fields["auth_token"] =
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdGF0dXMiOjIwMCwibWVzc2FnZSI6IkxvZ2dlZGluIFN1Y2Nlc3NmdWxseSIsInN0dWRlbnRfaWQiOiIyNiIsInN0dWRlbnRfY29kZSI6IkRMUy0yMDE5LTAwNDAiLCJuYW1lIjoiTXVoYW1tYWQgU2FtYWltIiwiZW1haWwiOiJtdWhhbW1hZC5zYW1haW0uMDA0MEBkZW5uaW5nc3R1ZGVudHMuY29tIiwiYWRkcmVzcyI6IjUwMS01Zmxvb3Igc3VuIHJlc2lkZW5jeSBvcHAgZGFuaXNoIG1vdG9ycyBraGFsaWQgYmluIHdhbGVlZCByb2FkIiwicGhvbmUiOiIwMzAyLTI4NzU2NTEiLCJwaG9uZV9mb3JtYXR0ZWQiOiI5MjMwMjI4NzU2NTEiLCJiaXJ0aGRheSI6IjA5LUp1bi0yMDAwIiwiZ2VuZGVyIjoibWFsZSIsImltYWdlIjoiaHR0cHM6XC9cL2Rlbm5pbmdwb3J0YWwuY29tXC9kcG9ydGFsXC91cGxvYWRzXC9zdHVkZW50X2ltYWdlXC8yNi5qcGciLCJ2YWxpZGl0eSI6dHJ1ZX0.fryeP2djaRvEc9-zvmPEUJeGoARgvJYMWGvDzFeENRI";

    request.files.add(new http.MultipartFile(
        "attached_file_name", objFile!.readStream!, objFile!.size,
        filename: objFile!.name));

    //-------Send request
    var resp = await request.send();

    //------Read response
    String result = await resp.stream.bytesToString();

    //-------Your response
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    final theme = Provider.of<ThemeChanger>(context);
    print("File Path : ${objFile}");
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
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Container(
                height: 60.h,
                child: DropdownButtonFormField2(
                  focusColor: theme.isDark ? white : black,
                  decoration: InputDecoration(
                    fillColor: theme.isDark ? white : black,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: theme.isDark ? white : black, width: 2.0),
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
                  hint: const Text(
                    'Select Department',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins-Regular",
                        fontSize: 12),
                  ),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: theme.isDark ? white : black,
                  ),
                  iconSize: 30,
                  buttonPadding: EdgeInsets.only(left: 10.w, right: 10.w),
                  dropdownDecoration: BoxDecoration(
                      color: theme.isDark ? cardColor : whiteBottomBar,
                      border: Border.all(color: theme.isDark ? white : black),
                      borderRadius: BorderRadius.circular(10.0)),
                  items: departments
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
                      depart = value.toString();
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                height: 60.h,
                child: DropdownButtonFormField2(
                  focusColor: theme.isDark ? white : black,
                  decoration: InputDecoration(
                    fillColor: theme.isDark ? white : black,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: theme.isDark ? white : black, width: 2.0),
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
                  hint: const Text(
                    'Select Priority',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins-Regular",
                        fontSize: 12),
                  ),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: theme.isDark ? white : black,
                  ),
                  iconSize: 30,
                  buttonPadding: EdgeInsets.only(left: 10.w, right: 10.w),
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
                  cursorColor: white,
                  style: TextStyle(color: theme.isDark ? white : black),
                  decoration: InputDecoration(
                    labelText: "Type Subject",
                    fillColor: theme.isDark ? white : black,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: theme.isDark ? white : black, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide:
                          new BorderSide(color: theme.isDark ? white : black),
                    ),
                    border: InputBorder.none,
                    hintText: "Subject",
                    hintStyle: CustomTextStyle.bodyRegular(
                        context, theme.isDark ? white : black),
                    labelStyle: CustomTextStyle.bodyRegular(
                        context, theme.isDark ? white : black),
                  ),
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
                    maxLines: 10,
                    cursorColor: theme.isDark ? white : black,
                    style: TextStyle(color: theme.isDark ? white : black),
                    decoration: InputDecoration(
                      labelText: "Write your inquiry",
                      fillColor: white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: theme.isDark ? white : black, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        borderSide:
                            new BorderSide(color: theme.isDark ? white : black),
                      ),
                      border: InputBorder.none,
                      hintText: "Your Inquiry",
                      hintStyle: CustomTextStyle.bodyRegular(
                          context, theme.isDark ? white : black),
                      alignLabelWithHint: true,
                      labelStyle: CustomTextStyle.bodyRegular(
                          context, theme.isDark ? white : black),
                    ),
                  ),
                ),
                data: Theme.of(context).copyWith(
                  primaryColor: theme.isDark ? white : black,
                ),
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
                        var result = await FilePicker.platform.pickFiles(
                            withReadStream:
                                true // this will return PlatformFile object with read stream
                            );

                        if (result != null) {
                          setState(() {
                            objFile = result.files.single;
                          });
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
                      child: new MaterialButton(
                        elevation: 0,
                        child: new Text(
                          'Send',
                          style: CustomTextStyle.bodyRegular(
                              context, theme.isDark ? black : white),
                        ),
                        textColor: theme.isDark ? black : white,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        color: theme.isDark ? white : black,
                        onPressed: () {
                          uploadSelectedFile();
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
    );
  }
}
