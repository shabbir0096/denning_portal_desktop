import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:webview_windows/webview_windows.dart';

import '../custom_widgets/custom_textStyle.dart';
import '../utils/colors.dart';
import '../providers/theme.dart';

class WebviewDsiplayDesktop extends StatefulWidget {
  String url="";
  WebviewDsiplayDesktop(this.url);

  @override
  State<WebviewDsiplayDesktop> createState() => _WebviewDsiplayDesktopState();
}

class _WebviewDsiplayDesktopState extends State<WebviewDsiplayDesktop> {
  late WebviewController _controller;
  String url_link ='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
  }
  Future<void> initPlatformState() async {
    _controller = WebviewController();
    await _controller.initialize();
    _controller.url.listen((url) {
    });
    _controller.loadUrl(
        widget.url);

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
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Container(
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
    return Scaffold(
        appBar: AppBar(
          title: Text("Details",
            style: CustomTextStyle.AppBarHeading(context , theme.isDark? white: black),),
          elevation: 0,
          backgroundColor: theme.isDark? cardColor: whiteBottomBar,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {

                Navigator.pop(context);

              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 18.sp,
              )),
          iconTheme: IconThemeData(color: theme.isDark? white: black),
        ),
        body: Builder(builder: (BuildContext context) {
          return compositeView();
        }));
  }
}
