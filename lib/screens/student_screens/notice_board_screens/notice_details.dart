import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../custom_widgets/custom_textStyle.dart';
import '../../../utils/colors.dart';
import '../../../providers/theme.dart';

class NoticeDescription extends StatefulWidget {
  dynamic data;
  NoticeDescription(this.data);

  @override
  State<NoticeDescription> createState() => _NoticeDescriptionState();
}

class _NoticeDescriptionState extends State<NoticeDescription> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    final theme = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notice Details",
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Title : ",
                    style: CustomTextStyle.bodySemiBold(context , theme.isDark? white : black),

                  ),
                  Container(
                    width: 270.w,
                    child: Text(
                      " ${widget.data['notice_title']}",
                      style: CustomTextStyle.titleSemiBold(context , theme.isDark? white : purple),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Text(
                    "Date : ",
                    style: CustomTextStyle.bodySemiBold(context , theme.isDark? white : black),

                  ),
                  if(widget.data['notice_date'] != null)
                  Text(
                    "${widget.data['notice_date']}",
                    style: CustomTextStyle.bodyRegular(context , theme.isDark? white : black),

                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Text(
                    "Time : ",
                    style: CustomTextStyle.bodySemiBold(context , theme.isDark? white : black),

                  ),
                  if(widget.data['notice_time'] != null)
                  Text(
                    " ${widget.data['notice_time']}",
                    style: CustomTextStyle.bodyRegular(context , theme.isDark? white : black),

                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                "Description : ",
                style: CustomTextStyle.titleSemiBold(context , theme.isDark? white : black),

              ),
              Text(
                "${widget.data['notice']}",
                style: CustomTextStyle.bodyRegular2(context , theme.isDark? white : black),

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
