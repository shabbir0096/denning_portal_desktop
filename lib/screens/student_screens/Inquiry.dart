
import 'package:denning_portal/screens/student_screens/inquiry_tabs/group_messages.dart';
import 'package:denning_portal/screens/student_screens/inquiry_tabs/inquiries.dart';
import 'package:denning_portal/screens/student_screens/inquiry_tabs/private_messages.dart';
import 'package:denning_portal/screens/student_screens/setting_screen.dart';
import 'package:denning_portal/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../custom_widgets/custom_textStyle.dart';
import '../../custom_widgets/no_internet_screen.dart';
import '../../providers/internet_checker.dart';
import '../../providers/theme.dart';
import '../profile_screens/change_password.dart';
import '../login_screens/email_login.dart';

class NoticeBoard extends StatefulWidget {
  const NoticeBoard({Key? key}) : super(key: key);

  @override
  State<NoticeBoard> createState() => _NoticeBoardState();
}

class _NoticeBoardState extends State<NoticeBoard>
    with TickerProviderStateMixin {
  TabController? _controller;
  String connectionStatus='';

  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this);
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final isOnline = Provider.of<ConnectivityService>(context).isOnline;
    //
    // final _height = MediaQuery.of(context).size.height -
    //     MediaQuery.of(context).padding.top -
    //     kToolbarHeight;
    // final _width = MediaQuery.of(context).size.width;
    final theme = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Inquiry",
          style: CustomTextStyle.AppBarHeading(
              context, theme.isDark ? white : black),
        ),
        elevation: 0,
        backgroundColor: theme.isDark ? cardColor : whiteBottomBar,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(
              Icons.menu_rounded,
              size: 22.h,
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
          // ),
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
                  child: Text(
                    "Logout",
                    style: CustomTextStyle.bodyRegular(
                        context, theme.isDark ? white : black),
                  ),
                ),
              ],
              onSelected: (item) => SelectedItem(context, item),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _controller,
          indicatorColor: theme.isDark ? white : black,
          unselectedLabelStyle: CustomTextStyle.bodySemiBold(
              context, theme.isDark ? white : black),
          labelStyle: CustomTextStyle.bodySemiBold(
              context, theme.isDark ? white : black),
          labelColor: purple,
          unselectedLabelColor: theme.isDark ? white : black,
          tabs: const <Widget>[
            Tab(
              text: "INQUIRIES",
            ),
            Tab(
              text: "GROUP",
            ),
            Tab(
              text: "PRIVATE",
            ),
          ],
        ),
      ),
      body:isOnline! ? TabBarView(
        controller: _controller,
        children: const <Widget>[
          NoticeBoardQuery(),
          GroupMessages(),
          PrivateMessages()
        ],
      ): const NoInternetScreen(),
    );
  }

  //popup menu
  Future<void> SelectedItem(BuildContext context, item) async {
    switch (item) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const SettingScreen()));
        break;
      case 1:

      case 2:
      final pref = await SharedPreferences.getInstance();
      //String? token = await pref.getString("token");
      pref.remove("token");
      pref.remove("status");
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const EmailLogin()));
      break;

    }
  }
}
