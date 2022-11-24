import 'dart:math';
import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:denning_portal/controllers/time_table.dart';
import 'package:denning_portal/custom_widgets/no_internet_screen.dart';
import 'package:denning_portal/models/TimeTableModel.dart';
import 'package:denning_portal/screens/student_screens/setting_screen.dart';
import 'package:denning_portal/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../custom_widgets/custom_textStyle.dart';
import '../../providers/internet_checker.dart';
import '../../providers/theme.dart';
import '../login_screens/email_login.dart';
import '../profile_screens/change_password.dart';

class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({Key? key}) : super(key: key);

  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  final CalendarAgendaController _calendarAgendaControllerNotAppBar =
  CalendarAgendaController();


  late DateTime _selectedDateNotAppBBar;
  String? token ="";
  String? studentId ="";
  Random random = Random();

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token')!;
      studentId = prefs.getString('studentId');

    });
  }



  @override
  void initState() {
    super.initState();
    getUser();
    _selectedDateNotAppBBar = DateTime.now();
  }
 @override
  void dispose() {
    // TODO: implement dispose
   _calendarAgendaControllerNotAppBar.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    final isOnline = Provider.of<ConnectivityService>(context).isOnline;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.isDark ? cardColor : whiteBottomBar,
        title: Text(
          "Time table",
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
                  value: 2,
                  child: GestureDetector(
                    onTap: () async {
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
      body: isOnline! ? Center(
        child: Column(
          children: [
            CalendarAgenda(
              fullCalendar: false,
              controller: _calendarAgendaControllerNotAppBar,
              //fullCalendar: true,
              locale: 'en',
              weekDay: WeekDay.long,
              fullCalendarDay: WeekDay.long,
              selectedDateColor: Colors.blue.shade900,
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 0)),
              lastDate: DateTime.now().add(const Duration(
                  days: 7)), // this line select specific months visible
              onDateSelected: (date) {
                setState(() {
                  _selectedDateNotAppBBar = date;
                });
              },
              calendarBackground: theme.isDark ? white : purple,
              calendarEventColor: theme.isDark ? white : purple,
              calendarEventSelectedColor: theme.isDark ? black : white,
              dateColor: theme.isDark ? white : white,
              backgroundColor: theme.isDark ? cardColor : purple,
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: FutureBuilder(
                  future:  TimeTableController.timetable( context),
                  builder: (context, AsyncSnapshot<TimeTableModel> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: CircularProgressIndicator(
                            color: theme.isDark ? white : cardColor,
                          ));
                    } else {
                      return snapshot.data!.timeTable == null
                          ? Center(
                        child: Text(
                          "No data available",
                          style: TextStyle(
                              color: theme.isDark ? white : black,
                              fontFamily: "Poppins-Regular",
                              fontSize: 18.sp),
                        ),
                      )
                          : ListView.builder(
                        itemCount: snapshot.data!.timeTable!.length,
                        itemBuilder: (context, int index) {
                          // snapshot.data!.timeTable![index].day!.contains("${DateFormat('EEEE').format(_selectedDateNotAppBBar).toLowerCase()}");
                          return Padding(
                            padding: EdgeInsets.only(
                              left: 10.w,
                              right: 10.w,
                            ),
                            child: Column(
                              children: [
                                if (snapshot
                                    .data!.timeTable![index].day ==
                                    null) ...[
                                  const SizedBox(
                                    height: 0,
                                  )
                                ] else if (snapshot
                                    .data!.timeTable![index].day!
                                    .contains(
                                    DateFormat('EEEE').format(_selectedDateNotAppBBar).toLowerCase())) ...[
                                  Column(
                                    children: [
                                      Container(
                                        height: 190.h,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: theme.isDark == true
                                              ? cardColor
                                              : cardColorlight,
                                          // Set border width
                                          borderRadius: const BorderRadius.only(
                                              topLeft:
                                              Radius.circular(15),
                                              bottomLeft:
                                              Radius.circular(15),
                                              topRight:
                                              Radius.circular(15),
                                              bottomRight: Radius.circular(
                                                  15)), // Set rounded corner radius
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 40.h,
                                              width: double.infinity,
                                              decoration: const BoxDecoration(
                                                color: purple,
                                                // Set border width
                                                borderRadius:
                                                BorderRadius.only(
                                                  topLeft:
                                                  Radius.circular(15),
                                                  topRight:
                                                  Radius.circular(15),
                                                ), // Set rounded corner radius
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .center,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .access_time_outlined,
                                                    color: white,
                                                    size: 28.sp,
                                                  ),
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  Text(
                                                    "${snapshot.data!.timeTable![index].classtime ?? ""}",
                                                    style: TextStyle(
                                                        color: white,
                                                        fontFamily:
                                                        "Poppins-Regular",
                                                        fontSize: 16.sp),
                                                    textAlign:
                                                    TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Center(
                                              child: Text(
                                                snapshot.data!.timeTable![index].subjectName ?? "",
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    color: theme.isDark
                                                        ? white
                                                        : black,
                                                    fontFamily:
                                                    "Poppins-Regular"),
                                                maxLines: 2,
                                                textAlign:
                                                TextAlign.center,
                                              ),
                                            ),
                                            Divider(
                                              color: theme.isDark
                                                  ? white
                                                  : purple,
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 8.w, right: 8.w),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Teacher : ",
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color:
                                                        theme.isDark
                                                            ? white
                                                            : black,
                                                        fontFamily:
                                                        "Poppins-SemiBold"),
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    snapshot.data!.timeTable![index].teacher ?? "",
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color:
                                                        theme.isDark
                                                            ? white
                                                            : black,
                                                        fontFamily:
                                                        "Poppins-Regular"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 8.w, right: 8.w),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Room : ",
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color:
                                                        theme.isDark
                                                            ? white
                                                            : black,
                                                        fontFamily:
                                                        "Poppins-SemiBold"),
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    "${snapshot.data!.timeTable![index].room ?? ""}",
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color:
                                                        theme.isDark
                                                            ? white
                                                            : black,
                                                        fontFamily:
                                                        "Poppins-Regular"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 8.w, right: 8.w),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Batch : ",
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color:
                                                        theme.isDark
                                                            ? white
                                                            : black,
                                                        fontFamily:
                                                        "Poppins-SemiBold"),
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  SizedBox(
                                                    width:250.w,
                                                    child: Text(
                                                      snapshot.data!.timeTable![index].sectionName ?? "",
                                                      style: TextStyle(
                                                          fontSize: 14.sp,
                                                          color: blue,
                                                          fontFamily:
                                                          "Poppins-Regular"),maxLines: 2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                    ],
                                  )
                                ] else ...[
                                  const SizedBox(
                                    height: 0,
                                  )
                                ]
                              ],
                            ),
                          );
                        },
                      );
                    }
                  }),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ) : const NoInternetScreen(),
    );
  }

  //popup menu
  void SelectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SettingScreen()));
        break;
      case 1:
        break;
      case 2:

      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => LoginPage()),
      //         (route) => false);
        break;
    }
  }
}
