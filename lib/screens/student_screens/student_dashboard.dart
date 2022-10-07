import 'dart:convert';
import 'package:denning_portal/controllers/dashboard_controller.dart';
import 'package:denning_portal/custom_widgets/no_internet_screen.dart';
import 'package:denning_portal/providers/internet_checker.dart';
import 'package:denning_portal/screens/profile_screens/student_profile.dart';
import 'package:denning_portal/screens/student_screens/attendance/attendance_details.dart';
import 'package:denning_portal/screens/login_screens/email_login.dart';
import 'package:denning_portal/screens/student_screens/events/event_details.dart';
import 'package:denning_portal/screens/student_screens/events/event_screen.dart';
import 'package:denning_portal/screens/student_screens/fees_screens/fees_screen.dart';
import 'package:denning_portal/screens/student_screens/notice_board_screens/notice_details.dart';
import 'package:denning_portal/screens/student_screens/notice_board_screens/notices.dart';
import 'package:denning_portal/screens/student_screens/setting_screen.dart';
import 'package:denning_portal/utils/colors.dart';
import 'package:denning_portal/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../custom_widgets/custom_textStyle.dart';
import '../../services/utilities/basic_auth.dart';
import '../profile_screens/change_password.dart';

class StudentDashboard extends StatefulWidget {
  final Function select;

  const StudentDashboard({Key? key, required this.select}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  bool events = true;
  bool notices = false;
  String? name = "";
  String? studentCode = "";
  String? image = "";
  String? token = "";
  String? studentId = "";
  String? status = "";

  DashboardController dashboardController = DashboardController();
  String connectionStatus = '';

  Future getAttendance(String? token, String? studentId) async {
    var convertedData;
    Map data = {"auth_token": "$token", "student_id": "$studentId"};
    final response = await http.post(
      Uri.parse("https://denningportal.com/app/api/appapi/dashboard_data"),
      headers: <String, String>{'authorization': BasicAuth.basicAuth},
      body: data,
    );
    if (response.statusCode == 401) {
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Your Session has been expired, please try to login again',
          style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white,
              fontFamily: "Poppins-Regular"),
        ),
        backgroundColor: errorColor,
      ));
    } else if (response.statusCode == 200) {
      convertedData = json.decode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'There is a technical issue faced by the server',
          style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white,
              fontFamily: "Poppins-Regular"),
        ),
        backgroundColor: errorColor,
      ));
    }
  }

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name')!;
      studentCode = prefs.getString('studentCode')!;
      image = prefs.getString('image')!;
      token = prefs.getString('token')!;
      studentId = prefs.getString('studentId');
      status = prefs.getString('status');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser().then((value) => getAttendance(token, studentId));
  }

  @override
  Widget build(BuildContext context) {
    // final _height = MediaQuery.of(context).size.height -
    //     MediaQuery.of(context).padding.top -
    //     kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    Color _dynamicTextColor = purple;
    final theme = Provider.of<ThemeChanger>(context);
    final isOnline = Provider.of<ConnectivityService>(context).isOnline;

    return Scaffold(
      //backgroundColor: theme.isDark? black: white,
      appBar: AppBar(
        backgroundColor: theme.isDark ? black : whiteBottomBar,
        title: Text(
          "Home",
          style: CustomTextStyle.AppBarHeading(
              context, theme.isDark ? white : black),
        ),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(
              Icons.menu_rounded,
              size: 22.sp,
            )),
        iconTheme: IconThemeData(color: theme.isDark ? white : black),
        actions: <Widget>[
          // IconButton(
          //   onPressed: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => AllNotifications()));
          //   },
          //   icon: Badge(
          //     badgeColor: errorColor,
          //     badgeContent: Text(
          //       '3',
          //       style: CustomTextStyle.bodyRegular2(context, white),
          //     ),
          //     child: Icon(
          //       Icons.notifications_rounded,
          //       size: 22.sp,
          //     ),
          //   ),
          // ), ),
          Theme(
            data: Theme.of(context).copyWith(
              textTheme: const TextTheme().apply(bodyColor: Colors.black),
              // iconTheme: IconThemeData(color: white, size: 28.sp),
            ),
            child: PopupMenuButton<int>(
              iconSize: 22.sp,
              color: theme.isDark == true ? cardColor : whiteBottomBar,
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text(
                    "Settings",
                    style: CustomTextStyle.bodyRegular(
                        context, theme.isDark ? white : black),
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePassword()));
                    },
                    child: Text(
                      "Change Password",
                      style: CustomTextStyle.bodyRegular(
                          context, theme.isDark ? white : black),
                    ),
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: GestureDetector(
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      //String? token = await prefs.getString("token");
                      prefs.remove("token");
                      prefs.remove("status");
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EmailLogin()));
                    },
                    child: Text(
                      "Logout",
                      style: CustomTextStyle.bodyRegular(
                          context, theme.isDark ? white : black),
                    ),
                  ),
                ),
              ],
              onSelected: (item) => SelectedItem(context, item),
            ),
          ),
        ],
      ),
      body: isOnline!
          ? Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              child: FutureBuilder(
                  future: dashboardController.dashboardData(token, studentId),
                  builder: (context, AsyncSnapshot snapshot) {
                    // var a= snapshot.data['time_table'];
                    //  for(var i in a ){
                    //
                    //  }
                    if (!snapshot.hasData) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: theme.isDark ? white : cardColor,
                      ));
                    } else {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const StudentProfile()));
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: theme.isDark == true
                                        ? white
                                        : black,
                                    radius: 65.r,
                                    child: CircleAvatar(
                                      backgroundColor: theme.isDark == true
                                          ? black
                                          : white,
                                      radius: 61.r,
                                      child: CircleAvatar(
                                        radius: 57.r,
                                        backgroundImage: image!.isEmpty
                                            ? AssetImage(
                                            "assets/images/default_profile_image.jpeg")
                                        as ImageProvider
                                            : NetworkImage(image!),
                                        child: const SizedBox.shrink(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Hi",
                                        style: CustomTextStyle.headingRegular(
                                            context,
                                            theme.isDark ? white : black),
                                      ),
                                      Text(
                                        "$name",
                                        style: CustomTextStyle.titleSemiBold(
                                            context,
                                            theme.isDark ? white : black),
                                      ),
                                      Text(
                                        "$studentCode",
                                        style: CustomTextStyle.bodySemiBold(
                                            context,
                                            theme.isDark ? white : black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (events == true) {
                                            setState(() => events = false);
                                          }
                                          events = !events;
                                          notices = false;
                                        });
                                      },
                                      child: Text(
                                        "Events",
                                        style: CustomTextStyle.titleSemiBold(
                                            context,
                                            notices
                                                ? theme.isDark
                                                    ? white
                                                    : black
                                                : _dynamicTextColor),
                                      ),
                                    ),
                                    Text(
                                      " / ",
                                      style: CustomTextStyle.titleSemiBold(
                                          context,
                                          theme.isDark ? white : black),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (notices == true) {
                                            setState(() => notices = false);
                                            _dynamicTextColor = purple;
                                          }
                                          _dynamicTextColor = purple;
                                          notices = !notices;
                                          events = false;
                                        });
                                      },
                                      child: Text(
                                        "Notices",
                                        style: CustomTextStyle.titleSemiBold(
                                            context,
                                            notices
                                                ? theme.isDark
                                                    ? _dynamicTextColor
                                                    : theme.isDark
                                                        ? white
                                                        : _dynamicTextColor
                                                : theme.isDark
                                                    ? white
                                                    : black),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                if (events == true && notices == false) ...[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const EventsScreen()));
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "See all (${snapshot.data!['events'] == null ? '0' : snapshot.data!['events'].length})",
                                          style: CustomTextStyle.bodyRegular2(
                                              context,
                                              theme.isDark ? white : purple),
                                        ),
                                      ],
                                    ),
                                  )
                                ] else if (notices == true &&
                                    events == false) ...[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => const Notices()));
                                    },
                                    child: Text(
                                      "See all (${snapshot.data!['notices'] == null ? '0' : snapshot.data!['notices'].length})",
                                      style: CustomTextStyle.bodyRegular2(
                                          context,
                                          theme.isDark ? white : purple),
                                    ),
                                  )
                                ],
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            if (events == true && notices == false) ...[
                              snapshot.data!['events'] == null
                                  ? ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0),
                                      ),
                                      child: Container(
                                        height: 150.h,
                                        width: _width * 0.9,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: theme.isDark == true
                                                  ? cardColor
                                                  : cardColorlight,
                                              blurRadius: 5.0,
                                              spreadRadius: 10.0,
                                            )
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            "No upcoming events",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                color: theme.isDark
                                                    ? white
                                                    : purple,
                                                fontFamily: "Poppins-Regular"),
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 150.h,
                                      width: _width * 0.96,
                                      child: ListView.builder(
                                        itemCount: snapshot.data == null
                                            ? 0
                                            : (snapshot.data!['events'].length >
                                                    3
                                                ? 3
                                                : snapshot
                                                    .data!['events'].length),
                                        itemBuilder: (context, int index) {
                                          return Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              EventDetails(snapshot
                                                                          .data![
                                                                      'events']
                                                                  [index])));
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(8.0),
                                                    bottomRight:
                                                        Radius.circular(8.0),
                                                    bottomLeft:
                                                        Radius.circular(8.0),
                                                    topRight:
                                                        Radius.circular(8.0),
                                                  ),
                                                  child: Container(
                                                    height: 120.h,
                                                    width: _width * 0.3,
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: theme.isDark ==
                                                                  true
                                                              ? cardColor
                                                              : cardColorlight,
                                                          blurRadius: 5.0,
                                                          spreadRadius: 10.0,
                                                        )
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10.w,
                                                          right: 10.w),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 15.h,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              ClipOval(
                                                                  child: snapshot.data!['events'][index]
                                                                              [
                                                                              'image'] ==
                                                                          null
                                                                      ? Image
                                                                          .asset(
                                                                          "assets/images/default_event_image.jpg",
                                                                          width:
                                                                              30.w,
                                                                          height:
                                                                              90.h,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        )
                                                                      : Image
                                                                          .network(
                                                                          '${snapshot.data!['events'][index]['image']}',
                                                                          width:
                                                                              30.w,
                                                                          height:
                                                                              90.h,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        )),
                                                              SizedBox(
                                                                width: 5.w,
                                                              ),
                                                              Flexible(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Center(
                                                                      child:
                                                                          Text(
                                                                        "${snapshot.data!['events'][index]['notice_title']}",
                                                                        style: CustomTextStyle.titleBold(
                                                                            context,
                                                                            theme.isDark
                                                                                ? white
                                                                                : purple),
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            3.h),
                                                                    Center(
                                                                      child:
                                                                          Text(
                                                                        DateFormat('dd MMM, yyyy').format(DateTime.parse(snapshot.data!['events'][index]['notice_date'])),
                                                                        style: CustomTextStyle.bodyRegular2(
                                                                            context,
                                                                            theme.isDark
                                                                                ? white
                                                                                : black),
                                                                        maxLines:
                                                                            3,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                            ],
                                          );
                                        },
                                        scrollDirection: Axis.horizontal,
                                      ),
                                    ),
                            ] else if (notices == true && events == false) ...[
                              snapshot.data!['notices'] == null
                                  ? ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0),
                                      ),
                                      child: Container(
                                        height: 150.h,
                                        width: _width * 0.9,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: theme.isDark == true
                                                  ? cardColor
                                                  : cardColorlight,
                                              blurRadius: 5.0,
                                              spreadRadius: 10.0,
                                            )
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            "No Notices",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                color: theme.isDark
                                                    ? white
                                                    : purple,
                                                fontFamily: "Poppins-Regular"),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 150.h,
                                      width: _width * 0.96,
                                      child: ListView.builder(
                                        itemCount: snapshot.data == null
                                            ? 0
                                            : (snapshot.data!['notices']
                                                        .length >
                                                    3
                                                ? 3
                                                : snapshot
                                                    .data!['notices'].length),
                                        itemBuilder: (context, int index) {
                                          return Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              NoticeDescription(
                                                                  snapshot.data![
                                                                          'notices']
                                                                      [
                                                                      index])));
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(8.0),
                                                    bottomRight:
                                                        Radius.circular(8.0),
                                                    bottomLeft:
                                                        Radius.circular(8.0),
                                                    topRight:
                                                        Radius.circular(8.0),
                                                  ),
                                                  child: Container(
                                                    height: 120.h,
                                                    width: _width * 0.3,
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: theme.isDark ==
                                                                  true
                                                              ? cardColor
                                                              : cardColorlight,
                                                          blurRadius: 5.0,
                                                          spreadRadius: 10.0,
                                                        )
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10.w, right: 10.w),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "${snapshot.data!['notices'][index]['notice_title']}",
                                                            style: CustomTextStyle
                                                                .titleBold(
                                                                    context,
                                                                    theme.isDark
                                                                        ? white
                                                                        : purple),
                                                            overflow:
                                                            TextOverflow.ellipsis,
                                                            maxLines: 2,
                                                          ),
                                                          SizedBox(
                                                            height: 5.h,
                                                          ),
                                                          snapshot.data!['notices']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'notice_date'] ==
                                                                  null
                                                              ? const SizedBox(
                                                                  height: 0,
                                                                )
                                                              : Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .calendar_month,
                                                                      color: theme.isDark ==
                                                                              true
                                                                          ? blue
                                                                          : purple,
                                                                      size:
                                                                          18.sp,
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          5.w,
                                                                    ),
                                                                    Center(
                                                                      child:
                                                                          Text(
                                                                        DateFormat('dd MMM, yyyy').format(DateTime.parse(snapshot.data!['notices'][index]['notice_date'])),
                                                                        style: CustomTextStyle.bodyRegular(
                                                                            context,
                                                                            theme.isDark
                                                                                ? white
                                                                                : black),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                          snapshot.data!['notices']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'notice_time'] ==
                                                                  null
                                                              ? const SizedBox(
                                                                  height: 0,
                                                                )
                                                              : Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .access_time,
                                                                      color: theme.isDark ==
                                                                              true
                                                                          ? blue
                                                                          : purple,
                                                                      size:
                                                                          18.sp,
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          5.w,
                                                                    ),
                                                                    Center(
                                                                      child:
                                                                          Text(
                                                                        "${snapshot.data!['notices'][index]['notice_time']}",
                                                                        style: CustomTextStyle.bodyRegular(
                                                                            context,
                                                                            theme.isDark
                                                                                ? white
                                                                                : black),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                            ],
                                          );
                                        },
                                        scrollDirection: Axis.horizontal,
                                      ),
                                    ),
                            ],
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => TimeTable()));
                                    widget.select(1);
                                  },
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      bottomRight: Radius.circular(8.0),
                                      bottomLeft: Radius.circular(8.0),
                                      topRight: Radius.circular(8.0),
                                    ),
                                    child: Container(
                                      height: 280.h,
                                      width: _width * 0.43,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: theme.isDark == true
                                                ? cardColor
                                                : cardColorlight,
                                            blurRadius: 5.0,
                                            spreadRadius: 10.0,
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Text(
                                            "Time Table",
                                            style:
                                                CustomTextStyle.titleSemiBold(
                                                    context,
                                                    theme.isDark
                                                        ? white
                                                        : purple),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 30.h,
                                            color: lightPurple,
                                            child: Center(
                                              child: Text(
                                                DateFormat('EEEE').format(DateTime.now()),
                                                style: CustomTextStyle
                                                    .bodyRegular2(
                                                        context,
                                                        theme.isDark
                                                            ? white
                                                            : black),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15.h,
                                          ),
                                          snapshot.data!['time_table'] == null
                                              ? Expanded(
                                                  child: Text(
                                                    "No Class Today",
                                                    style: CustomTextStyle
                                                        .bodyRegular2(
                                                            context,
                                                            theme.isDark
                                                                ? white
                                                                : black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              : Expanded(
                                                  child: ListView.builder(
                                                      itemCount: snapshot
                                                          .data!['time_table']
                                                          .length,
                                                      itemBuilder:
                                                          (context, int index) {
                                                        return Column(
                                                          children: [
                                                            Text(
                                                              "${snapshot.data!['time_table'][index]['time_start']}:${snapshot.data!['time_table'][index]['time_start_min']} ${snapshot.data!['time_table'][index]['starting_ampm']} to ${snapshot.data!['time_table'][index]['time_end']}:${snapshot.data!['time_table'][index]['time_end_min']} ${snapshot.data!['time_table'][index]['ending_ampm']}",
                                                              style: CustomTextStyle
                                                                  .bodyRegular2(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
                                                            SizedBox(
                                                              height: 3.h,
                                                            ),
                                                            Text(
                                                              "${snapshot.data!['time_table'][index]['subject_name']}",
                                                              style: CustomTextStyle
                                                                  .bodyRegular2(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            Divider(
                                                                color:
                                                                    theme.isDark ==
                                                                            true
                                                                        ? white
                                                                        : black,
                                                                thickness: .5),
                                                          ],
                                                        );
                                                      }),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    snapshot.data!['attendance'] != null
                                        ? GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AttendanceDetails()));
                                            },
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(8.0),
                                                bottomRight:
                                                    Radius.circular(8.0),
                                                bottomLeft:
                                                    Radius.circular(8.0),
                                                topRight: Radius.circular(8.0),
                                              ),
                                              child: Container(
                                                height: 160.h,
                                                width: _width * 0.43,
                                                child: Container(
                                                  height: 125.h,
                                                  width: _width * 0.43,
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: theme.isDark ==
                                                                true
                                                            ? cardColor
                                                            : cardColorlight,
                                                        blurRadius: 5.0,
                                                        spreadRadius: 10.0,
                                                      )
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10.w,
                                                        right: 10.w),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Attendance",
                                                              style: CustomTextStyle
                                                                  .titleSemiBold(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : purple),
                                                            ),
                                                            const Spacer(),
                                                            Icon(
                                                              Icons
                                                                  .domain_verification_rounded,
                                                              color:
                                                                  theme.isDark ==
                                                                          true
                                                                      ? white
                                                                      : black,
                                                              size: 22.sp,
                                                            )
                                                          ],
                                                        ),
                                                        Divider(
                                                          color: theme.isDark ==
                                                                  true
                                                              ? white
                                                              : black,
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Presents:",
                                                              style: CustomTextStyle
                                                                  .bodyRegular2(
                                                                      context,
                                                                      theme.isDark
                                                                          ? green
                                                                          : green),
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                              "${snapshot.data!['attendance']['total_present']['percentage']}",
                                                              style: CustomTextStyle
                                                                  .bodyRegular2(
                                                                      context,
                                                                      theme.isDark
                                                                          ? green
                                                                          : green),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Absents:",
                                                              style: CustomTextStyle
                                                                  .bodyRegular2(
                                                                      context,
                                                                      theme.isDark
                                                                          ? errorColor
                                                                          : errorColor),
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                              "${snapshot.data!['attendance']['total_absent']['percentage']}",
                                                              style: CustomTextStyle
                                                                  .bodyRegular2(
                                                                      context,
                                                                      theme.isDark
                                                                          ? errorColor
                                                                          : errorColor),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Leaves :",
                                                              style: CustomTextStyle
                                                                  .bodyRegular2(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                              "${snapshot.data!['attendance']['total_leaves']['percentage']}",
                                                              style: CustomTextStyle
                                                                  .bodyRegular2(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
                                                          ],
                                                        ),
                                                        const Spacer(),
                                                        SizedBox(
                                                          height: 12.h,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AttendanceDetails()));
                                            },
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(8.0),
                                                bottomRight:
                                                    Radius.circular(8.0),
                                                bottomLeft:
                                                    Radius.circular(8.0),
                                                topRight: Radius.circular(8.0),
                                              ),
                                              child: Container(
                                                height: 160.h,
                                                width: _width * 0.43,
                                                child: Container(
                                                  height: 125.h,
                                                  width: _width * 0.43,
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: theme.isDark ==
                                                                true
                                                            ? cardColor
                                                            : cardColorlight,
                                                        blurRadius: 5.0,
                                                        spreadRadius: 10.0,
                                                      )
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10.w,
                                                        right: 10.w),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Attendance",
                                                              style: CustomTextStyle
                                                                  .titleSemiBold(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : purple),
                                                            ),
                                                            const Spacer(),
                                                            Icon(
                                                              Icons
                                                                  .domain_verification_rounded,
                                                              color:
                                                                  theme.isDark ==
                                                                          true
                                                                      ? white
                                                                      : black,
                                                              size: 22.sp,
                                                            )
                                                          ],
                                                        ),
                                                        Divider(
                                                          color: theme.isDark ==
                                                                  true
                                                              ? white
                                                              : black,
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Presents:",
                                                              style: CustomTextStyle
                                                                  .bodyRegular2(
                                                                      context,
                                                                      theme.isDark
                                                                          ? green
                                                                          : green),
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                              "No data",
                                                              style: CustomTextStyle
                                                                  .bodyRegular2(
                                                                      context,
                                                                      theme.isDark
                                                                          ? green
                                                                          : green),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Absents:",
                                                              style: CustomTextStyle
                                                                  .bodyRegular2(
                                                                      context,
                                                                      theme.isDark
                                                                          ? errorColor
                                                                          : errorColor),
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                              "No data",
                                                              style: CustomTextStyle
                                                                  .bodyRegular2(
                                                                      context,
                                                                      theme.isDark
                                                                          ? errorColor
                                                                          : errorColor),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Leaves :",
                                                              style: CustomTextStyle
                                                                  .bodyRegular2(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                              "No data",
                                                              style: CustomTextStyle
                                                                  .bodyRegular2(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
                                                          ],
                                                        ),
                                                        const Spacer(),

                                                        SizedBox(
                                                          height: 12.h,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const FeesScreen()));
                                      },
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                          bottomLeft: Radius.circular(8.0),
                                          topRight: Radius.circular(8.0),
                                        ),
                                        child: Container(
                                          height: 115.h,
                                          width: _width * 0.43,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: theme.isDark == true
                                                    ? cardColor
                                                    : cardColorlight,
                                                blurRadius: 5.0,
                                                spreadRadius: 10.0,
                                              )
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 10.w, right: 10.w),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Fees",
                                                      style: CustomTextStyle
                                                          .titleSemiBold(
                                                              context,
                                                              theme.isDark
                                                                  ? white
                                                                  : purple),
                                                    ),
                                                    const Spacer(),
                                                    Icon(
                                                      Icons.attach_money,
                                                      color:
                                                          theme.isDark == true
                                                              ? white
                                                              : black,
                                                      size: 22.sp,
                                                    )
                                                  ],
                                                ),
                                                Divider(
                                                  color: theme.isDark == true
                                                      ? white
                                                      : black,
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Fees Due:",
                                                      style: CustomTextStyle
                                                          .bodyRegular2(
                                                              context,
                                                              theme.isDark
                                                                  ? white
                                                                  : black),
                                                    ),
                                                    const Spacer(),
                                                    snapshot.data!['fees'] ==
                                                            null
                                                        ? Text(
                                                            "Rs. 0",
                                                            style: CustomTextStyle
                                                                .bodyRegular(
                                                                    context,
                                                                    theme.isDark
                                                                        ? white
                                                                        : purple),
                                                          )
                                                        : Text(
                                                            "Rs. ${snapshot.data!['fees'][0]['amount']}",
                                                            style: CustomTextStyle
                                                                .bodyRegular(
                                                                    context,
                                                                    theme.isDark
                                                                        ? white
                                                                        : purple),
                                                          ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Due Date:",
                                                      style: CustomTextStyle
                                                          .bodyRegular2(
                                                              context,
                                                              theme.isDark
                                                                  ? white
                                                                  : black),
                                                    ),
                                                    const Spacer(),
                                                    snapshot.data![
                                                    'fees'] ==
                                                        null
                                                        ? Text(
                                                      "",
                                                      style: CustomTextStyle
                                                          .bodyRegular2(
                                                          context,
                                                          theme.isDark
                                                              ? white
                                                              : purple),
                                                    )
                                                        : Text(
                                                      DateFormat('dd MMM, yyyy').format(DateTime.parse(snapshot.data!['fees'][0]['payment_deadline'])),
                                                      style: CustomTextStyle
                                                          .bodyRegular2(
                                                          context,
                                                          theme.isDark
                                                              ? white
                                                              : purple),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            )
                          ],
                        ),
                      );
                    }
                  }))
          : const NoInternetScreen(),
    );
  }

  //popup menu
  Future<void> SelectedItem(BuildContext context, item) async {
    switch (item) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SettingScreen()));
        break;
      case 1:
        final prefs = await SharedPreferences.getInstance();
      //  String? token = await prefs.getString("token");
        prefs.remove("token");
        prefs.remove("status");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const EmailLogin()));
        break;
      case 2:

        break;
    }
  }
}
