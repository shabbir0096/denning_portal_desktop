
import 'dart:convert';

class BasicAuth{

  static const String username = 'denadmin';
  static const String passwordd = 'Denn1234';
  static  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$passwordd'));


}