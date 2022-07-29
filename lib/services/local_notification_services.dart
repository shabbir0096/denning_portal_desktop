// import 'package:denning_portal/screens/student_screens/all_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class LocalNotificationService {
//   static final FlutterLocalNotificationsPlugin _localNotificationPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   static void intialize(BuildContext context) {
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: AndroidInitializationSettings("@mipmap/ic_launcher"));
//     _localNotificationPlugin.initialize(initializationSettings,
//         onSelectNotification: (String? route) async {
//       // its local notification route for foreground
//       if (route != null) {
//         print("pageRoute $route");
//         //Navigator.of(context).pushNamed(route);
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => AllNotifications(
//                 //route: route,
//                 ),
//           ),
//         );
//       }
//     });
//   }
//
// // show notification heads up in foreground screen
//   static void display(RemoteMessage message) async {
//     try {
//       final id = DateTime.now().microsecondsSinceEpoch ~/ 100000000;
//       print("id is ========$id");
//       final NotificationDetails notificationDetails = NotificationDetails(
//           android: AndroidNotificationDetails(
//             "denningApp"
//                 "denningApp channel",
//             "This channel is used for important notifications",
//             importance: Importance.high,
//             priority: Priority.high,
//           ),
//           iOS: IOSNotificationDetails(
//             presentAlert: true,
//             presentSound: true,
//           ));
//       await _localNotificationPlugin.show(id, message.notification!.title,
//           message.notification!.body, notificationDetails,
//           payload: message.data["route"]);
//     } on Exception catch (e) {
//       print(e);
//     }
//   }
// }
