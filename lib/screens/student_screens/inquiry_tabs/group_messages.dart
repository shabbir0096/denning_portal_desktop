import 'package:denning_portal/screens/student_screens/chat_screens/group_chat_screen.dart';
import 'package:denning_portal/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/chats_controller.dart';
import '../../../custom_widgets/custom_textStyle.dart';
import '../../../providers/theme.dart';

class GroupMessages extends StatefulWidget {
  const GroupMessages({Key? key}) : super(key: key);

  @override
  State<GroupMessages> createState() => _GroupMessagesState();
}

class _GroupMessagesState extends State<GroupMessages> {
  String? token;
  String? studentId;
  String group = "group";
  String? search;
  TextEditingController searchController = TextEditingController();
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
  void dispose() {
    // TODO: implement dispose
      searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // final _height = MediaQuery.of(context).size.height -
    //     MediaQuery.of(context).padding.top -
    //     kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    final theme = Provider.of<ThemeChanger>(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        child: Column(
          children: [
            const SizedBox(
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
                    labelText: "Search for a group",
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
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                      BorderSide(color: theme.isDark ? white : black),
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
                future: ChatsController.chatMessage(group, context),
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
                    )
                        : Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!['messages'].length,
                        itemBuilder: (context, int index) {
                          var groupName = snapshot.data!['messages']![index]['group_name'][0];
                          if (searchController.text.isEmpty) {
                            return
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GroupChatScreen(snapshot
                                                      .data!['messages']
                                                  [index])));
                                    },
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: lightPurple,
                                          radius: 30,
                                          child: Text(
                                            "$groupName",
                                            style: CustomTextStyle
                                                .bodySemiBold(
                                                context,
                                                theme.isDark
                                                    ? white
                                                    : black),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Text(
                                          "${snapshot.data!['messages']![index]['group_name']}",
                                          style:
                                          CustomTextStyle.bodySemiBold(
                                              context,
                                              theme.isDark
                                                  ? white
                                                  : black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  )
                                ],
                              );
                          } else if (snapshot.data!['messages']![index]
                          ['group_name']
                              .toLowerCase()
                              .contains(searchController.text) ||
                              snapshot.data!['messages']![index]
                              ['group_name']
                                  .toUpperCase()
                                  .contains(searchController.text)) {
                            return snapshot.data!['messages'].length == 0
                                ? const Text("data")
                                :  Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GroupChatScreen(
                                                    snapshot.data![
                                                    'messages']
                                                    [index])));
                                  },
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                        lightPurple,
                                        radius: 30,
                                        child: Text(
                                          "$groupName",
                                          style: CustomTextStyle
                                              .bodySemiBold(
                                              context,
                                              theme.isDark
                                                  ? white
                                                  : black),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        "${snapshot.data!['messages']![index]['group_name']}",
                                        style: CustomTextStyle
                                            .bodySemiBold(
                                            context,
                                            theme.isDark
                                                ? white
                                                : black),
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
                          return const SizedBox(
                            height: 0,
                          );
                        },
                      ),
                    );
                  }
                }),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
