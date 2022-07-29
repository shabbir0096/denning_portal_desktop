
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:denning_portal/screens/student_screens/events/registration_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../custom_widgets/custom_textStyle.dart';
import '../../../utils/colors.dart';
import '../../../providers/theme.dart';
import 'event_screen.dart';

class EventDetails extends StatefulWidget {
  dynamic data;
  EventDetails(this.data);

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  bool pressAttention = false;
  bool buttonClicked = false;
  final f = new DateFormat.yMMMMEEEEd();
  String studentName = "";
  String studentEmail = "";
  String studentDRN = "";
  String studentPhone = "";
  var registration_key;
  List<String> userDetailsList = <String>[];
  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      studentName = prefs.getString('name')!;
      studentEmail = prefs.getString('email')!;
      studentDRN = prefs.getString('studentCode')!;
      studentPhone = prefs.getString('phone')!;

      userDetailsList.add(studentName);
      userDetailsList.add(studentEmail);
      userDetailsList.add(studentDRN);
      userDetailsList.add(studentPhone);
      userDetailsList.add("${widget.data['registration_link']}");
      print("user list data ${widget.data["registration_link"]}");

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();

  }
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState

    if ("${widget.data['registration_link']}" != null && "${widget.data['registration_link']}" != 0) {
      registration_key = "${widget.data['registration_link']}"; // You can safely access the element here.
    }

    super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    DateTime? currentDate = DateTime.tryParse(widget.data['notice_date']);

    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    final theme = Provider.of<ThemeChanger>(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: _height * 0.7,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(0.0),
                      bottomLeft: Radius.circular(0.0),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: widget.data['image'] == null
                          ? const AssetImage(
                          "assets/images/default_event_image.jpg")
                      as ImageProvider
                          : NetworkImage("${widget.data['image']}"),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: _width * 0.05,
                        bottom: _width * 0.11,
                        top: _width * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.of(context).pop();
                        //   },
                        //   child: Icon(
                        //     Icons.arrow_back_ios,
                        //     color: theme.isDark ? white : black,
                        //   ),
                        // ),
                    SizedBox.fromSize(
                    size: Size(45, 45), // button width and height
                      child: GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 250.0,
                          width: 250.0,
                          child: Center(child: Icon(Icons.arrow_back ,color: black,),),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      )
                  ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: _height * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: _width * 0.05, right: _width * 0.05),
                  child: Column(
                    children: [
                      Text(
                        "${widget.data['notice_title']}",
                        style: CustomTextStyle.headingBold(
                            context, theme.isDark ? white : black),
                        textAlign: TextAlign.center,
                      ),
                      Divider(
                        color: theme.isDark ? white : black,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.calendarCheck,
                            color: theme.isDark ? white : black,
                            size: 20.sp,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          DefaultTextStyle(
                            style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                fontSize: 19.sp,
                                color: theme.isDark ? white : black),
                            child: AnimatedTextKit(
                              repeatForever: true,
                              animatedTexts: [
                                WavyAnimatedText(DateFormat('MMMM  dd').format(
                                    DateTime.parse(
                                        widget.data['notice_date']))),
                              ],
                              onTap: () {
                                print("Tap Event");
                              },
                            ),
                          ),
                          // Text(
                          //   "December 25",
                          //   style: TextStyle(
                          //       fontFamily: "Montserrat-Regular",
                          //       fontSize: _width * 0.04,
                          //       color: black),
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 20.sp,
                            color: theme.isDark ? white : black,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Container(
                            width: _width * 0.45,
                            child: Text(
                              "${widget.data['venue']}",
                              style: CustomTextStyle.bodyRegular(
                                  context, theme.isDark ? white : black),
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.alarm,
                            size: 18.sp,
                            color: theme.isDark ? white : black,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Container(
                            width: _width * 0.45,
                            child: Text(
                              "${widget.data['duration']}",
                              style: CustomTextStyle.bodyRegular(
                                  context, theme.isDark ? white : black),
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: _height * 0.03,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: _width * 0.05,
                    right: _width * 0.05,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "About",
                        style: CustomTextStyle.headingSemiBold(
                            context, theme.isDark ? white : black),
                      ),
                      Divider(
                        color: theme.isDark ? white : black,
                      ),
                      Text(
                        "${widget.data['notice']}",
                        style: CustomTextStyle.bodyRegular(
                            context, theme.isDark ? white : black),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                if(registration_key !='null' && registration_key != "")
                  Padding(
                    padding: EdgeInsets.only(
                      left: _width * 0.05,
                      right: _width * 0.05,
                    ),
                    child: Container(
                        width: double.infinity,
                        height: _height * 0.1,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(_width * 0.0),
                            child: Container(
                              width: double.infinity,
                              height: 50.h,
                              child: new MaterialButton(
                                elevation: 0,
                                child: new Text(
                                  'Register now',
                                  style: TextStyle(
                                      color: theme.isDark ? white : white,
                                      fontSize: 15.sp,
                                      fontFamily: "Poppins-Regular"),
                                ),
                                color: theme.isDark ? blue : blue,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                                onPressed: () {

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RegistratioFormEvents(userDetailsList: userDetailsList)));
                                },
                              ),
                            ),
                          ),
                        )),
                  ),
                Padding(
                  padding: EdgeInsets.only(
                    left: _width * 0.05,
                    right: _width * 0.05,
                  ),
                  child: Container(
                      width: double.infinity,
                      height: _height * 0.1,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(_width * 0.0),
                          child: Container(
                            width: double.infinity,
                            height: 50.h,
                            child: new MaterialButton(
                              elevation: 0,
                              child: new Text(
                                'All Events',
                                style: TextStyle(
                                    color: theme.isDark ? black : white,
                                    fontSize: 15.sp,
                                    fontFamily: "Poppins-Regular"),
                              ),
                              color: theme.isDark ? white : black,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventsScreen()));
                              },
                            ),
                          ),
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: _height * 0.05,
            )
          ],
        ),
      ),
    );
  }
}