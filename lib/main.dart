import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:denning_portal/component/student_bottom_navigation.dart';
import 'package:denning_portal/providers/internet_checker.dart';
import 'package:denning_portal/screens/student_screens/spalsh_screen.dart';
import 'package:denning_portal/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'component/custom_scroll_behavior.dart';
import 'custom_widgets/custom_animations.dart';


String get name => 'foo';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  String? status = prefs.getString('status');
  runApp(MyApp(token, status));
  configLoading();
  doWhenWindowReady(() {
    const initialSize = Size(1024 , 720);
    const minSize = Size(1024, 720);
    const maxSize = Size(1920 , 1200);
    appWindow.maxSize = maxSize;
    appWindow.minSize = minSize;
    appWindow.size = initialSize; //default size
    appWindow.show();
  });
}
void configLoading() {


  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = const Color(0xff233421)
    ..backgroundColor = const Color(0xff233421)
    ..indicatorColor = const Color(0xff233421)
    ..textColor = const Color(0xff233421)
    ..maskColor = const Color(0xff233421)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}


class MyApp extends StatelessWidget {
  var token;
  var status;
  String deviceTokenToSendPushNotification = "";

  MyApp(this.token, this.status, {Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeChanger(),),
        ChangeNotifierProvider(create: (_) => ConnectivityService())
      ],

      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
          builder: (context , child) {
          final themeChanger = Provider.of<ThemeChanger>(context);
          final internetChecker = Provider.of<ConnectivityService>(context);
          internetChecker.connectivityProvider();
          return  MaterialApp(
            scrollBehavior: MyCustomScrollBehavior(),
            //themeMode: themeChanger.darkMode ? dark_mode : light_mode,
            theme: themeChanger.isDark ? dark_mode : light_mode,

            home: token == null || status == null
                ? const SplashScreen()
                : StudentBottomNavigation(),

            debugShowCheckedModeBanner: false,
            builder: (context, widget) {
              //add this line

              return MediaQuery(
                //Setting font does not change with system font size
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!,
              );
            },
          );
        }),
    );
  }

}
