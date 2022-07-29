
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/utilities/basic_auth.dart';

class DashboardController {
  Future dashboardData(String? token, String? studentId) async {
    var convertedData;
    Map data = {"auth_token": "${token}", "student_id": "${studentId}"};
    final response = await http.post(
      Uri.parse("https://denningportal.com/app/api/appapi/dashboard_data"),
      headers: <String, String>{'authorization': BasicAuth.basicAuth},
      body: data,
    );

    if (response.statusCode == 200) {
      convertedData = json.decode(response.body);
      print(convertedData);
      return convertedData;
    } else {
      print("Errorr araha hai");
    }
  }
}
