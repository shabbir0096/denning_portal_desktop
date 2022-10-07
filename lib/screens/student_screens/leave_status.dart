import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../custom_widgets/custom_textStyle.dart';
import '../../utils/colors.dart';
import '../../providers/theme.dart';

class LeaveStatus extends StatefulWidget {
  const LeaveStatus({Key? key}) : super(key: key);

  @override
  _LeaveStatusState createState() => _LeaveStatusState();
}

class _LeaveStatusState extends State<LeaveStatus> {
  List leaveStatusList = [
    {"classHeldDate": "12-03-2020", "status": "Present"},
    {"classHeldDate": "12-03-2020", "status": "Absent"},
    {"classHeldDate": "12-03-2020", "status": "Present"},
    {"classHeldDate": "12-03-2020", "status": "Absent"},
    {"classHeldDate": "12-03-2020", "status": "Present"},
    {"classHeldDate": "12-03-2020", "status": "Present"},
    {"classHeldDate": "12-03-2020", "status": "Present"},
  ];
  int currentStep = 0;
  bool hide = true;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leave Status",
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
      body: Stepper(
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Row(
            children: const <Widget>[],
          );
        },
        steps: getSteps(theme),
        currentStep: currentStep,
        onStepTapped: (int step) {
          setState(() {
            currentStep = step;
          });
        },
        // onStepCancel: () {
        //   currentStep > 0 ? setState(() => currentStep -= 1) : null;
        // },
        onStepContinue: () {
          currentStep < 1 ? setState(() => currentStep += 1) : null;
        },
      ),
    );
  }

  List<Step> getSteps(theme) {
    return [
      Step(
        title: Text(
          'Public Law',
          style: CustomTextStyle.bodyRegular(context , theme.isDark? white: black),
        ),
        content: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: Container(
                height: 200.h,
                color:  theme.isDark? cardColor: cardColorlight,
                child: Column(
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Class held Date",
                            style: CustomTextStyle.bodyRegular(context , theme.isDark? white: black),
                          ),
                          Text(
                            "Status",
                            style: CustomTextStyle.bodyRegular(context , theme.isDark? white: black),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.white,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: leaveStatusList.length,
                        itemBuilder: (context, int index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                top: 10.h,
                                bottom: 10.h,
                                left: 20.w,
                                right: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${leaveStatusList[index]['classHeldDate']}",
                                  style: CustomTextStyle.bodyRegular(context , theme.isDark? white: black),
                                ),
                                Text(
                                  "${leaveStatusList[index]['status']}",
                                  style: CustomTextStyle.bodyRegular(context , theme.isDark? white: black),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      Step(
        title: Text(
          'Public Law',
          style: CustomTextStyle.bodyRegular(context , theme.isDark? white: black),
        ),
        content: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: Container(
                height: 200.h,
                color:  theme.isDark? cardColor: cardColorlight,
                child: Column(
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Class held Date",
                            style: CustomTextStyle.bodyRegular(context , theme.isDark? white: black),
                          ),
                          Text(
                            "Status",
                            style: CustomTextStyle.bodyRegular(context , theme.isDark? white: black),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.white,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: leaveStatusList.length,
                        itemBuilder: (context, int index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                top: 10.h,
                                bottom: 10.h,
                                left: 20.w,
                                right: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${leaveStatusList[index]['classHeldDate']}",
                                  style: CustomTextStyle.bodyRegular(context , theme.isDark? white: black),
                                ),
                                Text(
                                  "${leaveStatusList[index]['status']}",
                                  style: CustomTextStyle.bodyRegular(context , theme.isDark? white: black),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ];
  }
}