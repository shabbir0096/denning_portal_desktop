import 'package:denning_portal/screens/student_screens/chat_screens/private_chat_screen.dart';
import 'package:denning_portal/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/chats_controller.dart';
import '../../../custom_widgets/custom_textStyle.dart';
import '../../../providers/theme.dart';

class PrivateMessages extends StatefulWidget {
  const PrivateMessages({Key? key}) : super(key: key);

  @override
  State<PrivateMessages> createState() => _PrivateMessagesState();
}

class _PrivateMessagesState extends State<PrivateMessages> {
  String? search;
  TextEditingController searchController = TextEditingController();
  String? token;
  String? studentId;
  String private = "private";

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
                    labelText: "Search for a person",
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
                      borderSide:
                      new BorderSide(color: theme.isDark ? white : black),
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
              height: 15.h,
            ),
            FutureBuilder(
                future: ChatsController.chatMessage(private, context),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                          color: theme.isDark ? white : cardColor,
                        ));
                  } else {
                    return snapshot.data!['status'] == 404
                        ? Center(
                      child: Text(
                        "No data available",
                        style: TextStyle(
                            color: theme.isDark ? white : black,
                            fontFamily: "Poppins-Regular",
                            fontSize: 18.sp),
                      ),
                    ):  Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!['messages'].length,
                        itemBuilder: (context, int index) {
                          var private_name = snapshot.data['messages'][index]['sender_data']['sender_name'][0];
                          if (searchController.text.isEmpty) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PrivateChatScreen(
                                                    snapshot.data!['messages']
                                                    [index])));
                                  },
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: lightPurple,
                                        radius: 30,
                                        child: Text(
                                          "${private_name}",
                                          style: CustomTextStyle.bodySemiBold(
                                              context,
                                              theme.isDark ? white : black),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        "${snapshot.data['messages'][index]['sender_data']['sender_name']}",
                                        style: CustomTextStyle.bodySemiBold(
                                            context,
                                            theme.isDark ? white : black),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 12.h,
                                )
                              ],
                            );
                          } else if (snapshot.data['messages'][index]
                          ['sender_data']['sender_name']
                              .toLowerCase()
                              .contains(searchController.text) ||
                              snapshot.data['messages'][index]['sender_data']
                              ['sender_name']
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
                                                PrivateChatScreen(
                                                    snapshot.data!['messages']
                                                    [index])));
                                  },
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: lightPurple,
                                        radius: 30,
                                        child: Text(
                                          "${private_name}",
                                          style: CustomTextStyle.bodySemiBold(
                                              context,
                                              theme.isDark ? white : black),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        "${snapshot.data['messages'][index]['sender_data']['sender_name']}",
                                        style: CustomTextStyle.bodySemiBold(
                                            context,
                                            theme.isDark ? white : black),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 12.h,
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
                }),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}