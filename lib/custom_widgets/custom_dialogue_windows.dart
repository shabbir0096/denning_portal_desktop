
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

 CustomDialogueWindows (context, var mainTitle , var title, var desc,var buttonText, AlertType alertType) async {
   await FlutterPlatformAlert.showCustomAlert(
     windowTitle: title,
     text: desc,
     positiveButtonTitle: buttonText,
     options: FlutterPlatformAlertOption(
         additionalWindowTitleOnWindows: mainTitle,
         showAsLinksOnWindows: false),
   );
}