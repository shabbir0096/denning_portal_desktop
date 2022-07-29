import 'package:denning_portal/controllers/fee_controller.dart';
import 'package:denning_portal/models/FeeModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../custom_widgets/custom_textStyle.dart';
import '../../../custom_widgets/no_internet_screen.dart';
import '../../../providers/internet_checker.dart';
import '../../../utils/colors.dart';
import '../../../providers/theme.dart';

class FeesScreen extends StatefulWidget {
  const FeesScreen({Key? key}) : super(key: key);

  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {


  bool paid = true;
  bool unpaid = false;
  //bool selectHistory= false;
  FeeController feeController = FeeController();
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
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    final theme = Provider.of<ThemeChanger>(context);
    final isOnline = Provider.of<ConnectivityService>(context).isOnline;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Fee Details",
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
        body: isOnline! ? FutureBuilder(
            future: feeController.feeHistory(token, studentId ),
            builder: (context, AsyncSnapshot<FeeModel?> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                    child: CircularProgressIndicator(
                      color: theme.isDark ? white : cardColor,
                    ));
              }
              else if(!snapshot.hasData){
                return Center(
                  child: Text(
                    "No data available",
                    style: TextStyle(
                        color: theme.isDark ? white : black,
                        fontFamily: "Poppins-Regular",
                        fontSize: 18.sp),
                  ),
                );
              } else {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => Checkout()));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                              child: Container(
                                height: 160.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.isDark == true
                                          ? cardColor
                                          : cardColorlight,
                                      blurRadius: 5.0,
                                      spreadRadius: 10.0,
                                    )
                                  ],
                                ),
                                child: snapshot.data!.fees!.unpaid == null
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.check_circle_outline,color: green,size: 100.sp,),
                                            SizedBox(height: 10.h,),
                                            Center(
                                              child: Text(
                                              "Your Fee is all clear !",
                                              style: TextStyle(
                                                  color: theme.isDark ? white : black,
                                                  fontFamily: "Poppins-Regular",
                                                  fontSize: 14.sp),
                                      ),
                                            ),
                                          ],
                                        ))
                                    : Padding(
                                        padding: EdgeInsets.only(
                                            left: 20.w, right: 20.w),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Fee bill no",
                                                  style: CustomTextStyle
                                                      .bodyRegular(
                                                          context,
                                                          theme.isDark
                                                              ? white
                                                              : black),
                                                ),
                                                Spacer(),
                                                Text(
                                                  "${snapshot.data!.fees!.unpaid![0].paymentReceiptNo}",
                                                  style: CustomTextStyle
                                                      .bodyRegular(
                                                          context,
                                                          theme.isDark
                                                              ? white
                                                              : black),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Fees Due",
                                                  style: CustomTextStyle
                                                      .bodyRegular(
                                                          context,
                                                          theme.isDark
                                                              ? white
                                                              : black),
                                                ),
                                                Spacer(),
                                                Text(
                                                  "Rs. ${snapshot.data!.fees!.unpaid![0].amount} ",
                                                  style: CustomTextStyle
                                                      .bodyRegular(
                                                          context,
                                                          theme.isDark
                                                              ? white
                                                              : black),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Issue Date",
                                                  style: CustomTextStyle
                                                      .bodyRegular(
                                                          context,
                                                          theme.isDark
                                                              ? white
                                                              : black),
                                                ),
                                                Spacer(),
                                                Text(
                                                  "${DateFormat('dd MMM, yyyy').format(DateTime.parse(snapshot.data!.fees!.unpaid![0].issuanceDate!))}",
                                                  style: CustomTextStyle
                                                      .bodyRegular(
                                                          context,
                                                          theme.isDark
                                                              ? white
                                                              : black),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Due Date",
                                                  style: CustomTextStyle
                                                      .bodyRegular(
                                                          context,
                                                          theme.isDark
                                                              ? white
                                                              : black),
                                                ),
                                                Spacer(),
                                                Text(
                                                  "${DateFormat('dd MMM, yyyy').format(DateTime.parse(snapshot.data!.fees!.unpaid![0].paymentDeadline!))}",
                                                  style: CustomTextStyle
                                                      .bodyRegular(
                                                          context,
                                                          theme.isDark
                                                              ? white
                                                              : black),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Center(
                            child: Text(
                              "History ",
                              style: CustomTextStyle.headingSemiBold(
                                  context, theme.isDark ? white : black),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(_width * 0.01),
                                child: Container(
                                  width: 100.w,
                                  height: 45.h,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.isDark == true
                                            ? cardColor
                                            : cardColorlight,
                                        blurRadius: 5.0,
                                        spreadRadius: .0,
                                      )
                                    ],
                                  ),
                                  child: new MaterialButton(
                                    elevation: 0,
                                    child: new Text(
                                      'Paid',
                                      style: TextStyle(
                                        fontFamily: "Poppins-SemiBold",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15.sp,
                                        color: paid != true ? black : white,
                                      ),
                                    ),
                                    textColor: Colors.white,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                      side: BorderSide(
                                          color: paid != true
                                              ? white
                                              : Colors.green,
                                          width: 1),
                                    ),
                                    color: paid != true ? white : Colors.green,
                                    onPressed: () {
                                      setState(() {
                                        if (paid == true) {
                                          setState(() => paid = false);
                                        }
                                        paid = !paid;
                                        unpaid = false;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Padding(
                                padding: EdgeInsets.all(_width * 0.01),
                                child: Container(
                                  width: 100.w,
                                  height: 45.h,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.isDark == true
                                            ? cardColor
                                            : cardColorlight,
                                        blurRadius: 5.0,
                                        spreadRadius: 0.0,
                                      )
                                    ],
                                  ),
                                  child: new MaterialButton(
                                    elevation: 0,
                                    child: new Text(
                                      'Unpaid',
                                      style: TextStyle(
                                        fontFamily: "Poppins-SemiBold",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15.sp,
                                        color: unpaid != true ? black : white,
                                      ),
                                    ),
                                    textColor: Colors.white,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                      side: BorderSide(
                                          color: unpaid != true
                                              ? white
                                              : errorColor,
                                          width: 1),
                                    ),
                                    color: unpaid != true ? white : errorColor,
                                    onPressed: () {
                                      setState(() {
                                        if (unpaid == true) {
                                          setState(() => unpaid = false);
                                        }
                                        unpaid = !unpaid;
                                        paid = false;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          if (paid == true && unpaid == false) ...[
                            snapshot.data!.fees!.paid == null
                                ? Center(
                  child: Text(
                  "No data available",
                    style: TextStyle(
                        color: theme.isDark ? white : black,
                        fontFamily: "Poppins-Regular",
                        fontSize: 18.sp),
                  ),
                )
                                : Expanded(
                                    child: ListView.builder(
                                        itemCount:
                                            snapshot.data!.fees!.paid!.length,
                                        itemBuilder: (context, int index) {
                                          return Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8.0),
                                                  bottomRight:
                                                      Radius.circular(8.0),
                                                  bottomLeft:
                                                      Radius.circular(8.0),
                                                  topRight:
                                                      Radius.circular(8.0),
                                                ),
                                                child: Container(
                                                  height: 170.h,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: theme.isDark ==
                                                                true
                                                            ? cardColor
                                                            : cardColorlight,
                                                        blurRadius: 5.0,
                                                        spreadRadius: 10.0,
                                                      )
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 20.w,
                                                        right: 20.w),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Fee bill no : ",
                                                              style: CustomTextStyle
                                                                  .bodyRegular(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
                                                            Spacer(),
                                                            Text(
                                                              "${snapshot.data!.fees!.paid![index].paymentReceiptNo}",
                                                              style: CustomTextStyle
                                                                  .bodyRegular(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 6.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Amount : ",
                                                              style: CustomTextStyle
                                                                  .bodyRegular(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
                                                            Spacer(),
                                                            Text(
                                                              "Rs. ${snapshot.data!.fees!.paid![index].amount}",
                                                              style: CustomTextStyle
                                                                  .bodyRegular(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 6.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Payment Mode : ",
                                                              style: CustomTextStyle
                                                                  .bodyRegular(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
                                                            Spacer(),
                                                            Text(
                                                              "Cash",
                                                              style: CustomTextStyle
                                                                  .bodyRegular(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 6.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Issue Date : ",
                                                              style: CustomTextStyle
                                                                  .bodyRegular(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
                                                            Spacer(),
                                                            Text(
                                                              "${DateFormat('dd MMM, yyyy').format(DateTime.parse(snapshot.data!.fees!.paid![index].issuanceDate!))}",
                                                              style: CustomTextStyle
                                                                  .bodyRegular(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 6.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Payment Date : ",
                                                              style: CustomTextStyle
                                                                  .bodyRegular(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
                                                            Spacer(),
                                                            Text(
                                                              "${DateFormat('dd MMM, yyyy').format(DateTime.parse(snapshot.data!.fees!.paid![index].paymentDate!))}",
                                                              style: CustomTextStyle
                                                                  .bodyRegular(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
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
                          ] else if (unpaid == true && paid == false) ...[
                            snapshot.data!.fees!.unpaid == null
                                ? Center(
                              child: Text(
                                "No data available",
                                style: TextStyle(
                                    color: theme.isDark ? white : black,
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 18.sp),
                              ),
                            )
                                : Expanded(
                                    child: ListView.builder(
                                        itemCount:
                                            snapshot.data!.fees!.unpaid!.length,
                                        itemBuilder: (context, int index) {
                                          return Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8.0),
                                                  bottomRight:
                                                      Radius.circular(8.0),
                                                  bottomLeft:
                                                      Radius.circular(8.0),
                                                  topRight:
                                                      Radius.circular(8.0),
                                                ),
                                                child: Container(
                                                  height: 170.h,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: theme.isDark ==
                                                                true
                                                            ? cardColor
                                                            : cardColorlight,
                                                        blurRadius: 5.0,
                                                        spreadRadius: 10.0,
                                                      )
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 20.w,
                                                        right: 20.w),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Fee bill no : ",
                                                              style: CustomTextStyle
                                                                  .bodyRegular(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
                                                            Spacer(),
                                                            Text(
                                                              "${snapshot.data!.fees!.unpaid![index].paymentReceiptNo}",
                                                              style: CustomTextStyle
                                                                  .bodyRegular(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 6.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Amount : ",
                                                              style: CustomTextStyle
                                                                  .bodyRegular(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
                                                            Spacer(),
                                                            Text(
                                                              "Rs. ${snapshot.data!.fees!.unpaid![index].amount}",
                                                              style: CustomTextStyle
                                                                  .bodyRegular(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 6.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Payment Mode : ",
                                                              style: CustomTextStyle
                                                                  .bodyRegular(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
                                                            Spacer(),
                                                            Text(
                                                              "Cash",
                                                              style: CustomTextStyle
                                                                  .bodyRegular(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 6.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Issue Date : ",
                                                              style: CustomTextStyle
                                                                  .bodyRegular(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
                                                            Spacer(),
                                                            Text(
                                                              "${DateFormat('dd MMM, yyyy').format(DateTime.parse(snapshot.data!.fees!.unpaid![index].issuanceDate!))}",
                                                              style: CustomTextStyle
                                                                  .bodyRegular(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 6.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Payment Date : ",
                                                              style: CustomTextStyle
                                                                  .bodyRegular(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
                                                            Spacer(),
                                                            Text(
                                                              "${DateFormat('dd MMM, yyyy').format(DateTime.parse(snapshot.data!.fees!.unpaid![index].paymentDeadline!))}",
                                                              style: CustomTextStyle
                                                                  .bodyRegular(
                                                                      context,
                                                                      theme.isDark
                                                                          ? white
                                                                          : black),
                                                            ),
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
                                  ),
                          ]
                        ],
                      ),
                    ),
                  ),
                );
              }
            }): NoInternetScreen());
  }
}
