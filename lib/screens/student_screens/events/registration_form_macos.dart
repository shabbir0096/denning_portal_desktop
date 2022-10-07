
import 'dart:async';
import 'package:denning_portal/component/student_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_macos_webview/flutter_macos_webview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:webview_windows/webview_windows.dart';
import '../../../custom_widgets/custom_textStyle.dart';
import '../../../custom_widgets/no_internet_screen.dart';
import '../../../custom_widgets/scaffold_messenge_snackbar.dart';
import '../../../providers/internet_checker.dart';
import '../../../providers/theme.dart';
import '../../../utils/colors.dart';
import 'event_details.dart';
import 'event_screen.dart';

class RegistratioFormEventsMacOS extends StatefulWidget {
  List<String> userDetailsList;
   RegistratioFormEventsMacOS( {Key? key , required this.userDetailsList}) : super(key: key);


  @override
  State<RegistratioFormEventsMacOS> createState() => _RegistratioFormEventsMacOSState();
}

class _RegistratioFormEventsMacOSState extends State<RegistratioFormEventsMacOS> {

    String? googleFormLink_new;
  Future refineUrl(String googleFormLink) async {

    if(googleFormLink.contains("STUDENT_NAME")) {
      googleFormLink = googleFormLink.replaceAll("STUDENT_NAME", widget.userDetailsList[0]);
    }
    if(googleFormLink.contains("STUDENT_EMAIL@DENNINGSTUDENTS.COM")) {
      googleFormLink = googleFormLink.replaceAll("STUDENT_EMAIL@DENNINGSTUDENTS.COM", widget.userDetailsList[1]);
 }
    if(googleFormLink.contains("STUDENT_DRN")) {
      googleFormLink = googleFormLink.replaceAll("STUDENT_DRN", widget.userDetailsList[2]);
    }
    if(googleFormLink.contains("STUDENT_PHONE")) {
      googleFormLink = googleFormLink.replaceAll("STUDENT_PHONE", widget.userDetailsList[3]);
    }

    // repeat the above check for all the dynamic values
    googleFormLink_new = googleFormLink;

    return googleFormLink;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refineUrl(widget.userDetailsList[4]).then((value) => _onOpenPressed(PresentationStyle.modal));
    
  }
  Future<void> _onOpenPressed(PresentationStyle presentationStyle) async {
    final webview = FlutterMacOSWebView(
      onOpen: () => print('Opened'),
      onClose: ((){
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const StudentBottomNavigation()),
                (route) => false);

      }) ,
      onPageStarted: (url) => print('Page started: $url'),
      onPageFinished: (url) => print('Page finished: $url'),
      onWebResourceError: (err) {
      },
    );

    await webview.open(
      javascriptEnabled: true,
      url: Uri.encodeFull(googleFormLink_new!),
      presentationStyle: presentationStyle,
      size: Size(1024.0.h, 720.0.w),
      userAgent:
      'Mozilla/5.0 (iPhone; CPU iPhone OS 14_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
    );
  }

  @override
  Widget build(BuildContext context) {

    final theme = Provider.of<ThemeChanger>(context);
    final isOnline = Provider.of<ConnectivityService>(context).isOnline;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Event Registration",
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
     body:  isOnline! ? Column(
       mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         googleFormLink_new == ''
             ? Center(
             child:
             CircularProgressIndicator(
               color: theme.isDark ? white : cardColor,
             ))
             :  const Center(
             child: SizedBox()
         ),
       ],
     ): const NoInternetScreen(),
    );
  }
}
