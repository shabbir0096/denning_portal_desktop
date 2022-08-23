
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../component/webview_display_desktop.dart';
import '../../../custom_widgets/custom_textStyle.dart';
import '../../../utils/colors.dart';
import '../../../providers/theme.dart';

class InquiryDetail extends StatefulWidget {
  var data;
  InquiryDetail(this.data);

  @override
  State<InquiryDetail> createState() => _InquiryDetailState();
}

class _InquiryDetailState extends State<InquiryDetail> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    final theme = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Inquiry Details",
          style: CustomTextStyle.AppBarHeading(context , theme.isDark? white: black),),
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
      body: Padding(
        padding: EdgeInsets.only(left: 15.w, right: 15.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Row(

                children: [
                  Text(
                    "TO : ",
                    style: CustomTextStyle.bodySemiBold(context , theme.isDark? white: black),
                  ),

                  Text(
                    " ${widget.data['reciever_data']['reciever_name']}",
                    style:CustomTextStyle.bodyRegular(context , theme.isDark? white: black),
                  ),
                ],
              ),
              SizedBox(height: 10.h,),
              Row(

                children: [
                  Text(
                    "DEPARTMENT : ",
                    style: CustomTextStyle.bodySemiBold(context , theme.isDark? white: black),
                  ),

                  Text(
                    " ${widget.data['reciever_data']['type']}",
                    style: CustomTextStyle.bodyRegular(context , theme.isDark? white: black),
                  ),
                ],
              ),
              SizedBox(height: 10.h,),
              Row(

                children: [
                  Text(
                    "PRIORITY : ",
                    style: CustomTextStyle.bodySemiBold(context , theme.isDark? white: black),
                  ),

                  Text(
                    " ${widget.data['priority']}",
                    style: CustomTextStyle.bodyRegular(context , theme.isDark? white: black),
                  ),
                ],
              ),
              SizedBox(height: 10.h,),
              Row(

                children: [
                  Text(
                    "SUBJECT : ",
                    style: CustomTextStyle.bodySemiBold(context , theme.isDark? white: black),
                  ),

                  Text(
                    " ${widget.data['subject']}",
                    style: CustomTextStyle.bodyRegular(context , theme.isDark? white: black),
                  ),
                ],
              ),
              SizedBox(height: 10.h,),

              Row(

                children: [
                  Text(
                    "DOCUMENT : ",
                    style: CustomTextStyle.bodySemiBold(context , theme.isDark? white: black),
                  ),
                  widget.data['history'][0]['attached_file_name'] == null ?  Text(
                    " No Attachment",
                    style: TextStyle(color: errorColor,fontFamily: "Poppins-Regular",fontSize: 14.sp, decoration: TextDecoration.underline),

                  ) :
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebviewDsiplayDesktop('${widget.data['history'][0]['attached_file_name']}')));
                    },
                    child: Text(
                      "Preview",
                     style: TextStyle(color: blue,fontFamily: "Poppins-Regular",fontSize: 14.sp, decoration: TextDecoration.underline),

                    ),
                  ),
                  // Text(
                  //   "${widget.data['history'][0]['attached_file_name']}",
                  //   style:CustomTextStyle.bodyRegular(context , theme.isDark? white: black),
                  // ),
                ],
              ),
              SizedBox(height: 10.h,),
              Row(

                children: [
                  Text(
                    "INQUIRY : ",
                    style: CustomTextStyle.bodySemiBold(context , theme.isDark? white: black),
                  ),


                ],
              ),
              SizedBox(height: 5,),
              Text(
                "${widget.data['history'][0]['message']}",
                style:CustomTextStyle.bodyRegular(context , theme.isDark? white: black),
              ),

              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
