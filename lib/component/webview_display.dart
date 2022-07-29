import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../custom_widgets/custom_textStyle.dart';
import '../utils/colors.dart';
import '../providers/theme.dart';

class WebviewDsiplay extends StatelessWidget {
  String url="";
  WebviewDsiplay(this.url);

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {


    final theme = Provider.of<ThemeChanger>(context);

    var images=[
      ".jpg",
      ".jpeg",
      ".png",
      ".gif",

    ];


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
          return WebView(
            initialUrl: url.contains('.jpg') || url.contains('.jpeg') || url.contains('.png') || url.contains('.gif') ? url : "https://docs.google.com/viewer?url=${url}",
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                print('blocking navigation to $request}');
                return NavigationDecision.prevent;
              }
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
            },
            gestureNavigationEnabled: true,
          );
        }));
  }
}
