import 'package:denning_portal/models/FeeModel.dart';

import 'package:denning_portal/services/utilities/app_url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/utilities/basic_auth.dart';

class FeeController {
  Future<FeeModel?> feeHistory(String? token, String? studentId) async {
    final response = await http.get(
      Uri.parse(
          "${AppUrl.baseUrl}fees_data?auth_token=${token}&student_id=${studentId}"),
      headers: <String, String>{'authorization': BasicAuth.basicAuth},
    );

    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      if(data["status"] == 200) {
        return FeeModel.fromJson(data);
      }else{

      }
    } else {
      return FeeModel.fromJson(data);
    }
  }
}
