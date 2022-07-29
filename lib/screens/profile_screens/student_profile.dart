import 'package:denning_portal/screens/profile_screens/change_password.dart';
import 'package:denning_portal/screens/student_screens/setting_screen.dart';
import 'package:denning_portal/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../custom_widgets/custom_textStyle.dart';
import '../../providers/theme.dart';
import '../login_screens/email_login.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({Key? key}) : super(key: key);

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  String? name = "";
  String? studentCode = "";
  String? email = "";
  String? phone = "";
  String? address = "";
  String? image = "";

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name')!;
      studentCode = prefs.getString('studentCode')!;
      email = prefs.getString('email')!;
      phone = prefs.getString('phone')!;
      address = prefs.getString('address')!;
      image = prefs.getString('image')!;

      print(name);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
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
        actions: <Widget>[
          Theme(
            data: Theme.of(context).copyWith(
                textTheme: TextTheme().apply(bodyColor: Colors.black),
                iconTheme: IconThemeData(
                    color: theme.isDark ? white : black, size: 28.sp)),
            child: PopupMenuButton<int>(
              iconSize: 22.sp,
              color: theme.isDark == true ? cardColor : whiteBottomBar,
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,

                  child: GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingScreen()));
                    },
                    child: Text(
                      "Setting",
                      style: CustomTextStyle.bodyRegular(
                          context, theme.isDark ? white : black),
                    ),
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
                  value: 2,
                  child: GestureDetector(
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      String? token = await prefs.getString("token");
                      prefs.remove("token");
                      prefs.remove("status");
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmailLogin()));
                    },
                    child: Text(
                      "Logout",
                      style: CustomTextStyle.bodyRegular(
                          context, theme.isDark ? white : black),
                    ),
                  ),
                ),
              ],
              onSelected: (item) => SelectedItem(context, item),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  // child: Image.asset("assets/images/profile_image.png",
                  //     width: 100.w, height: 100.h, fit: BoxFit.contain),
                  child: CircleAvatar(
                    backgroundColor:
                    theme.isDark == true ? white : black,
                    radius: 80,
                    child: CircleAvatar(
                      radius: 75,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: image!.isEmpty
                            ? AssetImage(
                            "assets/images/default_profile_image.jpeg")
                        as ImageProvider
                            : NetworkImage(image!),
                        child: const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: 250.w,
                        child: Text(
                          "${name}",
                          style: CustomTextStyle.headingSemiBold(
                              context, theme.isDark ? white : purple),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "${studentCode}",
                      style: CustomTextStyle.bodySemiBold(
                          context, theme.isDark ? white : black),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: 20.h, left: 10.w, right: 10.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: purple,
                            child: Icon(
                              Icons.email,
                              color: Colors.white,
                              size: 28.h,
                            ),
                            radius: 25,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email",
                                  style: CustomTextStyle.titleSemiBold(
                                      context, theme.isDark ? white : purple),
                                ),
                                Container(
                                  width: 210.w,
                                  child: Text(
                                    "${email}",
                                    style: CustomTextStyle.bodyRegular(
                                        context, theme.isDark ? white : black),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: purple,
                            child: Icon(
                              Icons.phone,
                              color: Colors.white,
                              size: 28.h,
                            ),
                            radius: 25,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Phone",
                                  style: CustomTextStyle.titleSemiBold(
                                      context, theme.isDark ? white : purple),
                                ),
                                Text(
                                  "${phone}",
                                  style: CustomTextStyle.bodyRegular(
                                      context, theme.isDark ? white : black),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: purple,
                            child: Icon(
                              Icons.home,
                              color: Colors.white,
                              size: 28.h,
                            ),
                            radius: 25,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Address",
                                    style: CustomTextStyle.titleSemiBold(
                                        context, theme.isDark ? white : purple),
                                  ),
                                  Container(
                                    width: 200.w,
                                    child: Text(
                                      "${address}",
                                      style: CustomTextStyle.bodyRegular(
                                          context,
                                          theme.isDark ? white : black),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //popup menu
  Future<void> SelectedItem(BuildContext context, item) async {
    switch (item) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SettingScreen()));
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ChangePassword()));
        break;
      case 2:
        print("User Logged out");
        print("New Broadcast Clicked");
        final prefs = await SharedPreferences.getInstance();
        String? token = await prefs.getString("token");
        prefs.remove("token");
        prefs.remove("status");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EmailLogin()));
        break;
        break;
    }
  }
}
