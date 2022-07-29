// import 'package:denning_portal/screens/student_screens/all_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
//
// import '../local_notification_services.dart';
//
// class NotificationMain {
//   Future<void> getNotification(BuildContext context) async{
//     LocalNotificationService.intialize(context);
//     // give you  the message on which user taps
//     // and it opened the app from terminated state
//     FirebaseMessaging.instance.getInitialMessage().then((message) {
//       if(message != null){
//         final routeMessage = message.data["route"];
//         print(routeMessage);
//         //Navigator.of(context).pushNamed(routeMessage);
//         if (message.data['route'] != null) {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => AllNotifications(
//                 //  id: message.data['_id'],
//                 ),
//               ),
//             );
//           }
//       }
//     });
//
//
//     // foreground work
//     FirebaseMessaging.onMessage.listen((message) {
//       if(message.notification !=null){
//         print("+++++++++++++++${message.notification!.body}");
//         print(message.notification!.title);
//
//
//       }
//       LocalNotificationService.display(message);
//     });
//
//     //when the app is in background but opened and user taps
//     // on the notification
//
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       final routeMessage = message.data["route"];
//       print(routeMessage);
//       Navigator.of(context).pushNamed(routeMessage);
//     });
//   }
// }