// import 'dart:async';
// import 'package:denning_portal/component/student_bottom_navigation.dart';
// import 'package:denning_portal/utils/colors.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pinput/pinput.dart';
// import 'package:provider/provider.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import '../../../custom_widgets/custom_button.dart';
// import '../../../custom_widgets/custom_dialogue_windows.dart';
// import '../../../custom_widgets/custom_textStyle.dart';
// import '../../../providers/internet_checker.dart';
// import '../../../services/otp_verification.dart';
// import '../../../providers/theme.dart';
//
// class OtpResponse extends StatefulWidget {
//   int msg;
//   String? phoneFormatted;
//
//
//   OtpResponse(this.msg, this.phoneFormatted);
//
//   @override
//   State<OtpResponse> createState() => _OtpResponseState();
// }
//
// class _OtpResponseState extends State<OtpResponse> {
//   bool buttonClicked = false;
//   TextEditingController pinController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//   final interval = const Duration(seconds: 1);
//   final int timerMaxSeconds = 60;
//   int currentSeconds = 0;
//
//   String get timerText =>
//       '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')} : ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';
//
//   startTimeout([int? milliseconds]) {
//     var duration = interval;
//     Timer.periodic(duration, (timer) {
//       setState(() {
//         print(timer.tick);
//         currentSeconds = timer.tick;
//         if (timer.tick >= timerMaxSeconds) timer.cancel();
//       });
//     });
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     startTimeout();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isOnline = Provider.of<ConnectivityService>(context).isOnline;
//     OtpServices otpServices=OtpServices();
//     final _height = MediaQuery.of(context).size.height -
//         MediaQuery.of(context).padding.top -
//         kToolbarHeight;
//     final _width = MediaQuery.of(context).size.width;
//     final theme = Provider.of<ThemeChanger>(context);
//
//
//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
//             child: Form(
//               key: formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Image.asset(
//                       theme.isDark
//                           ? "assets/images/denning_logo_white.png"
//                           : "assets/images/denning_logo_black.png",
//                       width: 160.w,
//                       height: 160.h,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 70.h,
//                   ),
//                   Row(
//                     children: [
//                       Container(
//                         height: 65.h,
//                         child: VerticalDivider(
//                           color: theme.isDark ? white : black,
//                           thickness: 5,
//                         ),
//                       ),
//                       SizedBox(
//                         width: 12.w,
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Verification",
//                             style: CustomTextStyle.headingSemiBold(
//                                 context, theme.isDark ? white : black),
//                           ),
//                           Text(
//                             "Enter your verification code here",
//                             style: CustomTextStyle.titleRegular(
//                                 context, theme.isDark ? white : black),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 50.h,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 20.w, right: 20.w),
//                     child: Pinput(
//                       controller: pinController,
//                       defaultPinTheme: PinTheme(
//                         width: 56.w,
//                         height: 56.h,
//                         textStyle: TextStyle(
//                             fontSize: 20,
//                             color: theme.isDark ? white : black,
//                             fontWeight: FontWeight.w600),
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                               color: theme.isDark ? white : black, width: 2),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                       separator: SizedBox(
//                         width: 20.w,
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 70.h,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 5.w, right: 5.w),
//                     child: Row(
//                       children: [
//                         if (timerText == "00 : 00")
//                           GestureDetector(
//                             onTap: (){
//                               otpServices.postOtpRequest(widget.phoneFormatted,context);
//                             },
//                             child: Text(
//                               "Resend OTP",
//                               style: TextStyle(
//                                   fontFamily: "Poppins-Regular",
//                                   color: theme.isDark ? white : black,
//                                   fontSize: 15.sp),
//                             ),
//                           ),
//                         Spacer(),
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: <Widget>[
//                             Icon(
//                               Icons.timer,
//                               size: 30.h,
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text(
//                               timerText,
//                               style: TextStyle(
//                                   fontFamily: "Poppins-Regular",
//                                   color: theme.isDark ? white : black,
//                                   fontSize: 22.sp),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20.h,
//                   ),
//                   CustomButtonW(
//                       buttonText: "Send",
//                       buttonClicked: buttonClicked,
//                       onPress: () {
//                         if(isOnline! == false){
//                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                             elevation: 1,
//                             dismissDirection: DismissDirection.startToEnd,
//                             behavior: SnackBarBehavior.floating,
//                             content: Text(
//                               "Please enable your internet connection",
//                               style: TextStyle(
//                                   fontSize: 14.sp, color: white, fontFamily: "Poppins-Regular"),
//                             ),
//                             backgroundColor: Colors.red,
//                           ));
//                         }
//                         else if (pinController.text == widget.msg.toString()) {
//                           Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       StudentBottomNavigation()));
//                         } else {
//                           // Navigator.push(
//                           //     context,
//                           //     MaterialPageRoute(
//                           //         builder: (context) => StudentBottomNavigation()));
//                           CustomDialogueWindows(
//                               context,
//                               "Alert",
//                               "Wrong pin code ",
//                               "Your pin code is wrong. Enter valid code",
//                               "OK",
//                               AlertType.error);
//                         }
//                       })
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildPinPut() {
//     return Pinput(
//       onCompleted: (pin) => print(pin),
//     );
//   }
// }
