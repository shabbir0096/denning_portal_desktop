// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../../../custom_widgets/custom_textStyle.dart';
// import '../../../models/inquiryChatModel.dart';
// import '../../../utils/colors.dart';
// import '../../../utils/config.dart';
// import '../../../utils/theme.dart';
// class Conversation extends StatelessWidget {
//   final List<ChatEntry> entries;
//
//   const Conversation({Key? key,  required this.entries}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController message = TextEditingController();
//     var size,height,width;
//     size = MediaQuery.of(context).size;
//     height = size.height;
//     width = size.width;
//     final theme = Provider.of<ThemeChanger>(context);
//     return Scaffold(
//
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         title: Text("Sir Rajesh",
//           style: CustomTextStyle.AppBarHeading(context , theme.isDark? white: black),),
//         elevation: 0,
//         backgroundColor: theme.isDark? cardColor: whiteBottomBar,
//         centerTitle: true,
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(
//               Icons.arrow_back_ios,
//               size: 18.sp,
//             )),
//         iconTheme: IconThemeData(color: theme.isDark? white: black),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: height/1.26,
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: entries
//                       .map(
//                         (entry) => Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Bubble(
//                         entry: entry,
//                         key: null,
//                       ),
//                     ),
//                   )
//                       .toList(),
//                 ),
//               ),
//
//             ),
//             Align(
//               alignment: Alignment.bottomLeft,
//               child: Container(
//                 padding: EdgeInsets.only(left: 10 , top: 10 , bottom: 5,right: 10),
//                 height: 60.h,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: theme.isDark ==true ? cardColor : whiteBottomBar,
//                       blurRadius: 0.0,
//                       spreadRadius: 0.0,
//                     )
//                   ],
//                 ),
//
//                 child: Row(
//
//                   children: <Widget>[
//                     FloatingActionButton(
//                       heroTag: null,
//                       onPressed: (){
//
//                       },
//                       child: Icon(Icons.add,color: Colors.white,size: 18,),
//                       backgroundColor: purple,
//                       elevation: 0,
//                     ),
//                     SizedBox(width: 10.h,),
//                     Expanded(
//                       child: TextField(
//                         controller: message,
//                         style: CustomTextStyle.bodyRegular(context , theme.isDark? white: black),
//                         decoration: InputDecoration(
//                           contentPadding:   EdgeInsets.only(left: 10.w , top: 2.h , bottom: 5.h,right: 10.w),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: theme.isDark? white: black, width: 1.0),
//                             borderRadius: BorderRadius.circular(20.0),
//                           ),
//                           enabledBorder: new OutlineInputBorder(
//                             borderRadius: new BorderRadius.circular(20.0),
//                             borderSide: new BorderSide(color: theme.isDark? white: black),
//                           ),
//                           hintText: "Write message...",
//                           hintStyle: CustomTextStyle.bodyRegular(context , theme.isDark? white: black),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10.h,),
//                     FloatingActionButton(
//                       onPressed: (){
//
//                       },
//                       child: Icon(Icons.send,color: Colors.white,size: 18,),
//                       backgroundColor: purple,
//                       elevation: 0,
//                     ),
//                   ],
//
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class Bubble extends StatelessWidget {
//   final ChatEntry entry;
//
//   Bubble({Key? key, required this.entry}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController message = TextEditingController();
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Align(
//             alignment: entry.sent ? Alignment.centerRight : Alignment.centerLeft,
//             child: Container(
//               padding: kBubblePadding,
//               decoration: BoxDecoration(
//                 color: (entry.sent ? lightPurple : black)
//                     .withOpacity(entry.read ? kReadOpacity : 1),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(kBorderRadius),
//                   topRight: Radius.circular(kBorderRadius),
//                   bottomRight: Radius.circular(entry.sent ? 0.0 : kBorderRadius),
//                   bottomLeft: Radius.circular(entry.sent ? kBorderRadius : 0.0),
//                 ),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment:
//                 entry.sent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(entry.text, style: kBubbleTextStyle , ),
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Text(
//                         DateFormat('MMMd – kk:mm').format(entry.date),
//                         style: TextStyle(fontSize: kBubbleMetaFontSize , color: white),
//                       ),
//                       if (entry.read) ...[
//                         const SizedBox(width: 5),
//                         Icon(Icons.done, size: kBubbleMetaFontSize , color: Colors.white,)
//                       ]
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }