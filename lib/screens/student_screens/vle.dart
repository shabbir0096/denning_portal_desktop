import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:denning_portal/screens/student_screens/setting_screen.dart';
import 'package:denning_portal/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_windows/webview_windows.dart';
import '../../custom_widgets/custom_textStyle.dart';
import '../../custom_widgets/no_internet_screen.dart';
import '../../custom_widgets/scaffold_messenge_snackbar.dart';
import '../../providers/internet_checker.dart';
import '../../providers/theme.dart';
import '../../services/utilities/authication_check.dart';
import '../profile_screens/change_password.dart';
import 'package:http/http.dart' as http;
import '../login_screens/email_login.dart';

class Vle extends StatefulWidget {
  const Vle({Key? key}) : super(key: key);

  @override
  State<Vle> createState() => _VleState();
}

class _VleState extends State<Vle> {
  WebviewController _controller = WebviewController();

  final textController = TextEditingController();
  String email = '';
  String url_link = '';
  var subscription;
  String connectionStatus = '';


  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email')!;
    });
  }

  Future getUrl() async {
    var convertedData;
    try {
    Map data = {"user[email]": "${email}"};
    final response = await http.post(
      Uri.parse(
          "https://www.denningportal.com/vle/webservice/rest/server.php?wstoken=7ec7ce8f1b1afea19a63361b34a99dd8&wsfunction=auth_userkey_request_login_url&moodlewsrestformat=json"),
      body: data,
    );
    if (response.statusCode == 200) {
      convertedData = json.decode(response.body);
        if (convertedData != null) {
          url_link = convertedData['loginurl'].toString();
          if (convertedData['loginurl'] == null) {
            CustomScaffoldWidget.buildErrorSnackbar(
                context, "${convertedData['message']}"+"$data");
          } else {
            initPlatformState(url_link);
          }
        }
      } else {
      AuthChecker.exceptionHandling(context, response.statusCode);
    }
  } on TimeoutException catch (e) {
      CustomScaffoldWidget.buildErrorSnackbar(context, "Time out try again");
    } on SocketException catch (e) {
      CustomScaffoldWidget.buildErrorSnackbar(
          context, "Please enable your internet connection");
    } on Error catch (e) {
      CustomScaffoldWidget.buildErrorSnackbar(context, "Something went wrong");
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    getUser().then((value) => getUrl());

    super.initState();
  }


  Future<void> initPlatformState(String url) async {
    await _controller.initialize();
    setState(()  {
      _controller.url.listen((url) {});
      _controller.loadUrl(Uri.encodeFull(url_link));
      if (!mounted) return;

    });
  }

  Widget compositeView() {
      return Container(
        color: Colors.white,
        child: Column(
          children: [
            StreamBuilder<LoadingState>(
                stream: _controller.loadingState,
                builder: (context, snapshot) {
                  if (snapshot.hasData ) {
                    return   Expanded(child: Webview(_controller));
                  } else {
                    return LinearProgressIndicator();
                  }
                }),

          ],
        ),
      );

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
        backgroundColor: theme.isDark ? cardColor : whiteBottomBar,
        title: Text(
          "VLE",
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
          // ),
          Theme(
            data: Theme.of(context).copyWith(
              textTheme: TextTheme().apply(bodyColor: Colors.black),
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
      ),
      body: isOnline! ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          url_link == ''
              ? Center(
                  child:
                       CircularProgressIndicator(
                          color: theme.isDark ? white : cardColor,
                        ))
              : Expanded(child: compositeView()),
        ],
      ): NoInternetScreen(),
    );
  }

  //popup menu
  void SelectedItem(BuildContext context, item) async {
    switch (item) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SettingScreen()));
        break;
      case 1:
        print("New Broadcast Clicked");
        final pref = await SharedPreferences.getInstance();
        String? token = await pref.getString("token");
        pref.remove("token");
        pref.remove("status");
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EmailLogin()));
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
