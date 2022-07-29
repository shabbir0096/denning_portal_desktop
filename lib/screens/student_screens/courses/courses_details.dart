import 'package:denning_portal/controllers/subjects_conroller.dart';
import 'package:denning_portal/models/SubjectsModel.dart';
import 'package:denning_portal/screens/student_screens/attendance/specific_attendance.dart';
import 'package:denning_portal/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../custom_widgets/custom_textStyle.dart';
import '../../../custom_widgets/no_internet_screen.dart';
import '../../../providers/internet_checker.dart';
import '../../../providers/theme.dart';

class CourseDetails extends StatefulWidget {
  CourseDetails({Key? key}) : super(key: key);

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {


SubjectsController subjectsController=SubjectsController();
  String? token;
  String? studentId;
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
    final isOnline = Provider.of<ConnectivityService>(context).isOnline;
    final theme = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Courses",
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
      body: isOnline! ?FutureBuilder(
          future: subjectsController.subjectData(token, studentId , context),
          builder: (context, AsyncSnapshot<SubjectsModel> snapshot){
            if(!snapshot.hasData){
            return  Center(
                  child: CircularProgressIndicator(
                    color: theme.isDark ? white : cardColor,
                  ));
            }
            else{
              return snapshot.data!.subjects == null ? Center(
                child: Text(
                  "No data available",
                  style: TextStyle(
                      color: theme.isDark ? white : black,
                      fontFamily: "Poppins-Regular",
                      fontSize: 18.sp),
                ),
              ) : Padding(
                padding:EdgeInsets.only(left:10.w,right: 10.w),
                child: Column(

                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(

                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Course Name",
                          style: TextStyle(fontFamily: "Poppins-Bold",fontSize: 16.sp,color:theme.isDark ? white : black ),

                        ),

                        Spacer(),

                        Text(
                          "Attendance",
                          style: TextStyle(fontFamily: "Poppins-Bold",fontSize: 16.sp,color:theme.isDark ? white : black ),

                        ),
                      ],
                    ),
                    Divider(
                      thickness: 1,
                      color: theme.isDark ? white : black,
                    ),
                    SizedBox(height: 15.h,),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: snapshot.data!.subjects!.length,
                        itemBuilder: (context, int index) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  Text(
                                    "${snapshot.data!.subjects![index].subjectName}",
                                    maxLines: 2,
                                   // overflow: TextOverflow.ellipsis,
                                    //textDirection: TextDirection.rtl,
                                   // textAlign: TextAlign.justify,

                                    style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 14.sp,color:theme.isDark ? white : black ),


                                  ),
                                 Spacer(),
                                  GestureDetector(
                                    onTap:(){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> SpecificAttedance(snapshot.data!.subjects![index])));
                                    },
                                    child: Text(
                                      "Show",
                                      style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 14.sp,color:blue ),

                                    ),
                                  ),

                                ],
                              ),
                              Divider(
                                thickness: 0.5,
                                color: theme.isDark ? white : black,
                              ),
                              SizedBox(height: 10.h,)
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          }): NoInternetScreen() ,
    );
  }
}
