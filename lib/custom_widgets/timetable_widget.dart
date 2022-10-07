// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../models/time_table.dart';
// import '../utils/colors.dart';
//
// class TimeTableItem extends StatelessWidget {
//   final DayTimeTable dayTimeTable;
//
//   const TimeTableItem({Key? key, required this.dayTimeTable}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//           left: 10.w, right: 10.w),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             dayTimeTable.timeOfDay,
//             style: TextStyle(color: white, fontSize: 12.0.sp),
//           ),
//           SizedBox(width: 10.w,),
//           Column(
//             children: [
//               Container(
//                 width: 15,
//                 height: 15,
//                 child: Padding(
//                   padding: EdgeInsets.only(
//                       left: 20.w, right: 20.w),
//                 ),
//                 decoration: BoxDecoration(
//                     shape: BoxShape.circle, color: Color(0xFFFFFFFF)),
//               ),
//               SizedBox(height: 5.0.h),
//               Container(
//                 height: 50.h,
//                 child: VerticalDivider(
//                   color: white,
//                   thickness: 2,
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding:  EdgeInsets.only(
//                 left: 10.w, right: 5.w),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                   dayTimeTable.subjectName,
//                   style: TextStyle(color: white, fontSize: 12.0.sp),
//                 ),
//                 SizedBox(height: 10.h,),
//                 Text(
//                   dayTimeTable.teacherName,
//                   style: TextStyle(color: white, fontSize: 12.0.sp),
//                 ),
//                 SizedBox(height: 10.h,),
//                 Text(
//                   "Zoom link: ${dayTimeTable.zoomLink}",
//                   style: TextStyle(color: purple, fontSize: 12.0.sp),
//                 ),
//               ],
//             ),
//           ),
//         ],
//
//
//       ),
//     );
//   }
// }
