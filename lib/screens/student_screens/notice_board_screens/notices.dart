import 'package:denning_portal/screens/student_screens/notice_board_screens/notice_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/dashboard_controller.dart';
import '../../../custom_widgets/custom_textStyle.dart';
import '../../../custom_widgets/no_internet_screen.dart';
import '../../../providers/internet_checker.dart';
import '../../../utils/colors.dart';
import '../../../providers/theme.dart';

class Notices extends StatefulWidget {
  const Notices({Key? key}) : super(key: key);

  @override
  State<Notices> createState() => _NoticesState();
}

class _NoticesState extends State<Notices> {
  String? search;
  TextEditingController searchController = TextEditingController();

  String? token = "";
  String? studentId = "";

  DashboardController dashboardController = DashboardController();

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token')!;
      studentId = prefs.getString('studentId');
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
    final isOnline = Provider.of<ConnectivityService>(context).isOnline;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notice Board",
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
      body:isOnline! ?  Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(_width * 0.01),
              child: Theme(
                child: TextFormField(
                  controller: searchController,
                  onChanged: (String value) {
                    setState(() {
                      search = value;
                    });
                  },
                  cursorColor: theme.isDark ? white : black,
                  style: TextStyle(color: theme.isDark ? white : black),
                  decoration: InputDecoration(
                    labelText: "Search notice",
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: theme.isDark ? white : black,
                    ),
                    fillColor: theme.isDark ? white : black,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: theme.isDark ? white : black, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide: new BorderSide(
                          color: theme.isDark ? white : black, width: 1.0),
                    ),
                    border: InputBorder.none,
                    hintText: "search",
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
            ),
            SizedBox(
              height: 5.h,
            ),
            FutureBuilder(
              future: dashboardController.dashboardData(token, studentId),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: theme.isDark ? white : cardColor,
                  ));
                } else {
                  return snapshot.data['notices'] == null
                      ? const Text("No data available")
                      : Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!['notices'].length,
                            itemBuilder: (context, int index) {
                              if (searchController.text.isEmpty) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NoticeDescription(snapshot
                                                            .data!['notices']
                                                        [index])));
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                          bottomLeft: Radius.circular(8.0),
                                          topRight: Radius.circular(8.0),
                                        ),
                                        child: Container(
                                          height: 170.h,
                                          width: double.infinity,
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
                                                left: 20.w, right: 20.w),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 270,
                                                      child: Text(
                                                        "${snapshot.data!['notices'][index]['notice_title']}",
                                                        //  style: CustomTextStyle.headingSemiBold(context , theme.isDark? white : purple),
                                                        style: TextStyle(
                                                            color:
                                                                theme.isDark ==
                                                                        true
                                                                    ? white
                                                                    : purple,
                                                            fontSize: 18.sp,
                                                            fontFamily:
                                                                "Poppins-SemiBold"),
                                                        maxLines: 2,
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                snapshot.data!['notices'][index]['notice_date'] == null? SizedBox(height: 0,) :   Text(
                                                  "${DateFormat('dd MMM, yyyy').format(DateTime.parse(snapshot.data!['notices'][index]['notice_date']))}",
                                                  style: TextStyle(
                                                      color:
                                                          theme.isDark == true
                                                              ? white
                                                              : black,
                                                      fontSize: 14.sp,
                                                      fontFamily:
                                                          "Poppins-Regular"),
                                                ),

                                                Spacer(),
                                                if("${snapshot.data!['notices'][index]['notice']}" != null && "${snapshot.data!['notices'][index]['notice'] }" != "")
                                                Text(
                                                  "Description :",
                                                  style: TextStyle(
                                                      color:
                                                          theme.isDark == true
                                                              ? white
                                                              : black,
                                                      fontSize: 16.sp,
                                                      fontFamily:
                                                          "Poppins-SemiBold"),
                                                ),

                                                //Text("${notices[i]['Description'].length > 15 ?notices[i]['Description'].substring(0,15): notices[i]['Description'] }",style: TextStyle(color: white,fontFamily:  "Poppins-Regular",fontSize:17.sp),),
                                                Text(
                                                  "${snapshot.data!['notices'][index]['notice']}",
                                                  style: TextStyle(
                                                      color:
                                                          theme.isDark == true
                                                              ? white
                                                              : black,
                                                      fontSize: 12.sp,
                                                      fontFamily:
                                                          "Poppins-Regular"),
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    )
                                  ],
                                );
                              } else if (snapshot.data!['notices'][index]
                                          ['notice_title']
                                      .toLowerCase()
                                      .contains(searchController.text) ||
                                  snapshot.data!['notices'][index]
                                          ['notice_title']
                                      .toUpperCase()
                                      .contains(searchController.text)) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NoticeDescription(snapshot
                                                            .data!['notices']
                                                        [index])));
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                          bottomLeft: Radius.circular(8.0),
                                          topRight: Radius.circular(8.0),
                                        ),
                                        child: Container(
                                          height: 170.h,
                                          width: double.infinity,
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
                                                left: 20.w, right: 20.w),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width: 270,
                                                        child: Text(
                                                          "${snapshot.data!['notices'][index]['notice_title']}",
                                                          //  style: CustomTextStyle.headingSemiBold(context , theme.isDark? white : purple),
                                                          style: TextStyle(
                                                              color:
                                                                  theme.isDark ==
                                                                          true
                                                                      ? white
                                                                      : purple,
                                                              fontSize: 18.sp,
                                                              fontFamily:
                                                                  "Poppins-SemiBold"),
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ]),

                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                snapshot.data!['notices'][index]['notice_date'] == null? SizedBox(height: 0,) : Text(
                                                  "${DateFormat('dd MMM, yyyy').format(DateTime.parse(snapshot.data!['notices'][index]['notice_date']))}",
                                                  style: TextStyle(
                                                      color:
                                                          theme.isDark == true
                                                              ? white
                                                              : black,
                                                      fontSize: 14.sp,
                                                      fontFamily:
                                                          "Poppins-Regular"),
                                                ),

                                                Spacer(),
                                                Text(
                                                  "Description :",
                                                  style: TextStyle(
                                                      color:
                                                          theme.isDark == true
                                                              ? white
                                                              : black,
                                                      fontSize: 16.sp,
                                                      fontFamily:
                                                          "Poppins-SemiBold"),
                                                ),

                                                //Text("${notices[i]['Description'].length > 15 ?notices[i]['Description'].substring(0,15): notices[i]['Description'] }",style: TextStyle(color: white,fontFamily:  "Poppins-Regular",fontSize:17.sp),),
                                                Text(
                                                  "${snapshot.data!['notices'][index]['notice']}",
                                                  style: TextStyle(
                                                      color:
                                                          theme.isDark == true
                                                              ? white
                                                              : black,
                                                      fontSize: 12.sp,
                                                      fontFamily:
                                                          "Poppins-Regular"),
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    )
                                  ],
                                );
                              }
                              return SizedBox(
                                height: 0,
                              );
                            },
                          ),
                        );
                }
              },
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ): NoInternetScreen(),
    );
  }

  //popup menu
  void SelectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => NoticeDescription()));
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
