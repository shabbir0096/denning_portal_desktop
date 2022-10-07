import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:webview_windows/webview_windows.dart';

import '../custom_widgets/custom_textStyle.dart';
import '../utils/colors.dart';
import '../providers/theme.dart';

class WebviewDsiplayDesktop extends StatefulWidget {
    String  url;
  WebviewDsiplayDesktop(this.url, {Key? key}) : super(key: key);

  @override
  State<WebviewDsiplayDesktop> createState() => _WebviewDsiplayDesktopState();
}

class _WebviewDsiplayDesktopState extends State<WebviewDsiplayDesktop> {
  final WebviewController _controller = WebviewController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
  }
  Future<void> initPlatformState() async {
    await _controller.initialize();
    setState(()  {
      _controller.url.listen((url) {});
      _controller.loadUrl(Uri.encodeFull(widget.url));
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
                  return const LinearProgressIndicator();
                }
              }),

        ],
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {


    final theme = Provider.of<ThemeChanger>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Preview",
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
