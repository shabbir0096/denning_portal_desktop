import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:denning_portal/component/student_bottom_navigation.dart';
import 'package:denning_portal/screens/student_screens/setting_screen.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_macos_webview/flutter_macos_webview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../custom_widgets/custom_textStyle.dart';
import '../../custom_widgets/no_internet_screen.dart';
import '../../custom_widgets/scaffold_messenge_snackbar.dart';
import '../../providers/internet_checker.dart';
import '../../providers/theme.dart';
import '../../services/utilities/authication_check.dart';
import '../../utils/colors.dart';
import '../login_screens/email_login.dart';
import '../profile_screens/change_password.dart';
class VleMacos extends StatefulWidget {
  const VleMacos({Key? key}) : super(key: key);

  @override
  State<VleMacos> createState() => _VleMacosState();
}

class _VleMacosState extends State<VleMacos> {


  final textController = TextEditingController();
  String email = '';
  String url_link = '';
  var subscription;
  String connectionStatus = '';
  bool? _webviewAvailable;

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
          setState(() {
            url_link = convertedData['loginurl'].toString();
          });

          if (convertedData['loginurl'] == null) {
            CustomScaffoldWidget.buildErrorSnackbar(
                context, "${convertedData['message']}" + "$data");
          } else {
            // initPlatformState(url_link);
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

    getUser().then((value) => getUrl()).then((value) => _onOpenPressed(PresentationStyle.modal));
    super.initState();
  }


  Future<void> _onOpenPressed(PresentationStyle presentationStyle) async {
    final webview = FlutterMacOSWebView(
      onOpen: () => print('Opened'),
      onClose: () =>  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => StudentBottomNavigation()),
      (route) => false),
      onPageStarted: (url) => print('Page started: $url'),
      onPageFinished: (url) => print('Page finished: $url'),
      onWebResourceError: (err) {
        print(
          'Error: ${err.errorCode}, ${err.errorType}, ${err.domain}, ${err
              .description}',
        );
      },
    );

    await webview.open(
      javascriptEnabled: true,
      url: url_link,
      presentationStyle: presentationStyle,
      size: Size(1920.0.h, 1080.0.w),
      userAgent:
      'Mozilla/5.0 (iPhone; CPU iPhone OS 14_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
    );

    // await Future.delayed(Duration(seconds: 5));
    // await webview.close();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    final isOnline = Provider
        .of<ConnectivityService>(context)
        .isOnline;
    return Scaffold(
      backgroundColor: theme.isDark ? cardColor : whiteBottomBar,
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
          Theme(
            data: Theme.of(context).copyWith(
              textTheme: const TextTheme().apply(bodyColor: Colors.black),
              // iconTheme: IconThemeData(color: white, size: 28.sp),
            ),
            child: PopupMenuButton<int>(
              iconSize: 22.sp,
              color: theme.isDark == true ? cardColor : whiteBottomBar,
              itemBuilder: (context) =>
              [
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
              :  Center(
                child: SizedBox()
              ),
        ],
      ) : const NoInternetScreen(),
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
            context,
            MaterialPageRoute(builder: (context) => const EmailLogin()));
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
