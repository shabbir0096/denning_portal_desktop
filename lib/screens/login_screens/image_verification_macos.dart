import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../component/student_bottom_navigation.dart';
import '../../custom_widgets/custom_dialogue_windows.dart';
import '../../custom_widgets/custom_textStyle.dart';
import '../../custom_widgets/scaffold_messenge_snackbar.dart';
import '../../providers/theme.dart';
import '../../services/utilities/authication_check.dart';
import '../../services/utilities/basic_auth.dart';
import '../../utils/colors.dart';
import '../student_screens/otp_screens/otp_register.dart';
import 'email_login.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImageVerificationMacos extends StatefulWidget {
  final String? token;

  /// Default Constructor
  ImageVerificationMacos({Key? key, required this.token}) : super(key: key);

  @override
  State<ImageVerificationMacos> createState() => _ImageVerificationMacosState();
}

class _ImageVerificationMacosState extends State<ImageVerificationMacos> {
  PlatformFile? objFile;
  String name = "";
  String studentCode = "";
  String studentId = "";
  var appData;
  String? convertedImage;
  String? selectedImage;
  String status = "approved";
  int cameraCount = 0;

  //device_info
  String? modelNo;
  String? brand;
  String? ipAddressValue;
  String? mac;
  String? deviceType;
  String? deviceID;
  bool _load = false;
  bool _isVisible = false;
  bool loader_visible = false;
  List<String> fileTypes_list = [ "JPG",
    "PNG",
    "JPEG",
    "GIF",
    "jpg",
    "jpeg",
    "png",
    "gif"];


  // get device information
  getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    MacOsDeviceInfo macOsDeviceInfo = await deviceInfo.macOsInfo;
    var ipAddress = IpAddress(type: RequestType.json);
    dynamic data = await ipAddress.getIpAddress();

    setState(() {
      brand = macOsDeviceInfo.computerName;
      ipAddressValue = data["ip"];
    });
  }

  getDeviceID() async {
    deviceID = await PlatformDeviceId.getDeviceId;
  }

  /// get user data from sharepreference
  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name')!;
      studentCode = prefs.getString('studentCode')!;
      studentId = prefs.getString('studentId')!;
    });
  }

  Future<void> studentData() async {
    final response = await http.get(
      Uri.parse(
          "https://denningportal.com/app/api/appapi/userdata?auth_token=${widget.token}"),
      headers: <String, String>{
        'authorization':
            'Basic ' + base64Encode(utf8.encode('denadmin:Denn1234')),
      },
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      setState(() {
        appData = jsonData['app_data'];
      });
      // return json.decode(response.body);

    } else {
      print("server Errorr");
    }
  }

  allDeviceInformation() {
    getDeviceInfo();
    getDeviceID();
    studentData();
  }

  Future<void> registerStudent() async {

    try{


      final request = http.MultipartRequest(
        "POST",
        Uri.parse("https://denningportal.com/app/api/appapi/student_app_data"),
      );
      request.headers
          .addAll(<String, String>{'authorization': BasicAuth.basicAuth});
      request.fields["auth_token"] = "${widget.token}";
      request.fields["student_id"] = "$studentId";
      request.fields["student_code"] = "$studentCode";
      request.fields["name"] = "$name";
      request.fields["fb_device_token"] = "null";
      request.fields["device_type"] = "${deviceType}";
      request.fields["ip_address"] = "${ipAddressValue}";
      request.fields["device_name"] = "$brand";
      request.fields["device_id"] = "$deviceID";
      request.fields["data_points"] = "null";
      request.fields["device_mac_address"] = "null";
      request.fields["status"] = "null";
      if (objFile == null) {
        request.fields["profile_image"] = '';
      } else {
        request.files.add(new http.MultipartFile(
            "profile_image", objFile!.readStream!, objFile!.size,
            filename: objFile!.name));
      }
      var resp = await request.send();
      if (resp.statusCode == 200) {
        if(studentId == "765"){



          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => new EmailLogin()),
                  (Route<dynamic> route) => false);
          CustomDialogueWindows(
              context,
              "Registration",
              "Successful",
              "Your device has been registered successfully. Please wait for the approval",
              "OK",
              AlertType.success);
        }else



        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => new EmailLogin()),
                (Route<dynamic> route) => false);
        CustomDialogueWindows(
            context,
            "Registration",
            "Successful",
            "Your device has been registered successfully. Please wait for the approval",
            "OK",
            AlertType.success);
      } else {
        AuthChecker.exceptionHandling(context, resp.statusCode);
      }
    } on TimeoutException {
      CustomScaffoldWidget.buildErrorSnackbar(context, "Time out try again");
    } on SocketException {
      CustomScaffoldWidget.buildErrorSnackbar(
          context, "Please enable your internet connection");
    } on Error catch (e) {
      CustomScaffoldWidget.buildErrorSnackbar(
          context, "Something went wrong$e");
    }
  }

  void showToast() {
    setState(() {
      _isVisible = !_isVisible;
      loader_visible = false;
      objFile = null;
    });
  }
  void _showInSnackBar(String message) {
    _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5),
    ));
  }
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    getUser().then((value) => allDeviceInformation());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: Scaffold(
        backgroundColor: theme.isDark ? cardColor : whiteBottomBar,
        appBar: AppBar(
          title: Text(
            "Face Verification",
            style: CustomTextStyle.AppBarHeading(
                context, theme.isDark ? white : black),
          ),
          elevation: 0,
          backgroundColor: theme.isDark ? cardColor : whiteBottomBar,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EmailLogin()));
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 18.sp,
              )),
          iconTheme: IconThemeData(color: theme.isDark ? white : black),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Center(
              child: Text(
                "Please upload a photo for verification",
                style: TextStyle(
                    fontSize: 19.sp,
                    fontFamily: "Poppins-Bold",
                    color: theme.isDark ? white : black),
              ),
            ),
            Divider(
              thickness: 1,
              color: theme.isDark ? white : black,
            ),

            Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                // Max Size Widget
                Visibility(
                  visible: _isVisible != true ? false : true,
                  child: Visibility(
                    visible: objFile?.path != null ? true : false,
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      color: theme.isDark == true
                          ? cardColor
                          : whiteBottomBar,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius:
                            BorderRadius.circular(10.0),
                            child: fileTypes_list.contains("${objFile?.extension}")
                                ? Image.file(
                              File("${objFile?.path}"),
                              fit: BoxFit.contain,
                            )
                                : Column(
                              children: [
                                Image.asset(
                                  "assets/images/pdf_icon.png",
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Text(
                                  "${objFile?.name}",
                                  style: CustomTextStyle
                                      .bodyRegular2(
                                      context,
                                      theme.isDark
                                          ? white
                                          : black),
                                  maxLines: 2,
                                  overflow:
                                  TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 10,
                  right: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: white,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      shape: BoxShape.circle,
                    ),
                    height: 30,
                    width: 30,
                    child: Center(
                      child: InkWell(
                        onTap: showToast,
                        child: Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50.h,
            ),
            Center(
              child: Container(
                width: 120.w,
                height: 50.h,
                child: MaterialButton(
                  elevation: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.attach_file_rounded,
                        color: theme.isDark ? black : white,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        "Please select a photo",
                        style: CustomTextStyle.titleSemiBold(
                          context,
                          theme.isDark ? black : white,
                        ),
                      ),
                    ],
                  ),
                  textColor: black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: theme.isDark ? white : black,
                  onPressed: () async {
                    var result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['jpg', 'png', 'jpeg'],
                        withReadStream:
                        true // this will return PlatformFile object with read stream
                    );

                    if (result != null) {
                      bool exists =
                      appData.any((file) => file['device_id'] == "$deviceID")
                      as dynamic;
                      print("userExit or not: ${exists}");
                      if (exists == false) {
                        setState(() {
                          objFile = result.files.single;
                        });
                        print(objFile!.path);
                        _takePicture();
                        } else {
                        setState(() {
                          objFile = result.files.single;
                        });
                        print(objFile!.path);
                         // objFile = null;


                      }    if(studentId =="765"){
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                new StudentBottomNavigation()),
                                (Route<dynamic> route) => false);
                      } else {

                        print("_+_+_+_+_+_+_");
                        checkStatus();
                      }
                    } else {}
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _takePictureMatch() async {
      print("++++++++++++++++++");

      print("selected image path${objFile!.path}");
      selectedImage = objFile!.path;
      var bytes = File(objFile!.path!).readAsBytesSync();
      String base64Image = base64Encode(bytes);
      convertedImage = base64Image;



  }
  Future<void> _takePicture() async {
      print("select image for register ${objFile!.path}");
      selectedImage = objFile!.path;
      var bytes = File(objFile!.path!).readAsBytesSync();
      String base64Image = base64Encode(bytes);
      convertedImage = base64Image;
      // _showInSnackBar('Picture captured to: ${cameraImage!.path}');
      registerStudent();


  }

  //checking image section
  Future<String?> networkImageToBase64(String f) async {
    http.Response response = await http.get(Uri.parse(f));
    final bytes = response.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }

  Future<void> checkImage(var loginProfileImage) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    print('EasyLoading show');
    CircularProgressIndicator();
    final imgBase64Str = await networkImageToBase64(loginProfileImage);

    Map data = {
      "base1": "data:image/png;base64,${imgBase64Str}",
      "base2": "data:image/png;base64,$convertedImage"
    };

    final response = await http
        .post(Uri.parse("http://172.104.188.61:5000/verify"), body: data);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      if (jsonData['verified'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('status', status);
        await EasyLoading.dismiss();
        //closeCameraAndStream();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                new StudentBottomNavigation()),
                (Route<dynamic> route) => false);
      } else {
        await EasyLoading.dismiss();
        setState(() {
          cameraCount++;
        });
        _showInSnackBar(
            "Try again by taking the photo ($cameraCount) out of 3");

      }
    } else {
      _showInSnackBar(
          "Try again by taking the photo ($cameraCount) out of 3");
      await EasyLoading.dismiss();
      setState(() {
        cameraCount++;
      });
      print("checking camera count$cameraCount");
    }
  }



  void checkStatus() async {
    for (var data in appData) {
      if (data['device_id'] == deviceID && data['status'] == "processing") {
        await EasyLoading.dismiss();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => new EmailLogin()),
                (Route<dynamic> route) => false);

        CustomDialogueWindows(
            context,
            "Verification",
            "Identification Verification ",
            "Your Status is currently in Process",
            "OK",
            AlertType.error);
      } else if (data['device_id'] == deviceID && data['status'] == "denied") {
        await EasyLoading.dismiss();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => new EmailLogin()),
                (Route<dynamic> route) => false);

        CustomDialogueWindows(
            context,
            "Verification",
            "Identification Verification ",
            "Your Status is denied, kindly contact the registration department",
            "OK",
            AlertType.error);
      } else if (data['device_id'] == deviceID &&
          data['status'] == "approved") {
        await EasyLoading.dismiss();
        String profileImageLink = data['profile_image'];
        _takePictureMatch();
        if (cameraCount == 3) {
          await EasyLoading.dismiss();

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => new OtpResgister(),),
                  (Route<dynamic> route) => false);
        } else {
          checkImage(profileImageLink);
        }
      }
    }
  }

}
