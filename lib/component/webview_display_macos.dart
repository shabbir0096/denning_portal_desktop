import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_macos_webview/flutter_macos_webview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../custom_widgets/custom_textStyle.dart';
import '../custom_widgets/no_internet_screen.dart';
import '../providers/internet_checker.dart';
import '../providers/theme.dart';
import '../utils/colors.dart';

class WebviewDisplayMacos extends StatefulWidget {
  dynamic urlLink;
  WebviewDisplayMacos(this.urlLink, {Key? key}) : super(key: key);

  @override
  State<WebviewDisplayMacos> createState() => _WebviewDisplayMacosState();
}

class _WebviewDisplayMacosState extends State<WebviewDisplayMacos> {

  @override
  void initState() {
    // TODO: implement initState

    _onOpenPressed(PresentationStyle.modal);
    super.initState();
  }


  Future<void> _onOpenPressed(PresentationStyle presentationStyle) async {
    final webview = FlutterMacOSWebView(
      onOpen: () => print('Opened'),
      onClose: ((){
        Navigator.pop(context);

      }),
      onPageStarted: (url) => print('Page started: $url'),
      onPageFinished: (url) => print('Page finished: $url'),
      onWebResourceError: (err) {
        if (kDebugMode) {
          print(
          'Error: ${err.errorCode}, ${err.errorType}, ${err.domain}, ${err
              .description}',
        );
        }
      },
    );

    await webview.open(
      javascriptEnabled: true,
      url: widget.urlLink,
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
    final isOnline = Provider.of<ConnectivityService>(context).isOnline;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Preview",
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
      body: isOnline! ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.urlLink == ''
              ? Center(
              child:
              CircularProgressIndicator(
                color: theme.isDark ? white : cardColor,
              ))
              :  const Center(
              child: SizedBox()
          ),
        ],
      ) : const NoInternetScreen(),
    );
  }
}
