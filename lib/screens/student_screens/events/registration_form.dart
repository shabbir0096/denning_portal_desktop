
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:webview_windows/webview_windows.dart';
import '../../../custom_widgets/custom_textStyle.dart';
import '../../../custom_widgets/no_internet_screen.dart';
import '../../../providers/internet_checker.dart';
import '../../../providers/theme.dart';
import '../../../utils/colors.dart';

class RegistratioFormEvents extends StatefulWidget {
  List<String> userDetailsList;
   RegistratioFormEvents( {Key? key , required this.userDetailsList}) : super(key: key);


  @override
  State<RegistratioFormEvents> createState() => _RegistratioFormEventsState();
}

class _RegistratioFormEventsState extends State<RegistratioFormEvents> {
  WebviewController _controller = WebviewController();
    String? googleFormLink_new;
  String refineUrl(String googleFormLink) {

    if(googleFormLink.contains("STUDENT_NAME")) {
      googleFormLink = googleFormLink.replaceAll("STUDENT_NAME", "${widget.userDetailsList[0]}");
    }
    if(googleFormLink.contains("STUDENT_EMAIL@DENNINGSTUDENTS.COM")) {
      googleFormLink = googleFormLink.replaceAll("STUDENT_EMAIL@DENNINGSTUDENTS.COM", "${widget.userDetailsList[1]}");
 }
    if(googleFormLink.contains("STUDENT_DRN")) {
      googleFormLink = googleFormLink.replaceAll("STUDENT_DRN", "${widget.userDetailsList[2]}");
    }
    if(googleFormLink.contains("STUDENT_PHONE")) {
      googleFormLink = googleFormLink.replaceAll("STUDENT_PHONE", "${widget.userDetailsList[3]}");
    }

    // repeat the above check for all the dynamic values
    googleFormLink_new = googleFormLink;
    initPlatformState(googleFormLink_new!);
    return googleFormLink;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refineUrl("${widget.userDetailsList[4]}");
  }

  Future<void> initPlatformState(String url) async {
    await _controller.initialize();
    _controller.url.listen((url) {});
    _controller.loadUrl(googleFormLink_new!);

    if (!mounted) return;

    setState(() {});
  }
  Widget compositeView() {
    if (!_controller.value.isInitialized) {
      return const Text(
        'Loading...',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
        ),
      );
    } else {
      return Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(child: Webview(_controller)),
          ],
        ),
      );
    }
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
             : Expanded(child: compositeView()),
       ],
     ): NoInternetScreen(),
    );
  }
}