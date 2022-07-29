/*
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denning_portal/component/student_bottom_navigation.dart';
import 'package:denning_portal/screens/student_screens/email_login.dart';
import 'package:denning_portal/screens/student_screens/otp_screens/otp_register.dart';

import 'package:device_info_plus/device_info_plus.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:macadress_gen/macadress_gen.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' as Io;

import '../../utils/colors.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ImageVerification extends StatefulWidget {
  String? token;
  String deviceTokenToSendPushNotification = "";

  ImageVerification(this.token);

  @override
  State<ImageVerification> createState() => _ImageVerificationState();
}

class _ImageVerificationState extends State<ImageVerification> {
  String? convertedImage;
  int count = 0;
  String waiting = "";
  bool showSpinner = false;
  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  XFile? image; //for caputred image
  File? selectedImage;
  String? name = "";
  String? studentCode = "";
  String? studentId = "";
  String? firebaseImageURL;
  var deviceName = "";
  var appData;
  var loginProfileImage;
  var deviceTokenToSendPushNotification;
  var a;
  int cameraCount = 0;
  String status="approved";
  bool _isLoading= false;

  //device_info
  String? modelNo;
  String? brand;
  String? ipAddressValue;
  String? mac;
  String? deviceType;
  String? deviceID;
  String? uuid;

  getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    var ipAddress = IpAddress(type: RequestType.json);
    dynamic data = await ipAddress.getIpAddress();

    setState(() {
      modelNo = androidInfo.model;
      brand = androidInfo.brand;
      deviceID = androidInfo.androidId;
      ipAddressValue = data["ip"];
    });
  }
  void _getInfo() async {
    // Get device id
    String? result = await PlatformDeviceId.getDeviceId;

    // Update the UI
    setState(() {
      uuid = result;
      print("uuid is :$uuid");
    });
  }

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name')!;
      studentCode = prefs.getString('studentCode')!;
      // token = prefs.getString('token')!;
      studentId = prefs.getString('studentId')!;

      print(name);
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

  // get FCM push notification Token
  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    deviceTokenToSendPushNotification = token.toString();
    // print("Token========$deviceTokenToSendPushNotification");
  }

  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras![1], ResolutionPreset.low);
      //cameras[0] = first camera, change to 1 to another camera

      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      // print("NO any camera found");
    }
  }

  @override
  void initState() {
    getDeviceInfo();
    macAndDevicetype();
    getUser();
    studentData();
    loadCamera();
    getDeviceTokenToSendNotification();

    super.initState();
  }


  uploadBlog() async {
    Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child("studentImages")
        .child("${randomAlphaNumeric(9)}.jpg");
    final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
    var downloadUrl = await (await task).ref.getDownloadURL();
    // print("this is URL : ${downloadUrl}");
    Map<String, String> blogMap = {
      "imgURL": downloadUrl,
      "studentname": name!,
      "studentcode": studentCode!,
      "studentid": studentId!,
      "deviceId": deviceID!
    };
    addData(blogMap).then((value) => registerStudent(downloadUrl));
  }

  Future<void> addData(blogData) async {
    FirebaseFirestore.instance
        .collection("students")
        .add(blogData)
        .catchError((e) => print(e));
  }

  Future<void> registerStudent(String downloadUrl) async {
    Map data = {
      "auth_token": "${widget.token}",
      "student_id": "${studentId}",
      "student_code": "${studentCode}",
      "name": "${name}",
      "profile_image": "${downloadUrl}",
      "data_points": "null",
      "device_id": "${deviceID}",
      "device_name": "${brand}",
      "ip_address": "${ipAddressValue}",
      "device_type": "${deviceType}",
      "fb_device_token": "${deviceTokenToSendPushNotification}",
      "device_mac_address": "${mac}",
      "status": "denied"
    };
    final response = await http.post(
      Uri.parse(
          "https://denningportal.com/app/api/appapi/student_app_data"),
      headers: <String, String>{
        'authorization':
            'Basic ' + base64Encode(utf8.encode('denadmin:Denn1234'))
      },
      body: data,
    );

    if (response.statusCode == 200) {

      closeCameraAndStream();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => new EmailLogin()),
          (Route<dynamic> route) => false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "${"New user Register"}",
          style: TextStyle(
              fontSize: 14.sp, color: black, fontFamily: "Poppins-Regular"),
        ),
        backgroundColor: white,
      ));

      return json.decode(response.body);
    } else {
      print("Errorr");
    }
  }

  checkingLogic() {

    if (a.contains("login")) {


      loginProfileImage = appData[0]['profile_image'];



      checkImage(loginProfileImage);
    } else if (a.contains("denied")) {


      closeCameraAndStream();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => new EmailLogin()),
              (Route<dynamic> route) => false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Your Status is Denied",
          style: TextStyle(
              fontSize: 14.sp, color: white, fontFamily: "Poppins-Regular"),
        ),
        backgroundColor: errorColor,
      ));
    } else if (a.contains("processing")) {


      closeCameraAndStream();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => new EmailLogin()),
              (Route<dynamic> route) => false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Your Status is in Process",
          style: TextStyle(
              fontSize: 14.sp, color: white, fontFamily: "Poppins-Regular"),
        ),
        backgroundColor: errorColor,
      ));
    }

  }

  //checking image section
  Future<String?> networkImageToBase64(String f) async {
    http.Response response = await http.get(Uri.parse(f));
    final bytes = response.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }

  Future<void> checkImage(var loginProfileImagee) async {

    final imgBase64Str = await networkImageToBase64(loginProfileImagee);


    Map data = {
      "base1": "data:image/png;base64,${imgBase64Str}",
      "base2": "data:image/png;base64,${convertedImage}"
    };
    final response = await http.post(
      Uri.parse("http://172.104.188.61:5000/verify"),
      body: data
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);



      if (jsonData['verified'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('status', status);
        closeCameraAndStream();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    new StudentBottomNavigation()),
            (Route<dynamic> route) => false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Login Successful",
            style: TextStyle(
                fontSize: 14.sp, color: white, fontFamily: "Poppins-Regular"),
          ),
          backgroundColor: purple,
        ));
      } else {

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Take a photo again try(${cameraCount}) out of 3",
            style: TextStyle(
                fontSize: 14.sp, color: white, fontFamily: "Poppins-Regular"),
          ),
          backgroundColor: errorColor,
        ));
        if (cameraCount > 2) {
          closeCameraAndStream();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => new OtpResgister()),
              (Route<dynamic> route) => false);
        }
      }
    } else {
      var jsonData = json.decode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Take a photo again try(${cameraCount}) out of 3",
          style: TextStyle(
              fontSize: 14.sp, color: white, fontFamily: "Poppins-Regular"),
        ),
        backgroundColor: errorColor,
      ));
      if (cameraCount > 2) {
        closeCameraAndStream();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => new OtpResgister()),
            (Route<dynamic> route) => false);
      }
    }
  }

  //logics



  // @override
  // void dispose() {
  //   //controller!.stopImageStream();
  //   controller?.dispose();
  //
  //
  //   super.dispose();
  // }
  void closeCameraAndStream() async {
    if (controller!.value.isStreamingImages) {
      await controller!.stopImageStream();
    }
    await controller!.dispose();

    setState(() {
      controller = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;

    // print("path : $convertedImage");
    // print("Firebase URL : ${firebaseImageURL}");
    // print("App data: $appData");
    // print("Device type: $deviceType");
    // print("mac address: $mac");
    // // print("Device name: ${deviceInfo.deviceName}");

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  controller == null
                      ? Center(child: Text("Loading Camera..."))
                      : !controller!.value.isInitialized
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(
                              height: 500.h,
                              width: double.infinity,
                              child: CameraPreview(controller!),
                            ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Center(
                    child: IconButton(
                      onPressed: () async {
                        try {
                          if (controller != null) {
                            //check if contrller is not null
                            if (controller!.value.isInitialized) {
                              //check if controller is initialized
                              image =
                                  await controller!.takePicture(); //capture image
                              setState(() {
                                //update UI

                                cameraCount++;
                                if (image != null) {
                                  selectedImage = File(image!.path);
                                  var bytes = File(image!.path).readAsBytesSync();
                                  String base64Image = base64Encode(bytes);
                                  convertedImage = base64Image;
                                } else {
                                  print('No image selected.');
                                }
                              });
                            }
                          }
                        } catch (e) {
                          print(e); //show error
                        }
                        bool exists = appData.any((file) => file['device_id'] == "$deviceID") as dynamic;
                        if (appData.isEmpty) {
                          uploadBlog();
                        }
                       else{
                          for (var i in appData) {

                            if (i['device_id']!.contains(deviceID) &&
                                i['status']!.contains("approved")) {

                                a = "login";


                              print("Checking app data logic   login: ${a}");
                              checkingLogic();
                              print("Maslaa yahan ----------------------");
                            } else if (i['device_id']!.contains(deviceID) &&
                                i['status']!.contains("denied")) {

                                a = "denied";

                              checkingLogic();
                              print("Checking app data logic  denied: ${a}");
                            } else if (i['device_id']!.contains(deviceID) &&
                                i['status']!.contains("processing")) {

                                a = "processing";

                              checkingLogic();
                              print("Checking app data logic  processing: ${a}");
                            } else if(exists == false){

                              print("ye ajeeb chal raha hai");
                              uploadBlog();
                            }


                          }
                        }

                      },
                      icon: Icon(
                        Icons.camera_alt_rounded,
                        size: 40.sp,
                      ),
                    ),
                  ),
                  Spacer(),
                  showSpinner == true
                      ? Center(
                          child: Container(
                          height: 40.h,
                          width: 40.w,
                          child: CircularProgressIndicator(
                            color: white,
                          ),
                        ))
                      : Container(),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  macAndDevicetype() async {
    MacadressGen macadressGen = MacadressGen();
    mac = await macadressGen.getMac();
    if (Io.Platform.isAndroid || Io.Platform.isIOS) {
      return deviceType = 'mobile';
    } else {
      return deviceType = 'laptop';
    }
  }
}
*/
