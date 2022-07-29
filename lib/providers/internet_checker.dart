

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class ConnectivityService with ChangeNotifier {
   bool online = true;
 bool? get isOnline => online;

  connectivityProvider(){
    Connectivity _connectivity = Connectivity();
    _connectivity.onConnectivityChanged.listen((result) async {
      if(result == ConnectivityResult.none){
        online = false;
        notifyListeners();
      }
      else{
        online = true;
        notifyListeners();
      }
    });


  }

}
