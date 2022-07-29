import 'package:denning_portal/controllers/chats_controller.dart';
import 'package:denning_portal/screens/student_screens/chat_screens/inquiry_chat_screen.dart';
import 'package:denning_portal/screens/student_screens/inquiry_tabs/add_inquiry.dart';
import 'package:denning_portal/screens/student_screens/inquiry_tabs/inquiry_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../custom_widgets/custom_textStyle.dart';
import '../../../utils/colors.dart';
import '../../../providers/theme.dart';

class NoticeBoardQuery extends StatefulWidget {
  const NoticeBoardQuery({Key? key}) : super(key: key);

  @override
  State<NoticeBoardQuery> createState() => _NoticeBoardQueryState();
}

class _NoticeBoardQueryState extends State<NoticeBoardQuery> {

  String? token;
  String? studentId;
  String inquiry = "inquiry";

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
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    final theme = Provider.of<ThemeChanger>(context);

    return Scaffold(

      body: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Add your Inquiry",
                  style: CustomTextStyle.headingSemiBold2(
                      context, theme.isDark ? white : black),
                ),
                Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddInquiry()));
                  },
                  child: Icon(
                    Icons.add,
                    color: white,
                  ),
                  backgroundColor: purple,
                ),
              ],
            ),

            Flexible(
              child: FutureBuilder(
                  future: ChatsController.chatMessage(inquiry , context),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: CircularProgressIndicator(
                            color: theme.isDark ? white : cardColor,
                          ));
                    } else {
                      return Column(
                        children: [
                          SizedBox(
                            height: 12.h,
                          ),
                          snapshot.data!['status'] == 404
                              ? Center(
                              child: Text(
                                "No data available",
                                style: TextStyle(
                                    color: theme.isDark ? white : black,
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 18.sp),
                              ))
                              : Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data!['messages'].length,
                              itemBuilder: (context, int index) {
                                DateTime date =
                                new DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(snapshot.data['messages'][index]
                                    ['history'][0]['timestamp']) *
                                        1000);
                                var format = new DateFormat("dd MMM, yyyy");
                                var dateString = format.format(date);
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    InquiryChatScreen(
                                                        snapshot.data!['messages']
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
                                          height: 130.h,
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
                                                    Icon(
                                                      Icons.person_rounded,
                                                      size: 20.sp,
                                                      color: theme.isDark
                                                          ? white
                                                          : black,
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    Text(
                                                      "${snapshot.data['messages'][index]['reciever_data']['reciever_name']}",
                                                      style: TextStyle(
                                                          color: theme.isDark
                                                              ? white
                                                              : black,
                                                          fontSize: 15.sp,
                                                          fontFamily:
                                                          "Poppins-Regular"),
                                                    ),
                                                    Spacer(),
                                                    Theme(
                                                      data: Theme.of(context)
                                                          .copyWith(
                                                          textTheme: TextTheme().apply(
                                                              bodyColor: theme
                                                                  .isDark
                                                                  ? cardColor
                                                                  : cardColorlight),
                                                          iconTheme:
                                                          IconThemeData(
                                                            color:
                                                            theme.isDark
                                                                ? white
                                                                : black,
                                                          )),
                                                      child: PopupMenuButton<int>(
                                                        child: Icon(
                                                          Icons.more_vert_rounded,
                                                          size: 20,
                                                        ),
                                                        color: theme.isDark
                                                            ? cardColor
                                                            : whiteBottomBar,
                                                        itemBuilder: (context) =>
                                                        [
                                                          PopupMenuItem<int>(
                                                            value: 0,
                                                            child: Text(
                                                              "View",
                                                              style: CustomTextStyle
                                                                  .bodyRegular(
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
                                                              style: CustomTextStyle
                                                                  .bodyRegular(
                                                                  context,
                                                                  theme.isDark
                                                                      ? white
                                                                      : black),
                                                            ),
                                                          ),
                                                        ],
                                                        onSelected: (item) =>
                                                            SelectedItem(
                                                                context,
                                                                item,
                                                                snapshot.data![
                                                                'messages']
                                                                [index]),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.business,
                                                      size: 20.sp,
                                                      color: theme.isDark
                                                          ? white
                                                          : black,
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    Text(
                                                        "${snapshot.data['messages'][index]['reciever_data']['type']}",
                                                        style: TextStyle(
                                                            color: theme.isDark
                                                                ? white
                                                                : black,
                                                            fontSize: 15.sp,
                                                            fontFamily:
                                                            "Poppins-Regular")),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .calendar_today_rounded,
                                                      size: 19.sp,
                                                      color: theme.isDark
                                                          ? white
                                                          : black,
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    Text("${dateString}",
                                                        style: TextStyle(
                                                            color: theme.isDark
                                                                ? white
                                                                : black,
                                                            fontSize: 15.sp,
                                                            fontFamily:
                                                            "Poppins-Regular")),
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
                        ],
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  //popup menu
  void SelectedItem(BuildContext context, item, var data) {
    switch (item) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => InquiryDetail(data)));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => InquiryChatScreen(data)));
        break;
      case 2:
        break;
    }
  }
}
