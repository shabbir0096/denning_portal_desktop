import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:denning_portal/component/student_bottom_navigation.dart';
import 'package:denning_portal/custom_widgets/no_internet_screen.dart';
import 'package:denning_portal/services/utilities/app_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../component/webview_display_desktop.dart';
import '../../../component/webview_display_macos.dart';
import '../../../custom_widgets/custom_textStyle.dart';
import '../../../custom_widgets/scaffold_messenge_snackbar.dart';
import '../../../providers/internet_checker.dart';
import '../../../providers/theme.dart';
import '../../../services/utilities/authication_check.dart';
import '../../../services/utilities/basic_auth.dart';
import '../../../utils/colors.dart';
import '../../../utils/config.dart';
import '../../login_screens/email_login.dart';
import 'dart:io' as Io;

class GroupChatScreen extends StatefulWidget {
  dynamic data;

  GroupChatScreen(this.data, {Key? key}) : super(key: key);

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 99999999.0);

  String? token = "";
  String? studentId = "";
  String? status = "approved";
  List<String> fileTypesList = [
    "JPG",
    "PNG",
    "JPEG",
    "GIF",
    "jpg",
    "jpeg",
    "png",
    "gif"
  ];

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    status = "approved";
    token = prefs.getString('token')!;
    studentId = prefs.getString('studentId')!;
    setState(() {});
  }

  Future getSpecificGroupChat() async {
    dynamic convertedData;

    try {
      final response = await http.get(
        Uri.parse(
            "${AppUrl.baseUrl}messages_data?auth_token=$token&student_id=$studentId&type=group&group_message_thread_code=${widget.data[1] ?? widget.data['group_message_thread_code']}"),
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
              context, MaterialPageRoute(builder: (context) => const EmailLogin()));
          CustomScaffoldWidget.buildErrorSnackbar(context,
              "Your Session has been expired, please try to login again");
        } else if (convertedData['status'] == 404) {
          CustomScaffoldWidget.buildErrorSnackbar(
              context, "${convertedData['message']}");
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
    if (token == null) {
      CustomScaffoldWidget.buildErrorSnackbar(
          context, "Your Session has been expired, please try to login again");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const EmailLogin()),
          (Route<dynamic> route) => false);
    } else {
      // TODO: implement initState
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });

      super.initState();
      getUser();
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var size, height;
    size = MediaQuery.of(context).size;
    height = size.height;
    final theme = Provider.of<ThemeChanger>(context);
    final isOnline = Provider.of<ConnectivityService>(context).isOnline;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          // widget.data['group_name'] == '' ? widget.data[0] : "${widget.data['group_name']}",
          "${widget.data[0] ?? widget.data['group_name']}",
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
          ? FutureBuilder(
              future: getSpecificGroupChat(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: theme.isDark ? white : cardColor,
                  ));
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      snapshot.data['messages'][0]['history'].isEmpty
                          ? Center(
                              child: Text(
                                "No data found",
                                style: TextStyle(
                                    color: theme.isDark ? white : black,
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 18.sp),
                              ),
                            )
                          : Container(
                              height: height / 1.14,
                              child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: snapshot
                                      .data['messages'][0]['history'].length,
                                  itemBuilder: (context, int index) {
                                    DateTime date = DateTime
                                        .fromMillisecondsSinceEpoch(int.parse(
                                            snapshot.data['messages'][0]
                                                    ['history'][index]
                                                ['timestamp']) *
                                        1000);
                                    var format =
                                    DateFormat("hh:mm a | d MMM, y");
                                    var dateString = format.format(date);

                                    return Column(
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Align(
                                                alignment: snapshot.data['messages']
                                                                            [
                                                                            0]
                                                                        [
                                                                        'history']
                                                                    [
                                                                    index]
                                                                [
                                                                'sender_data']
                                                            ['type'] ==
                                                        'student'
                                                    ? Alignment.centerRight
                                                    : Alignment.centerLeft,
                                                child: Container(
                                                  padding: kBubblePadding,
                                                  decoration: BoxDecoration(
                                                    color: (snapshot.data['messages']
                                                                            [
                                                                            0]
                                                                        [
                                                                        'history']
                                                                    [index][
                                                                'sender_data']['type'] ==
                                                            'student'
                                                        ? black
                                                        : lightPurple),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          const Radius.circular(
                                                              kBorderRadius),
                                                      topRight:
                                                          const Radius.circular(
                                                              kBorderRadius),
                                                      bottomRight: Radius.circular(
                                                          snapshot.data['messages'][0]['history'][index]
                                                                          [
                                                                          'sender_data']
                                                                      [
                                                                      'type'] ==
                                                                  'student'
                                                              ? 0.0
                                                              : kBorderRadius),
                                                      bottomLeft: Radius.circular(
                                                          snapshot.data['messages'][0]['history'][index]
                                                                          [
                                                                          'sender_data']
                                                                      [
                                                                      'type'] ==
                                                                  'student'
                                                              ? kBorderRadius
                                                              : 0.0),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment: snapshot.data['messages'][0]
                                                                            [
                                                                            'history']
                                                                        [
                                                                        index]
                                                                    [
                                                                    'sender_data']
                                                                ['type'] ==
                                                            'student'
                                                        ? CrossAxisAlignment
                                                            .end
                                                        : CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        "${widget.data['history'][index]['sender_data']['sender_name']}",
                                                        style: const TextStyle(
                                                          color: Colors
                                                              .cyanAccent,
                                                          fontSize: 12.0,
                                                          fontFamily:
                                                              "Poppins-Regular",
                                                        ),
                                                      ),
                                                      Html(
                                                          style: {
                                                            "body": Style(
                                                                color: theme
                                                                        .isDark
                                                                    ? white
                                                                    : black),
                                                          },
                                                          data:
                                                              "${snapshot.data['messages'][0]['history'][index]['message']}"),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      snapshot.data['messages'][0]
                                                                          [
                                                                          'history']
                                                                      [index][
                                                                  'attached_file_name'] ==
                                                              null
                                                          ? const SizedBox(
                                                              height: 0,
                                                            )
                                                          : GestureDetector(
                                                              onTap: () {

                                                                Io.Platform.isWindows ? Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            WebviewDsiplayDesktop(Uri.encodeFull(widget.data['history'][index]['attached_file_name']))))
                                                               : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            WebviewDisplayMacos(
                                                                                Uri.encodeFull(widget.data['history'][index]['attached_file_name']))));



                                                              },
                                                              child:
                                                                  Container(
                                                                height: 100.h,
                                                                width: 80.w,
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          10.0),
                                                                  child: fileTypesList.contains(
                                                                          "${snapshot.data['messages'][0]['history'][index]['attached_file_type']}")
                                                                      ? Image
                                                                          .network(
                                                                          "${snapshot.data['messages'][0]['history'][index]['attached_file_name']}",
                                                                          fit:
                                                                              BoxFit.contain,
                                                                        )
                                                                      : Column(
                                                                          children: [
                                                                            Container(
                                                                              height: 50.h,
                                                                              width: 100.w,
                                                                              child: Image.asset(
                                                                                "assets/images/pdf_icon.png",
                                                                                fit: BoxFit.contain,
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
                                                                color: theme
                                                                        .isDark
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
                    ],
                  );
                }
              })
          : const NoInternetScreen(),
    );
  }
}
