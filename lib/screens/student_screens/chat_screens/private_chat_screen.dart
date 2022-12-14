import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:denning_portal/component/webview_display_macos.dart';
import 'package:denning_portal/custom_widgets/no_internet_screen.dart';
import 'package:denning_portal/utils/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../component/student_bottom_navigation.dart';
import '../../../component/webview_display_desktop.dart';
import '../../../custom_widgets/custom_textStyle.dart';
import '../../../custom_widgets/scaffold_messenge_snackbar.dart';
import '../../../providers/internet_checker.dart';
import '../../../providers/theme.dart';
import '../../../services/utilities/app_url.dart';
import '../../../services/utilities/authication_check.dart';
import '../../../services/utilities/basic_auth.dart';
import '../../../utils/config.dart';
import '../../login_screens/email_login.dart';
import 'dart:io' as Io;

class PrivateChatScreen extends StatefulWidget {
  dynamic data;

  PrivateChatScreen(this.data, {Key? key}) : super(key: key);

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 99999999.0);
  TextEditingController message = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Future<PickedFile?> pickedFile = Future.value(null);
  PlatformFile? objFile;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  String? token = "";
  String? studentId = "";
  String? status = "";
  String? subject;
  String? inquiry;
  FilePickerResult? result;
  bool _isVisible = false;
  bool loaderVisible = false;
  List<String> fileTypesList = [ "JPG",
    "PNG",
    "JPEG",
    "GIF",
    "jpg",
    "jpeg",
    "png",
    "gif"];
  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      status = "approved";
      token = prefs.getString('token')!;
      studentId = prefs.getString('studentId')!;
    });
  }

  void uploadSelectedFile(String reciver) async {
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
      request.fields["type"] = "private";
      request.fields["message_thread_code"] =
          '${widget.data[1] ?? widget.data['message_thread_code']}';
      request.fields["message"] = "$inquiry";
      request.fields["status"] = "$status";
      request.fields["sender"] = "student-$studentId";
      request.fields["reciever"] = reciver;
      request.fields["timestamp"] = dateTimeSend;
      request.fields["read_status"] = "0";
      request.fields["student_id"] = "$studentId";
      request.fields["auth_token"] = "$token";
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
        } else if (result['status'] == 401) {
          CustomScaffoldWidget.buildErrorSnackbar(
              context, "${result['message']}");
        } else {
          CustomScaffoldWidget.buildErrorSnackbar(
              context, "Something went wrong");
        }
      } else {
        AuthChecker.exceptionHandling(context, resp.statusCode);
      }
    } on TimeoutException {
      CustomScaffoldWidget.buildErrorSnackbar(context, "Time out try again");
    } on SocketException {
      CustomScaffoldWidget.buildErrorSnackbar(
          context, "Please enable your internet connection");
    } on Error {
      CustomScaffoldWidget.buildErrorSnackbar(context, "Something went wrong");
    }
  }

  Future getSpecificPrivateChat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    status = "approved";
    token = prefs.getString('token')!;
    studentId = prefs.getString('studentId')!;

    dynamic convertedData;
    try {
      final response = await http.get(
        Uri.parse(
            "${AppUrl.baseUrl}messages_data?auth_token=$token&student_id=$studentId&type=private&message_thread_code=${widget.data[1] ?? widget.data['message_thread_code']}"),
        headers: <String, String>{'authorization': BasicAuth.basicAuth},
      );
      convertedData = json.decode(response.body);
      if (response.statusCode == 200) {
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
              context, MaterialPageRoute(builder: (context) => const EmailLogin()));
          CustomScaffoldWidget.buildErrorSnackbar(context,
              "Your Session has been expired, please try to login again");
        } else if (convertedData['status'] == 401) {
          CustomScaffoldWidget.buildErrorSnackbar(
              context, "${convertedData['message']}");
        } else {
          CustomScaffoldWidget.buildErrorSnackbar(
              context, "Something went wrong");
        }
      } else {
        AuthChecker.exceptionHandling(context, response.statusCode);
      }
    } on TimeoutException {
      CustomScaffoldWidget.buildErrorSnackbar(context, "Time out try again");
    } on SocketException {
      CustomScaffoldWidget.buildErrorSnackbar(
          context, "Please enable your internet connection");
    } on Error {
      CustomScaffoldWidget.buildErrorSnackbar(context, "Something went wrong");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if (token == null) {
      CustomScaffoldWidget.buildErrorSnackbar(
          context, "Your Session has been expired, please try to login again");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => const EmailLogin()),
          (Route<dynamic> route) => false);
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
      super.initState();
      getUser();
    }
  }

  void showToast() {
    setState(() {
      _isVisible = !_isVisible;
      loaderVisible = false;
      objFile = null;
    });
  }
    @override
  void dispose() {
    // TODO: implement dispose
      _scrollController.dispose();
      super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final isOnline = Provider.of<ConnectivityService>(context).isOnline;
    final theme = Provider.of<ThemeChanger>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "${widget.data[0] ?? widget.data['sender_data']['sender_name']}",
          style: CustomTextStyle.AppBarHeading(
              context, theme.isDark ? white : black),
        ),
        elevation: 0,
        backgroundColor: theme.isDark ? cardColor : whiteBottomBar,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          StudentBottomNavigation()),
                  (Route<dynamic> route) => false);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18.sp,
            )),
        iconTheme: IconThemeData(color: theme.isDark ? white : black),
      ),
      body: isOnline!
          ? Form(
              key: _formKey,
              child: FutureBuilder(
                future: getSpecificPrivateChat(),
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
                              itemCount: snapshot
                                  .data['messages'][0]['history'].length,
                              itemBuilder: (context, int index) {
                                DateTime date =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(snapshot.data['messages'][0]
                                                    ['history'][index]
                                                ['timestamp']) *
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
                                            alignment: snapshot.data['messages']
                                                                        [0]
                                                                    ['history']
                                                                [index]
                                                            ['sender_data']
                                                        ['type'] ==
                                                    'student'
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            child: Container(
                                              padding: kBubblePadding,
                                              decoration: BoxDecoration(
                                                color: (snapshot.data['messages']
                                                                            [0][
                                                                        'history']
                                                                    [index]
                                                                ['sender_data']
                                                            ['type'] ==
                                                        'student'
                                                    ? cardColorlight
                                                    : lightPurple),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: const Radius.circular(
                                                      kBorderRadius),
                                                  topRight: const Radius.circular(
                                                      kBorderRadius),
                                                  bottomRight: Radius.circular(
                                                      snapshot.data['messages'][0]
                                                                              [
                                                                              'history']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'sender_data']
                                                                  ['type'] ==
                                                              'student'
                                                          ? 0.0
                                                          : kBorderRadius),
                                                  bottomLeft: Radius.circular(
                                                      snapshot.data['messages'][0]
                                                                              [
                                                                              'history']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'sender_data']
                                                                  ['type'] ==
                                                              'student'
                                                          ? kBorderRadius
                                                          : 0.0),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: snapshot
                                                                        .data[
                                                                    'messages'][0]
                                                                [
                                                                'history'][index]
                                                            [
                                                            'sender_data']['type'] ==
                                                        'student'
                                                    ? CrossAxisAlignment.end
                                                    : CrossAxisAlignment.start,
                                                children: <Widget>[
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
                                                  snapshot.data['messages'][0][
                                                                      'history']
                                                                  [index][
                                                              'attached_file_name'] ==
                                                          null
                                                      ? const SizedBox(
                                                          height: 0,
                                                        )
                                                      : GestureDetector(
                                                          onTap: () {
                                                        Io.Platform.isWindows ?   Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        WebviewDsiplayDesktop(
                                                                            Uri.encodeFull(widget.data['history'][index]['attached_file_name']))))
                                                           : Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                       WebviewDisplayMacos(
                                                                            Uri.encodeFull(widget.data['history'][index]['attached_file_name']))));
                                                          },
                                                          child:  Container(
                                                            height: 100.h,
                                                            width: 50.w,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  10.0),
                                                              child: fileTypesList
                                                                  .contains(
                                                                  "${snapshot.data['messages'][0]['history'][index]['attached_file_type']}")
                                                                  ? Image.network(
                                                                "${snapshot.data['messages'][0]['history'][index]['attached_file_name']}",
                                                                fit: BoxFit.fill,
                                                              )
                                                                  : Column(
                                                                children: [
                                                                  Container(
                                                                    height:
                                                                    100.h,
                                                                    width:
                                                                    100.w,
                                                                    child: Image
                                                                        .asset(
                                                                      "assets/images/pdf_icon.png",
                                                                      fit: BoxFit
                                                                          .fill,
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
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Text(
                                                        dateString,
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
                                  height: 120.h,
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
                                        child: fileTypesList.contains(
                                            "${objFile?.extension}")
                                            ? Image.file(
                                          File("${objFile?.path}"),
                                          fit: BoxFit.contain,
                                        )
                                            : Column(
                                          children: [
                                            Container(
                                              height:
                                              80.h,
                                              width:
                                              30.w,
                                              child: Image
                                                  .asset(
                                                "assets/images/pdf_icon.png",
                                                fit: BoxFit
                                                    .fill,
                                              ),
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
                                              maxLines: 1,
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
                                child: Center(
                                  child: InkWell(
                                    onTap: showToast,
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 5, bottom: 5, right: 10),
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
                                        setState(() {
                                          _isVisible = true;
                                        });
                                        var result =
                                        await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: [
                                            'jpeg',
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
                                      child: const Icon(
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
                                            context,
                                            theme.isDark ? white : black),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              left: 10.w,
                                              top: 2.h,
                                              bottom: 5.h,
                                              right: 10.w),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: theme.isDark
                                                    ? white
                                                    : black,
                                                width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide: BorderSide(
                                                color: theme.isDark
                                                    ? white
                                                    : black),
                                          ),
                                          hintText: "Type here...",
                                          hintStyle:
                                              CustomTextStyle.bodyRegular(
                                                  context,
                                                  theme.isDark ? white : black),
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
                                        var fileSize = objFile?.size;
                                        if (message.text.isEmpty) {
                                          CustomScaffoldWidget
                                              .buildErrorSnackbar(
                                                  context, "Type your message");
                                        } else if (fileSize != null &&
                                            fileSize > 1000000) {
                                          CustomScaffoldWidget.buildErrorSnackbar(
                                              context,
                                              "image size is too large select less than 1 MB");
                                        } else {
                                          setState(() {
                                            loaderVisible = true;
                                          });
                                          _formKey.currentState!.save();
                                          uploadSelectedFile(snapshot
                                                  .data['messages'][0]
                                              ['reciever_data']['reciever']);
                                          message.clear();
                                        }
                                      },
                                      child: loaderVisible
                                          ? const CircularProgressIndicator(
                                              color: white,
                                            )
                                          : const Icon(
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
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            )
          : const NoInternetScreen(),
    );
  }
}
