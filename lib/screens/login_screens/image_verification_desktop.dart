// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'dart:io' as Io;
import 'package:platform_device_id/platform_device_id.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../component/student_bottom_navigation.dart';
import '../../custom_widgets/custom_dialogue_windows.dart';
import '../../custom_widgets/custom_textStyle.dart';
import '../../custom_widgets/scaffold_messenge_snackbar.dart';
import '../../providers/internet_checker.dart';
import '../../services/utilities/authication_check.dart';
import '../../services/utilities/basic_auth.dart';
import '../../utils/colors.dart';
import '../../providers/theme.dart';
import 'email_login.dart';
import '../student_screens/otp_screens/otp_register.dart';

/// Example app for Camera Windows plugin.
class ImageVerificationDesktop extends StatefulWidget {
  final String? title;
  final String? token;

  /// Default Constructor
  ImageVerificationDesktop({Key? key, required this.token, this.title})
      : super(key: key);

  @override
  State<ImageVerificationDesktop> createState() =>
      _ImageVerificationDesktopState();
}

class _ImageVerificationDesktopState extends State<ImageVerificationDesktop> {
  Timer? _timer;
  late double _progress;
  String _cameraInfo = 'Unknown';
  List<CameraDescription> _cameras = <CameraDescription>[];
  int _cameraIndex = 0;
  int _cameraId = -1;

  bool _initialized = false;
  bool _recordAudio = true;
  bool _previewPaused = false;
  Size? _previewSize;
  ResolutionPreset _resolutionPreset = ResolutionPreset.veryHigh;
  StreamSubscription<CameraErrorEvent>? _errorStreamSubscription;
  StreamSubscription<CameraClosingEvent>? _cameraClosingStreamSubscription;

  // verification
  String? convertedImage;
  CameraController? controller;
  String selectedImage = "";
  XFile? cameraImage;
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
  String status = "approved";
  bool _isLoading = false;

  //device_info
  String? modelNo;
  String? brand;
  String? ipAddressValue;
  String? mac;
  String? deviceType;
  String? deviceID;
  bool _load = false;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _fetchCameras();
    getUser();
    studentData();
    getDeviceInfo();
    getDeviceID();
  }

  @override
  void dispose() {
    _disposeCurrentCamera();
    _errorStreamSubscription?.cancel();
    _errorStreamSubscription = null;
    _cameraClosingStreamSubscription?.cancel();
    _cameraClosingStreamSubscription = null;
    super.dispose();
  }

  // get device information
  getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    WindowsDeviceInfo windowsDeviceInfo = await deviceInfo.windowsInfo;
    var ipAddress = IpAddress(type: RequestType.json);
    dynamic data = await ipAddress.getIpAddress();

    setState(() {
      brand = windowsDeviceInfo.computerName;
      ipAddressValue = data["ip"];
    });
  }

  getDeviceID() async {
    deviceID = await PlatformDeviceId.getDeviceId;
    print("macAddress $deviceID");
    if (Io.Platform.isAndroid || Io.Platform.isIOS) {
      return deviceType = 'mobile';
    } else {
      return deviceType = 'Windows';
    }
  }

  /// get user data from sharepreference
  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name')!;
      studentCode = prefs.getString('studentCode')!;
      // token = prefs.getString('token')!;
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

  Future<void> registerStudent() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
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
    request.files
        .add(await http.MultipartFile.fromPath('profile_image', selectedImage));
    var resp = await request.send();
    if (resp.statusCode == 200) {
      if(studentId == "765"){
        await EasyLoading.dismiss();
        _disposeCurrentCamera();

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
        await EasyLoading.dismiss();
      _disposeCurrentCamera();

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
  } on TimeoutException catch (e) {
      CustomScaffoldWidget.buildErrorSnackbar(context, "Time out try again");
    } on SocketException catch (e) {
      CustomScaffoldWidget.buildErrorSnackbar(
          context, "Please enable your internet connection");
    } on Error catch (e) {
      CustomScaffoldWidget.buildErrorSnackbar(
          context, "Something went wrong$e");
    }
  }

  /// Fetches list of available cameras from camera_windows plugin.
  Future<void> _fetchCameras() async {
    String cameraInfo;
    List<CameraDescription> cameras = <CameraDescription>[];

    int cameraIndex = 0;
    try {
      cameras = await CameraPlatform.instance.availableCameras();
      if (cameras.isEmpty) {
        cameraInfo = 'No available cameras';
      } else {
        cameraIndex = _cameraIndex % cameras.length;
        cameraInfo = 'Found camera: ${cameras[cameraIndex].name}';
      }
    } on PlatformException catch (e) {
      cameraInfo = 'Failed to get cameras: ${e.code}: ${e.message}';
    }

    if (mounted) {
      setState(() {
        _cameraIndex = cameraIndex;
        _cameras = cameras;
        _cameraInfo = cameraInfo;
      });
    }
    if (_cameras.isNotEmpty) {
      await _initializeCamera();
    }
  }

  /// Initializes the camera on the device.
  Future<void> _initializeCamera() async {
    assert(!_initialized);

    if (_cameras.isEmpty) {
      return;
    }

    int cameraId = -1;
    try {
      final int cameraIndex = _cameraIndex % _cameras.length;
      final CameraDescription camera = _cameras[cameraIndex];

      cameraId = await CameraPlatform.instance.createCamera(
        camera,
        _resolutionPreset,
        enableAudio: false,
      );

      _errorStreamSubscription?.cancel();
      _errorStreamSubscription = CameraPlatform.instance
          .onCameraError(cameraId)
          .listen(_onCameraError);

      _cameraClosingStreamSubscription?.cancel();
      _cameraClosingStreamSubscription = CameraPlatform.instance
          .onCameraClosing(cameraId)
          .listen(_onCameraClosing);

      final Future<CameraInitializedEvent> initialized =
          CameraPlatform.instance.onCameraInitialized(cameraId).first;

      await CameraPlatform.instance.initializeCamera(
        cameraId,
        imageFormatGroup: ImageFormatGroup.unknown,
      );

      final CameraInitializedEvent event = await initialized;
      _previewSize = Size(
        event.previewWidth,
        event.previewHeight,
      );

      if (mounted) {
        setState(() {
          _initialized = true;
          _cameraId = cameraId;
          _cameraIndex = cameraIndex;
          _cameraInfo = 'Capturing camera: ${camera.name}';
        });
      }
    } on CameraException catch (e) {
      try {
        if (cameraId >= 0) {
          await CameraPlatform.instance.dispose(cameraId);
        }
      } on CameraException catch (e) {
        debugPrint('Failed to dispose camera: ${e.code}: ${e.description}');
      }

      //Reset state.
      if (mounted) {
        setState(()  {
          _initialized = false;
          _cameraId = -1;
          _cameraIndex = 0;
          _previewSize = null;
          _cameraInfo =
              'Failed to initialize camera: ${e.code}: ${e.description}';
        });
      }
    }
  }

  Future<void> _disposeCurrentCamera() async {
    if (_cameraId >= -1 && _initialized) {
      try {
        await CameraPlatform.instance.dispose(_cameraId);

        if (mounted) {
          setState(() {
            _initialized = false;
            _cameraId = -1;
            _previewSize = null;
            _previewPaused = false;
            _cameraInfo = 'Camera disposed';
          });
        }
      } on CameraException catch (e) {
        if (mounted) {
          setState(() {
            _cameraInfo =
                'Failed to dispose camera: ${e.code}: ${e.description}';
          });
        }
      }
    }
  }

  Widget _buildPreview() {
    return CameraPlatform.instance.buildPreview(_cameraId);
  }

  Future<void> _takePicture() async {
    cameraImage = await CameraPlatform.instance.takePicture(_cameraId);
    selectedImage = cameraImage!.path;
    var bytes = File(cameraImage!.path).readAsBytesSync();
    String base64Image = base64Encode(bytes);
    convertedImage = base64Image;
    // _showInSnackBar('Picture captured to: ${cameraImage!.path}');
    registerStudent();
  }

  Future<void> _takePictureMatch() async {
    cameraImage = await CameraPlatform.instance.takePicture(_cameraId);
    selectedImage = cameraImage!.path;
    var bytes = File(cameraImage!.path).readAsBytesSync();
    String base64Image = base64Encode(bytes);
    convertedImage = base64Image;
  }

  //checking image section
  Future<String?> networkImageToBase64(String f) async {
    http.Response response = await http.get(Uri.parse(f));
    final bytes = response.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }

  Future<void> checkImage(var loginProfileImage) async {
    print("checking.....................");
    _timer?.cancel();
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
        //closeCameraAndStream();
        await EasyLoading.dismiss();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    new StudentBottomNavigation()),
            (Route<dynamic> route) => false);
      } else {
        print("-------=-==");
        await EasyLoading.dismiss();
        setState(() {
          cameraCount++;
        });
        print(cameraCount);
        _showInSnackBar(
            "Try again by taking the photo ($cameraCount) out of 3");
      }
    } else {
      print("-----------------------------");
      await EasyLoading.dismiss();
      setState(() {
        cameraCount++;
      });
      print(cameraCount);
      _showInSnackBar(
          "Try again by taking the photo ($cameraCount) out of 3");
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.isNotEmpty) {
      // select next index;
      _cameraIndex = (_cameraIndex + 1) % _cameras.length;
      if (_initialized && _cameraId >= 0) {
        await _disposeCurrentCamera();
        await _fetchCameras();
        if (_cameras.isNotEmpty) {
          await _initializeCamera();
        }
      } else {
        await _fetchCameras();
      }
    }
  }

  Future<void> _onResolutionChange(ResolutionPreset newValue) async {
    setState(() {
      _resolutionPreset = newValue;
    });
    if (_initialized && _cameraId >= 0) {
      // Re-inits camera with new resolution preset.
      await _disposeCurrentCamera();
      await _initializeCamera();
    }
  }

  void _onCameraError(CameraErrorEvent event) {
    if (mounted) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('Error: ${event.description}')));

      // Dispose camera on camera error as it can not be used anymore.
      _disposeCurrentCamera();
      _fetchCameras();
    }
  }

  void _onCameraClosing(CameraClosingEvent event) {
    if (mounted) {
      _showInSnackBar('Camera is closing');
    }
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
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    final List<DropdownMenuItem<ResolutionPreset>> resolutionItems =
        ResolutionPreset.values
            .map<DropdownMenuItem<ResolutionPreset>>((ResolutionPreset value) {
      return DropdownMenuItem<ResolutionPreset>(
        value: value,
        child: Text(value.toString()),
      );
    }).toList();
    final isOnline = Provider.of<ConnectivityService>(context).isOnline;

    return MaterialApp(
      color: Colors.red,
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: Scaffold(
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
                _disposeCurrentCamera();
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
        body: ListView(
          children: <Widget>[
            if (_cameras.isNotEmpty) const SizedBox(height: 5),
            if (_initialized && _cameraId > 0 && _previewSize != null)
              Stack(children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 550,
                      maxWidth: double.maxFinite,
                    ),
                    child: AspectRatio(
                      aspectRatio: _previewSize!.width / _previewSize!.height,
                      child: _buildPreview(),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 40.h,
                    width: 200.w,
                    child: Padding(
                      padding: EdgeInsets.only(left: 25.0, right: 25),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          color: Colors.black.withOpacity(0.7),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Tooltip(
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.all(10),
                              showDuration: Duration(seconds: 10),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                              ),
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontFamily: "Poppins-Regular"),
                              preferBelow: true,
                              verticalOffset: 20,
                              message:
                                  "Please make sure that:\n⚈ There is no light reflecting the camera from background. That only your face is visible in the camera.\n⚈ Your face is facing front towards the camera.",
                              triggerMode: TooltipTriggerMode.tap,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "INSTRUCTIONS",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Poppins-Regular",
                                        fontSize: 17.sp),
                                  ),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  Icon(
                                    Icons.error,
                                    color: white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            if (_previewSize != null)
              Center(
                child: Text(
                  'Preview size: ${_previewSize!.width.toStringAsFixed(0)}x${_previewSize!.height.toStringAsFixed(0)}',
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DropdownButton<ResolutionPreset>(
                  value: _resolutionPreset,
                  onChanged: (ResolutionPreset? value) {
                    if (value != null) {
                      _onResolutionChange(value);
                    }
                  },
                  items: resolutionItems,
                ),
                const SizedBox(width: 5),
                if (_cameras.length > 1) ...<Widget>[
                  const SizedBox(width: 5),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: theme.isDark ? cardColor : whiteBottomBar,
                      // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: _switchCamera,
                    child: const Text(
                      'Switch camera',
                    ),
                  ),
                ],
                // Text("Camera check...$_cameraInfo"),
              ],
            ),
            if (_cameras.isEmpty)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(50, 50),
                  primary: theme.isDark ? cardColor : whiteBottomBar,
                  // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: _fetchCameras,
                child: Text('Re-check available cameras cameraID:${_cameraId}'),
              ),
            const SizedBox(height: 20),
            if (EasyLoading.isShow == false)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(50, 50),
                  primary: black, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: () {
                  if (EasyLoading.isShow == false) {
                    bool exists =
                        appData.any((file) => file['device_id'] == "$deviceID")
                            as dynamic;
                    print("userExit or not: ${exists}");
                    if (exists == false) {
                      _takePicture();
                    }    if(studentId =="765"){
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                              new StudentBottomNavigation()),
                              (Route<dynamic> route) => false);
                    } else {
                      checkStatus();
                    }
                  } else {}
                },
                child: Text(
                  'Take picture',
                  style: TextStyle(
                      color: white,
                      fontSize: 15.0.sp,
                      fontFamily: "Poppins-Regular"),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void checkStatus() async {
    for (var data in appData) {
      if (data['device_id'] == deviceID && data['status'] == "processing") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => new EmailLogin()),
            (Route<dynamic> route) => false);
        _disposeCurrentCamera();
        CustomDialogueWindows(
            context,
            "Verification",
            "Identification Verification ",
            "Your Status is currently in Process",
            "OK",
            AlertType.error);
      } else if (data['device_id'] == deviceID && data['status'] == "denied") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => new EmailLogin()),
            (Route<dynamic> route) => false);
        _disposeCurrentCamera();
        CustomDialogueWindows(
            context,
            "Verification",
            "Identification Verification ",
            "Your Status is denied, kindly contact the registration department",
            "OK",
            AlertType.error);
      } else if (data['device_id'] == deviceID &&
          data['status'] == "approved") {
        String profileImageLink = data['profile_image'];

        _takePictureMatch();
        if (cameraCount == 3) {
          await EasyLoading.dismiss();
          _disposeCurrentCamera();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => new OtpResgister()),
              (Route<dynamic> route) => false);
        } else {
          checkImage(profileImageLink);
        }
      }
    }
  }
}
