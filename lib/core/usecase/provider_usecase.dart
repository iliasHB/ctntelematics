
import 'package:flutter/cupertino.dart';

class GeofenceProvider extends ChangeNotifier {
  bool _isGeofence = false;

  bool get isGeofence => _isGeofence;


  void toggleGeofence(bool value) {
    _isGeofence = value;
    notifyListeners(); // Notify listeners about the state change
  }

}


class ShopNowProvider extends ChangeNotifier {
  bool _isShopNow = false;
  // bool _isAdvert = false;

  bool get isShopNow => _isShopNow;


  void toggleShopNow(bool value) {
    _isShopNow = value;
    // _isAdvert = value;
    notifyListeners(); // Notify listeners about the state change
  }

// bool get _isAdvert => _isAdvert;
// void toggleAdvert(bool value) {
//   _isAdvert = value;
//   notifyListeners(); // Notify listeners about the state change
// }
}


class MaintenanceReminderProvider extends ChangeNotifier {
  bool _isMaintenanceReminder = false;
  // bool _isAdvert = false;

  bool get isMaintenanceReminder => _isMaintenanceReminder;


  void toggleMaintenanceReminder(bool value) {
    _isMaintenanceReminder = value;
    // _isAdvert = value;
    notifyListeners(); // Notify listeners about the state change
  }
}



class VehicleTripProvider extends ChangeNotifier {
  bool _isVehicleTrip = false;
  // bool _isAdvert = false;

  bool get isVehicleTrip => _isVehicleTrip;


  void toggleVehicleTrip(bool value) {
    _isVehicleTrip = value;
    // _isAdvert = value;
    notifyListeners(); // Notify listeners about the state change
  }
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