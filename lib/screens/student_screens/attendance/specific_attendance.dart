
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controllers/general_attendance_controller.dart';
import '../../../custom_widgets/custom_textStyle.dart';
import '../../../utils/colors.dart';
import '../../../providers/theme.dart';

class SpecificAttendance extends StatefulWidget {
  dynamic data;
  SpecificAttendance(this.data, {Key? key}) : super(key: key);

  @override
  State<SpecificAttendance> createState() => _SpecificAttendanceState();
}

class _SpecificAttendanceState extends State<SpecificAttendance> {

  AttendanceController attendanceController=AttendanceController();
  var courseId=0;

  String? token;
  String? studentId;
  String? subjectId;

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token')!;
      studentId = prefs.getString('studentId');


    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }




  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    // final _width = MediaQuery.of(context).size.width;
    final theme = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance",
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
      body: FutureBuilder(

          future: attendanceController.getSpecificAttendanceData(
              token, studentId, widget.data.subjectId , context),
          builder: (context,AsyncSnapshot snapshot){
            if(!snapshot.hasData){
              return Center(
                  child: CircularProgressIndicator(
                    color: theme.isDark ? white : cardColor,
                  ));
            }
            else{

              return snapshot.data['attendance'] == null ? Column(

                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Center(child: Text("${widget.data.subjectName}",style: TextStyle(fontFamily: "Poppins-Medium",fontSize: 16.sp,color: theme.isDark ? white : black),)),
                  Divider(
                    thickness: 0.5,
                    color: theme.isDark ? white : black,
                  ),
SizedBox(height: _height * 0.4,),
                  Center(
                    child: Text(
                      "No data available",
                      style: TextStyle(
                          color: theme.isDark ? white : black,
                          fontFamily: "Poppins-Regular",
                          fontSize: 18.sp),
                    ),
                  ),
                ],
              ) :Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Center(child: Text("${widget.data.subjectName}",style: TextStyle(fontFamily: "Poppins-Medium",fontSize: 18.sp,color: theme.isDark ? white : black),)),
                    Divider(
                      thickness: 0.5,
                      color: theme.isDark ? white : black,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    PieChart(
                      dataMap: {
                        "Attended Classes":double.parse(snapshot.data!['attendance']['$courseId']['total_present']['records'] ),
                        "Missed Classes": double.parse(snapshot.data!['attendance']['$courseId']['total_absent']['records'] ),
                        "Online Classes":double.parse(snapshot.data!['attendance']['$courseId']['total_online']['records'] ),
                        "Leaves": double.parse(snapshot.data!['attendance']['$courseId']['total_leaves']['records'] )

                      },
                      chartValuesOptions: ChartValuesOptions(
                          showChartValuesInPercentage: true,
                          chartValueStyle: TextStyle(
                              fontSize: 14.sp,
                              color: theme.isDark? black: black,
                              fontFamily: "Poppins-Regular")),
                      chartRadius: MediaQuery.of(context).size.width / 9,
                      legendOptions: LegendOptions(
                        legendPosition: LegendPosition.left,
                        legendTextStyle: TextStyle(
                            fontSize: 14.sp,
                            color: theme.isDark? white: black,
                            fontFamily: "Poppins-Regular"),
                      ),
                      animationDuration: const Duration(milliseconds: 1200),
                      chartType: ChartType.ring,
                      colorList: [green, errorColor,purple, theme.isDark? white: black],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      "History ",
                      style: CustomTextStyle.titleSemiBold(context , theme.isDark? white: black),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!['attendance']['${widget.data.subjectId}']['history'].length,
                          itemBuilder: (context, int index) {
                            return Column(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    bottomRight: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0),
                                  ),
                                  child: Container(
                                    height: 70.h,
                                    width: double.infinity,
                                    // color: _colors[index % _colors.length],
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.isDark ==true ? cardColor : cardColorlight,
                                          blurRadius: 5.0,
                                          spreadRadius: 10.0,
                                        )
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Text("${ snapshot.data!['attendance']['$courseId']['history'][index]['timestamp_format']}",style: CustomTextStyle.bodyRegular(context , theme.isDark? white: black),),

                                              const Spacer(),
                                              Text("${ snapshot.data!['attendance']['${widget.data.subjectId}']['history'][index]['section_name']}",style: CustomTextStyle.bodyRegular(context , theme.isDark? white: black),),
                                              const Spacer(),

                                              Text("${ snapshot.data!['attendance']['${widget.data.subjectId}']['history'][index]['status_name']}",style: TextStyle(color: snapshot.data!['attendance']['${widget.data.subjectId}']['history'][index]['status_name'] == "present" ? Colors.green : (snapshot.data!['attendance']['${widget.data.subjectId}']['history'][index]['status_name'] == "absent") ? errorColor : theme.isDark? white: black ,fontFamily: "Poppins-Bold",fontSize: 12.sp,),)

                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                              ],
                            );
                          }),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
