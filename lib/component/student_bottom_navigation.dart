
import 'package:denning_portal/screens/student_screens/attendance/attendance_details.dart';
import 'package:denning_portal/screens/student_screens/courses/courses_details.dart';
import 'package:denning_portal/screens/login_screens/email_login.dart';
import 'package:denning_portal/screens/student_screens/Inquiry.dart';
import 'package:denning_portal/screens/student_screens/events/event_screen.dart';
import 'package:denning_portal/screens/student_screens/fees_screens/fees_screen.dart';
import 'package:denning_portal/screens/student_screens/notice_board_screens/notices.dart';
import 'package:denning_portal/screens/student_screens/student_dashboard.dart';
import 'package:denning_portal/screens/student_screens/time_table.dart';
import 'package:denning_portal/screens/student_screens/vle.dart';
import 'package:denning_portal/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/profile_screens/student_profile.dart';
import '../utils/colors.dart';
import '../providers/theme.dart';

class StudentBottomNavigation extends StatefulWidget {




  @override
  State<StudentBottomNavigation> createState() =>
      _StudentBottomNavigationState();
}

class _StudentBottomNavigationState extends State<StudentBottomNavigation> {
  MyAppIcons myAppIcons = MyAppIcons();

  int _selectedIndex = 0;
  late List<Widget> _widgetOptions = <Widget>[
    StudentDashboard(
      select: onTapped,
    ),
    TimeTableScreen(),
    Vle(),
    NoticeBoard()
  ];

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String? name = "";
  String? studentCode = "";
  String? image = "";

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name')!;
      studentCode = prefs.getString('studentCode')!;
      image = prefs.getString('image')!;

      // print(name);
      // print(image);
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
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    final theme = Provider.of<ThemeChanger>(context);
    return Scaffold(
      drawer: SafeArea(
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: theme.isDark == true
                ? cardColor
                : purple, //This will change the drawer background to blue.
            //other styles
          ),
          child: Container(
            width: 120.w,
            height: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              child: Drawer(
                child: ListView(
                  padding: EdgeInsets.all(0.0),
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudentProfile()));
                      },
                      title: Container(
                        // color: Colors.red,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StudentProfile()));
                              },
                              child: CircleAvatar(
                                backgroundColor:
                                theme.isDark == true ? white : white,
                                radius: 45,
                                child: CircleAvatar(
                                  radius: 41,
                                  child: CircleAvatar(
                                    radius: 37,
                                    backgroundImage: image!.isEmpty
                                        ? AssetImage(
                                        "assets/images/default_profile_image.jpeg")
                                    as ImageProvider
                                        : NetworkImage(image!),
                                    child: const SizedBox.shrink(),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: _height * 0.02,
                            ),
                            Text(
                              "${name}",
                              style: TextStyle(
                                  fontFamily: "Poppins-SemiBold",
                                  fontWeight: FontWeight.w700,
                                  color: white,
                                  fontSize: 20.sp),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 25.h),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            onTapped(0);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.home,
                                color: white,
                                size: 22.sp,
                              ),
                              SizedBox(width: 20.w),
                              Text(
                                'Home',
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 15.sp,
                                    color: white,
                                    fontWeight: FontWeight.w400), maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: white,
                      thickness: 0.5,
                    ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            onTapped(2);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                MyAppIcons.vleicon,
                                color: white,
                                size: 22.sp,
                              ),
                              SizedBox(width: 20.w),
                              Text(
                                'VLE',
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 15.sp,
                                    color: white,
                                    fontWeight: FontWeight.w400),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: white,
                      thickness: 0.5,
                    ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            onTapped(3);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                MyAppIcons.inquiryicon,
                                color: white,
                                size: 22.sp,
                              ),
                              SizedBox(width: 20.w),
                              Text(
                                'Inquiry',
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 15.sp,
                                    color: white,
                                    fontWeight: FontWeight.w400),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: white,
                      thickness: 0.5,
                    ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AttendanceDetails()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.event_available_rounded,
                                color: white,
                                size: 22.sp,
                              ),
                              SizedBox(width: 20.w),
                              Text(
                                'Attendance',
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 15.sp,
                                    color: white,
                                    fontWeight: FontWeight.w400), maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: white,
                      thickness: 0.5,
                    ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EventsScreen()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.event,
                                color: white,
                                size: 22.sp,
                              ),
                              SizedBox(width: 20.w),
                              Text(
                                'Events',
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 15.sp,
                                    color: white,
                                    fontWeight: FontWeight.w400), maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: white,
                      thickness: 0.5,
                    ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Notices()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.announcement,
                                color: white,
                                size: 22.sp,
                              ),
                              SizedBox(width: 20.w),
                              Text(
                                'Notices',
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 15.sp,
                                    color: white,
                                    fontWeight: FontWeight.w400), maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),


                    Divider(
                      color: white,
                      thickness: 0.5,
                    ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CourseDetails()));
                          },
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.menu_book_rounded,
                                color: white,
                                size: 22.sp,
                              ),
                              SizedBox(width: 20.w),
                              Text(
                                'Courses',
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 15.sp,
                                    color: white,
                                    fontWeight: FontWeight.w400), maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: white,
                      thickness: 0.5,
                    ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FeesScreen()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.money,
                                color: white,
                                size: 22.sp,
                              ),
                              SizedBox(width: 20.w),
                              Text(
                                'Fees',
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 15.sp,
                                    color: white,
                                    fontWeight: FontWeight.w400), maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: white,
                      thickness: 0.5,
                    ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: GestureDetector(
                          onTap: () async {
                            final pref = await SharedPreferences.getInstance();
                            String? token = await pref.getString("token");
                            pref.remove("token");
                            pref.remove("status");

                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EmailLogin()));
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=> EmailLogin()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.logout_rounded,
                                color: white,
                                size: 22.sp,
                              ),
                              SizedBox(width: 20.w),
                              Text(
                                'Logout',
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 15.sp,
                                    color: white,
                                    fontWeight: FontWeight.w400), maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedItemColor: theme.isDark == true ? white : black,
        selectedItemColor: theme.isDark == true ? purple : purple,
        selectedLabelStyle: TextStyle(
          fontSize: 12.sp,
          height: 2,
          fontFamily: "Poppins-SemiBold",
        ),
        unselectedLabelStyle: TextStyle(
            fontSize: 12.sp, height: 2, fontFamily: "Poppins-Regular"),
        backgroundColor: theme.isDark == true ? black : whiteBottomBar,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                MyAppIcons.homeicon,
                size: 21.sp,
              ),
              label: "Home",
              tooltip: "home"),
          BottomNavigationBarItem(
            icon: Icon(
              MyAppIcons.timetableicon,
              size: 21.sp,
            ),
            label: "Time Table",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              MyAppIcons.vleicon,
              size: 21.sp,
            ),
            label: "VLE",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              MyAppIcons.inquiryicon,
              size: 21.sp,
            ),
            label: "Inquiry",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: onTapped,
      ),
    );
  }
}
