
import 'package:flutter/cupertino.dart';

class GeofenceProvider extends ChangeNotifier {
  bool _isGeofence = false;
  // bool _isAdvert = false;

  bool get isGeofence => _isGeofence;


  void toggleGeofence(bool value) {
    _isGeofence = value;
    // _isAdvert = value;
    notifyListeners(); // Notify listeners about the state change
  }

  // bool get _isAdvert => _isAdvert;
  // void toggleAdvert(bool value) {
  //   _isAdvert = value;
  //   notifyListeners(); // Notify listeners about the state change
  // }
}



// class MultiServiceProvider extends ChangeNotifier {
//   bool _isGeofence = false;
//   bool _isAdvert = false;
//
//   bool get isGeofence => _isGeofence;
//   bool get _isAdvert => _isAdvert;
//
//   void toggleGeofence(bool value) {
//     _isGeofence = value;
//     _isAdvert = value;
//     notifyListeners(); // Notify listeners about the state change
//   }
//
//   void toggleAdvert(bool value) {
//     _isAdvert = value;
//     notifyListeners(); // Notify listeners about the state change
//   }
// }