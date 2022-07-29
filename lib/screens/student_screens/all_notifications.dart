import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../custom_widgets/custom_textStyle.dart';
import '../../utils/colors.dart';
import '../../providers/theme.dart';

class AllNotifications extends StatefulWidget {
  const AllNotifications({Key? key}) : super(key: key);

  @override
  State<AllNotifications> createState() => _AllNotificationsState();
}

class _AllNotificationsState extends State<AllNotifications> {
  String? search;
  TextEditingController searchController = TextEditingController();

  List notifications = [
    {"department": "Admin", "name": "Sir Rajesh", "time": "${DateTime.now()}"},
    {"department": "IT", "name": "Sir Hatim", "time": "${DateTime.now()}"},
    {
      "department": "Placement",
      "name": "Sir Ruhail",
      "time": "${DateTime.now()}"
    },
    {
      "department": "IT-Software",
      "name": "Sir Rizwan",
      "time": "${DateTime.now()}"
    }
  ];

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    final theme = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
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
                    print(search);
                  },
                  cursorColor: theme.isDark ? white : black,
                  style: TextStyle(color: theme.isDark ? white : black),
                  decoration: InputDecoration(
                      labelText: "Search Notifications",
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: theme.isDark ? white : black,
                      ),
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
                      hintText: "Search",
                      hintStyle: TextStyle(
                          fontFamily: "Poppins-Regular",
                          fontSize: 12.sp,
                          color: theme.isDark ? white : black),
                      labelStyle: TextStyle(
                          color: theme.isDark ? white : black,
                          fontFamily: "Poppins-Regular",
                          fontSize: 12.sp)),
                ),
                data: Theme.of(context).copyWith(
                  primaryColor: theme.isDark ? white : black,
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, int i) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => Checkout()));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                          child: Container(
                            height: 120.h,
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
                              padding: EdgeInsets.only(left: 20.w, right: 20.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.person_rounded,
                                        size: 22.sp,
                                        color:  theme.isDark ? white : black,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        "${notifications[i]['name']}",
                                        style: CustomTextStyle.titleSemiBold(
                                            context,
                                            theme.isDark ? white : black),
                                      ),
                                      Spacer(),
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                            textTheme: TextTheme().apply(
                                                bodyColor: theme.isDark
                                                    ? white
                                                    : black),
                                            iconTheme: IconThemeData(
                                              color:
                                                  theme.isDark ? white : black,
                                            )),
                                        child: PopupMenuButton<int>(
                                          child: Icon(
                                            Icons.more_vert_rounded,
                                            size: 20,
                                          ),
                                          color: theme.isDark
                                              ? cardColor
                                              : whiteBottomBar,
                                          itemBuilder: (context) => [
                                            PopupMenuItem<int>(
                                              value: 0,
                                              child: Text(
                                                "View",
                                                style:
                                                    CustomTextStyle.bodyRegular(
                                                        context,
                                                        theme.isDark
                                                            ? white
                                                            : black),
                                              ),
                                            ),
                                            PopupMenuItem<int>(
                                              value: 1,
                                              child: Text(
                                                "Reply",
                                                style:
                                                    CustomTextStyle.bodyRegular(
                                                        context,
                                                        theme.isDark
                                                            ? white
                                                            : black),
                                              ),
                                            ),
                                          ],
                                          onSelected: (item) =>
                                              SelectedItem(context, item),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.business,
                                        size: 22.sp,
                                        color: theme.isDark ? white : black,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        "${notifications[i]['department']}",
                                        style: CustomTextStyle.bodySemiBold(
                                            context,
                                            theme.isDark ? white : black),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.access_alarm,
                                        size: 22.sp,
                                        color: theme.isDark ? white : black,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        "${notifications[i]['time']}",
                                        style: CustomTextStyle.bodySemiBold(
                                            context,
                                            theme.isDark ? white : black),
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
                        height: 10.h,
                      )
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  //popup menu
  void SelectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>NoticeDescription()));
        break;
      case 1:
        break;
      case 2:
        print("User Logged out");
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => LoginPage()),
        //         (route) => false);
        break;
    }
  }
}
