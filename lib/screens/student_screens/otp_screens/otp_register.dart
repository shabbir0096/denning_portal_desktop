import 'package:denning_portal/services/otp_verification.dart';
import 'package:denning_portal/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../custom_widgets/custom_button.dart';
import '../../../custom_widgets/custom_textFormField.dart';
import '../../../custom_widgets/custom_textStyle.dart';
import '../../../providers/internet_checker.dart';
import '../../../providers/theme.dart';
import '../../login_screens/email_login.dart';

class OtpResgister extends StatefulWidget {
  const OtpResgister({Key? key}) : super(key: key);

  @override
  State<OtpResgister> createState() => _OtpResgisterState();
}

class _OtpResgisterState extends State<OtpResgister> {

  bool buttonClicked=false;
  bool isChecked = false;
  TextEditingController phoneController = TextEditingController();
  String? phoneFormatted="";

  Future<void> getUser() async{
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    setState(() {

      phoneController.text = prefs.getString('phone')!;
      phoneFormatted = prefs.getString('phoneFormatted')!;




      print(phoneFormatted);
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


    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    final theme = Provider.of<ThemeChanger>(context);
    OtpServices otpServices=OtpServices();
    final isOnline = Provider.of<ConnectivityService>(context).isOnline;


    return Scaffold(
      appBar: AppBar(
        title: Text(
          "OTP",
          style: CustomTextStyle.AppBarHeading(
              context, theme.isDark ? white : black),
        ),
        elevation: 0,
        backgroundColor: theme.isDark ? cardColor : whiteBottomBar,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EmailLogin()));
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18.sp,
            )),
        iconTheme: IconThemeData(color: theme.isDark ? white : black),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
            EdgeInsets.only(top: 50.h, bottom: 20.h, left: 20.w, right: 20.w),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset( theme.isDark?
                    "assets/images/denning_logo_white.png":"assets/images/denning_logo_black.png",
                      width: 160.w,
                      height: 160.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 50.h,
                        child: VerticalDivider(
                          color: theme.isDark? white: black,
                          thickness: 4,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "OTP",
                        style: CustomTextStyle.heading1(context , theme.isDark? white: black),

                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  CustomTextField(
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    cursorColor: theme.isDark? white : black,
                    readOnlyField: true,
                   labelText: "${phoneController.text}",
                    hintText: "Provide your number",
                    icon: Icon(
                      Icons.mail,
                      color: theme.isDark? white: black,
                      size: 22.sp,
                                          ),
                    controller: phoneController,
                    onchanged: () {},
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a phone your register phone no!';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      phoneFormatted = value!;
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),


                  CustomButtonW(
                      buttonText: "Send",
                      isChecked: isChecked,
                      buttonClicked: buttonClicked,
                      onPress: (){
                        if(isOnline! == false){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            elevation: 1,
                            dismissDirection: DismissDirection.startToEnd,
                            behavior: SnackBarBehavior.floating,
                            content: Text(
                              "Please enable your internet connection",
                              style: TextStyle(
                                  fontSize: 14.sp, color: white, fontFamily: "Poppins-Regular"),
                            ),
                            backgroundColor: Colors.red,
                          ));
                        }
                        else
                          otpServices.postOtpRequest(phoneFormatted!,context);
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpResponse()));
                      }
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
