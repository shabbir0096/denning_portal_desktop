import 'dart:async';
import 'dart:io';

import 'package:denning_portal/component/student_bottom_navigation.dart';
import 'package:denning_portal/custom_widgets/no_internet_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../component/webview_display_desktop.dart';
import '../../../component/webview_display_macos.dart';
import '../../../custom_widgets/custom_textStyle.dart';
import '../../../custom_widgets/scaffold_messenge_snackbar.dart';
import '../../../providers/internet_checker.dart';
import '../../../services/utilities/app_url.dart';
import '../../../services/utilities/authication_check.dart';
import '../../../services/utilities/basic_auth.dart';
import '../../../utils/colors.dart';
import '../../../utils/config.dart';
import '../../../providers/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../login_screens/email_login.dart';
class InquiryChatScreen extends StatefulWidget {
  var data;

  InquiryChatScreen(this.data);

  @override
  State<InquiryChatScreen> createState() => _InquiryChatScreenState();
}

class _InquiryChatScreenState extends State<InquiryChatScreen> {
  ScrollController _scrollController =
  ScrollController(initialScrollOffset: 99999999.0);
  TextEditingController message = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var file_size;
  PlatformFile? objFile;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  String? studentId;
  String? token;
  String? status;
  String? subject;
  String? inquiry;
  bool _isVisible = false;
  bool loader_visible = false;
  List<String> fileTypes_list = [
    "JPG",
    "JPEG",
    "PNG",
    "GIF",
    "jpg",
    "jpeg",
    "png",
    "gif"];
  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token')!;
      studentId = prefs.getString('studentId')!;
      status = prefs.getString('status');
    });
  }

  void uploadSelectedFile(String inquiryThreadCode, String sender,
      String reciever, String priority) async {
    String dateTimeSend = dateFormat.format(DateTime.now());
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse("${AppUrl.baseUrl}set_messages"),
      );

      request.headers
          .addAll(<String, String>{'authorization': BasicAuth.basicAuth});

      //-----add other fields if needed
      request.fields["type"] = "inquiry";
      request.fields["inquiry_thread_code"] = '${inquiryThreadCode}';
      request.fields["subject"] = '';
      request.fields["priority"] = "${priority}";
      request.fields["inquiry"] = "${inquiry}";
      request.fields["status"] = "${status}";
      request.fields["sender"] = "${sender}";
      request.fields["reciever"] = "${reciever}";
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
        showToast();
        //------Read response
        var response = await http.Response.fromStream(resp);
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        if (result['status'] == 200) {
          CustomScaffoldWidget.buildSuccessSnackbar(
              context, "${result['message']}");
        } else if (result['status'] == 401) {
          CustomScaffoldWidget.buildErrorSnackbar(
              context, "${result['message']}");
        } else {
          CustomScaffoldWidget.buildSuccessSnackbar(
              context, "Something went wrong");
        }
      } else {
        AuthChecker.exceptionHandling(context, resp.statusCode);
      }
    } on TimeoutException catch (e) {
      CustomScaffoldWidget.buildErrorSnackbar(context, "Time out try again");
    } on SocketException catch (e) {
      CustomScaffoldWidget.buildErrorSnackbar(
          context, "Please enable your internet connection");
    } on Error catch (e) {
      CustomScaffoldWidget.buildErrorSnackbar(context, "Something went wrong");
    }
  }

  Future getSpecificInquiryChat() async {
    var convertedData;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
    studentId = prefs.getString('studentId')!;
    status = "approved";

    try {
      final response = await http.get(
        Uri.parse(
            "${AppUrl.baseUrl}messages_data?auth_token=${token}&student_id=${studentId}&type=inquiry&inquiry_thread_code=${widget.data[1] == null ? widget.data['inquiry_thread_code'] : widget.data[1]}"),
        headers: <String, String>{'authorization': BasicAuth.basicAuth},
      );

      if (response.statusCode == 200) {
        convertedData = json.decode(response.body);
        if (convertedData['status'] == 200) {
          return convertedData;
        } else if (convertedData['status'] == 401 &&
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
        } else if (convertedData['status'] == 401) {
          CustomScaffoldWidget.buildErrorSnackbar(
              context, "${convertedData['message']}");
        }else {
          CustomScaffoldWidget.buildSuccessSnackbar(
              context, "Something went wrong");
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
      CustomScaffoldWidget.buildErrorSnackbar(context, "Something went wrong");
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
    super.initState();
    getUser();
  }
  void showToast() {
    setState(() {
      _isVisible = !_isVisible;
      loader_visible = false;
      objFile = null;
    });
  }
  @override
  Widget build(BuildContext context) {

    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    final theme = Provider.of<ThemeChanger>(context);
    final isOnline = Provider.of<ConnectivityService>(context).isOnline;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "${widget.data[0] == null ? widget.data['reciever_data']['reciever_name'] : widget.data[0]}",
          style: CustomTextStyle.AppBarHeading(
              context, theme.isDark ? white : black),
        ),
        elevation: 0,
        backgroundColor: theme.isDark ? cardColor : whiteBottomBar,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                      new StudentBottomNavigation()),
                      (Route<dynamic> route) => false);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18.sp,
            )),
        iconTheme: IconThemeData(color: theme.isDark ? white : black),
      ),
      body: isOnline!
          ?Form(
        key: _formKey,
        child: FutureBuilder(
          future: getSpecificInquiryChat(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                    color: theme.isDark ? white : cardColor,
                  ));
            } else {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        controller: _scrollController,
                        itemCount:
                        snapshot.data['messages'][0]['history'].length,
                        itemBuilder: (context, int index) {
                          DateTime date =
                          DateTime.fromMillisecondsSinceEpoch(int.parse(
                              snapshot.data['messages'][0]['history']
                              [index]['timestamp']) *
                              1000);
                          var format =DateFormat("hh:mm a | d MMM, y");
                          var dateString = format.format(date);
                          return Column(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: snapshot.data['messages'][0]
                                      ['history'][index]
                                      ['sender_data']['type'] ==
                                          'student'
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Container(
                                        padding: kBubblePadding,
                                        decoration: BoxDecoration(
                                          color: (snapshot.data['messages'][0]
                                          ['history'][index]
                                          ['sender_data']['type'] ==
                                              'student'
                                              ? cardColorlight
                                              : lightPurple),
                                          borderRadius: BorderRadius.only(
                                            topLeft:
                                            Radius.circular(kBorderRadius),
                                            topRight:
                                            Radius.circular(kBorderRadius),
                                            bottomRight: Radius.circular(
                                                snapshot.data['messages'][0][
                                                'history']
                                                [index]
                                                ['sender_data']
                                                ['type'] ==
                                                    'student'
                                                    ? 0.0
                                                    : kBorderRadius),
                                            bottomLeft: Radius.circular(snapshot
                                                .data[
                                            'messages'][0]
                                            ['history'][index][
                                            'sender_data']['type'] ==
                                                'student'
                                                ? kBorderRadius
                                                : 0.0),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: snapshot
                                              .data['messages']
                                          [0]['history'][index]
                                          ['sender_data']['type'] ==
                                              'student'
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                          children: <Widget>[
                                            // Text(
                                            //   "${widget.data['history'][index]['message']}",
                                            //   style: TextStyle(
                                            //     color: Colors.white,
                                            //     fontSize: 12.0,
                                            //     fontFamily: "Poppins-Regular",
                                            //   ),
                                            // ),
                                            Html(
                                                style: {
                                                  "body": Style(
                                                      color: theme.isDark
                                                          ? white
                                                          : black),
                                                },
                                                data:
                                                "${snapshot.data['messages'][0]['history'][index]['message']}"),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            snapshot.data['messages'][0]
                                            ['history'][index][
                                            'attached_file_name'] ==
                                                null
                                                ? SizedBox(
                                              height: 0,
                                            )
                                                : GestureDetector(
                                              onTap: () {

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            WebviewDisplayMacos(
                                                                Uri.encodeFull(widget.data['history'][index]['attached_file_name']))));


                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             WebviewDsiplayDesktop(
                                                //                 Uri.decodeFull(snapshot.data['messages'][0]['history'][index]['attached_file_name']))));
                                              },
                                              child: Container(
                                                height: 70.h,
                                                width: 70.w,
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      10.0),
                                                  child: fileTypes_list
                                                      .contains(
                                                      "${snapshot.data['messages'][0]['history'][index]['attached_file_type']}")
                                                      ? Image
                                                      .network(
                                                    "${snapshot.data['messages'][0]['history'][index]['attached_file_name']}",
                                                    fit: BoxFit
                                                        .cover,
                                                  )
                                                      : Column(
                                                    children: [
                                                      Container(
                                                        height:
                                                        50.h,
                                                        width:
                                                        100.w,
                                                        child:
                                                        Image.asset(
                                                          "assets/images/pdf_icon.png",
                                                          fit:
                                                          BoxFit.contain,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  "${dateString}",
                                                  style: TextStyle(
                                                      fontSize:
                                                      kBubbleMetaFontSize,
                                                      color: theme.isDark
                                                          ? white
                                                          : black),
                                                ),
                                                // if (entry.read) ...[
                                                //   const SizedBox(width: 5),
                                                //   Icon(
                                                //     Icons.done,
                                                //     size: kBubbleMetaFontSize,
                                                //     color: Colors.white,
                                                //   )
                                                // ]
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        }),
                  ),
                  Stack(
                    fit: StackFit.passthrough,
                    children: <Widget>[
                      // Max Size Widget
                      Visibility(
                        visible: _isVisible != true ? false : true,
                        child: Visibility(
                          visible: objFile?.path != null ? true : false,
                          child: Container(
                            height: 120,
                            width: double.infinity,
                            color: theme.isDark == true
                                ? cardColor
                                : whiteBottomBar,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(10.0),
                                  child: fileTypes_list.contains(
                                      "${objFile?.extension}")
                                      ? Image.file(
                                    File("${objFile?.path}"),
                                    fit: BoxFit.contain,
                                  )
                                      : Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/pdf_icon.png",
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Text(
                                        "${objFile?.name}",
                                        style: CustomTextStyle
                                            .bodyRegular2(
                                            context,
                                            theme.isDark
                                                ? white
                                                : black),
                                        maxLines: 2,
                                        overflow:
                                        TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: 10,
                        right: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            color: white,
                            border: Border.all(
                              color: Colors.white,
                            ),
                            shape: BoxShape.circle,
                          ),
                          height: 30,
                          width: 30,
                          child: InkWell(
                            onTap: showToast,
                            child: Center(
                              child: InkWell(
                                onTap: showToast,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, top: 10, bottom: 5, right: 10),
                      height: 60.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: theme.isDark == true
                                ? cardColor
                                : whiteBottomBar,
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          )
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          FloatingActionButton(
                            heroTag: null,
                            onPressed: () async {
                              setState((){
                                _isVisible = true;

                              });
                              var result = await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: [
                                  'jpg',
                                  'pdf',
                                  'png',
                                  'gif'
                                ],
                                withReadStream: true,
                                // this will return PlatformFile object with read stream
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
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                            backgroundColor: purple,
                            elevation: 0,
                          ),
                          SizedBox(
                            width: 10.h,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: message,
                              style: CustomTextStyle.bodyRegular(
                                  context, theme.isDark ? white : black),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 10.w,
                                    top: 2.h,
                                    bottom: 5.h,
                                    right: 10.w),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: theme.isDark ? white : black,
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                enabledBorder: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(20.0),
                                  borderSide: new BorderSide(
                                      color: theme.isDark ? white : black),
                                ),
                                hintText: "Type here...",
                                hintStyle: CustomTextStyle.bodyRegular(
                                    context, theme.isDark ? white : black),
                              ),
                              onSaved: (String? value) {
                                inquiry = value;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10.h,
                          ),
                          FloatingActionButton(
                            onPressed: () {
                               file_size = objFile?.size;
                              if (message.text.isEmpty) {
                                CustomScaffoldWidget.buildErrorSnackbar(
                                    context, "Type your message");
                              } else if(file_size !=null && file_size > 1000000){
                                CustomScaffoldWidget.buildErrorSnackbar(
                                    context, "image size is too large select less than 1 MB");
                              }else if (_formKey.currentState!.validate()) {
                                setState((){
                                  loader_visible = true;
                                });
                                _formKey.currentState!.save();
                                uploadSelectedFile(
                                    snapshot.data['messages'][0]
                                    ['inquiry_thread_code'],
                                    snapshot.data['messages'][0]['sender_data']
                                    ['sender'],
                                    snapshot.data['messages'][0]
                                    ['reciever_data']['reciever'],
                                    snapshot.data['messages'][0]['priority']);
                                message.clear();
                              } else {}
                            },
                            child: loader_visible ?CircularProgressIndicator(color: white,) : Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 18,
                            ),
                            backgroundColor: purple,
                            elevation: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ): NoInternetScreen(),
    );
  }
}
