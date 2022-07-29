

import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

 CustomDialogueWindows (context, var main_title , var title, var desc,var button_text, AlertType alertType) async {
   await FlutterPlatformAlert.showCustomAlert(
     windowTitle: title,
     text: desc,
     positiveButtonTitle: button_text,
     options: FlutterPlatformAlertOption(
         additionalWindowTitleOnWindows: main_title,
         showAsLinksOnWindows: false),
   );
}