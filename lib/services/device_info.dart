import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:macadress_gen/macadress_gen.dart';
import 'dart:io' as Io;


class DeviceInfo {
  String? devicetype = "";
  String? mac ="";
  var modelno;
  var deviceName;
  var isPhysical;
  var deviceId;
  var getIpAddress;
  var deviceType;






  Future<void> getMobileInfo( ) async {
    getdevicetype();
    getMAc();
    var ipAddress = IpAddress(type: RequestType.json);
    dynamic data = await ipAddress.getIpAddress();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
     modelno=androidInfo.model;
    deviceName=androidInfo.brand;
   isPhysical=androidInfo.isPhysicalDevice;
    deviceId=androidInfo.androidId;
   getIpAddress=data['ip'];
    deviceType=devicetype;



    print('model no ${androidInfo.model}');
    print("Device name ${androidInfo.brand}");
    print("isPhysical ${androidInfo.isPhysicalDevice}");
    print('Device ID ${androidInfo.androidId}');
    print('IP Address ${data['ip']}');
    print("Device Type ${devicetype}");



  }
  Future getMAc() async {
    MacadressGen macadressGen = MacadressGen();
    mac = await macadressGen.getMac();
    print("macAddress ${mac}");
  }

  Future<String?> getdevicetype() async {
    if (Io.Platform.isAndroid || Io.Platform.isIOS) {
      devicetype = 'mobile';
    } else {
      devicetype = 'laptop';
    }
    return null;
  }
}