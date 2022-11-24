import 'package:denning_portal/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../custom_widgets/custom_textStyle.dart';
import '../../providers/theme.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Setting",
          style: CustomTextStyle.AppBarHeading(context , theme.isDark? white: black),
        ),
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
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            child: AnimatedCrossFade(
              crossFadeState: Theme.of(context).brightness == Brightness.light
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Image.asset(
                "assets/images/sun.png",
                width: 200,
              ),
              secondChild: Image.asset(
                "assets/images/moon.png",
                width: 200,
              ),
              duration: const Duration(milliseconds: 200),
            ),
          ),
          Container (
            padding: const EdgeInsets.only(left:15, right: 15, bottom: 30),
            child: Consumer<ThemeChanger>(
              builder: (context,notifier,child) => SwitchListTile(
                title: const Text("Dark Mode"),
                onChanged: (val){
                  notifier.toggleChangeTheme();
                },
                value: notifier.isDark ,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
