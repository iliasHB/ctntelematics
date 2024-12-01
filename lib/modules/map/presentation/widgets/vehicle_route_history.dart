// import 'dart:math';
//
// import 'package:ctntelematics/core/utils/app_export_util.dart';
// import 'package:ctntelematics/modules/map/domain/entitties/req_entities/route_history_req_entity.dart';
// import 'package:ctntelematics/modules/map/domain/entitties/resp_entities/route_history_resp_entity.dart';
// import 'package:ctntelematics/modules/map/presentation/bloc/map_bloc.dart';
// import 'package:ctntelematics/modules/map/presentation/widgets/vehicle_operation.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

// class VehicleRouteHistoryScreen extends StatefulWidget {
//   @override
//   _VehicleRouteHistoryScreenState createState() => _VehicleRouteHistoryScreenState();
// }
//
// class _VehicleRouteHistoryScreenState extends State<VehicleRouteHistoryScreen> {
//   DateTime? fromDate;
//   DateTime? toDate;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Vehicle Route History')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             _showVehicleRouteDialog(
//               context,
//               'Tesla',
//               'Model S',
//               '5YJSA1E23HF000316',
//               '37.7749',
//               '-122.4194',
//               'your_token',
//             );
//           },
//           child: Text('Show Route History'),
//         ),
//       ),
//     );
//   }
//
//   // This method is used to show the dialog
//   void _showVehicleRouteDialog(
//       BuildContext context,
//       String? brand,
//       String? model,
//       String? vin,
//       String? latitude,
//       String? longitude,
//       String? token) {
//     showGeneralDialog(
//       context: context,
//       barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
//       barrierDismissible: true,
//       pageBuilder: (_, __, ___) {
//         return Align(
//           alignment: Alignment.center,
//           child: Material(
//             color: Colors.transparent,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               constraints: BoxConstraints(
//                   maxHeight: MediaQuery.of(context).size.height * 0.8),
//               width: 360,
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Flexible(
//                           child: Text(
//                             'Route History - $brand $model ($vin)',
//                             style: TextStyle(fontSize: 16),
//                             softWrap: true,
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 3,
//                           ),
//                         ),
//                         const Spacer(),
//                         IconButton(
//                             onPressed: () => Navigator.pop(context),
//                             icon: const Icon(Icons.cancel_outlined)),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     DateTimeRangePicker(
//                       onDateFromSelected: (selectedFromDate) {
//                         setState(() {
//                           fromDate = selectedFromDate;
//                         });
//                       },
//                       onDateToSelected: (selectedToDate) {
//                         setState(() {
//                           toDate = selectedToDate;
//                         });
//                       },
//                     ),
//                     const Row(
//                       children: [
//                         BadgeWidget(label: "Yesterday"),
//                         SizedBox(width: 10),
//                         BadgeWidget(label: "2 days ago"),
//                         SizedBox(width: 10),
//                         BadgeWidget(label: "3 days ago"),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     Align(
//                       alignment: Alignment.topLeft,
//                       child: ElevatedButton.icon(
//                         onPressed: () {
//                           final routeHistoryReqEntity = RouteHistoryReqEntity(
//                             vehicle_vin: vin!,
//                             time_from: fromDate?.toString() ?? "N/A",
//                             time_to: toDate?.toString() ?? "N/A",
//                             token: token!,
//                           );
//                           BlocProvider.of<RouteHistoryBloc>(context).add(
//                             RouteHistoryEvent(routeHistoryReqEntity),
//                           );
//                         },
//                         icon: const Icon(Icons.filter_alt),
//                         label: const Text("Filter"),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
///------
// DateTime? fromDate;
// DateTime? toDate;
// String? speed;
//
// class VehicleRouteHistory {
//   static showVehicleRouteDialog(
//       BuildContext context,
//       String? brand,
//       String? model,
//       String? vin,
//       String? latitude,
//       String? longitude,
//       String? token) {
//     return showGeneralDialog(
//       context: context,
//       barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
//       barrierDismissible: true,
//       // transitionDuration: const Duration(milliseconds: 700),
//       pageBuilder: (context, anim1, anim2) {
//         return Align(
//           alignment: Alignment.topCenter,
//           child: Material(
//             // Added Material widget here
//             color: Colors.transparent,
//             child: Container(
//               padding: const EdgeInsets.only(top: 20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               constraints: BoxConstraints(
//                   maxHeight: MediaQuery.of(context).size.height *
//                       0.8), // Dynamic height
//               width: double.infinity,
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       children: [
//                         Flexible(
//                           child: Text(
//                             'Route History - $brand $model ($vin)',
//                             style: AppStyle.cardSubtitle,
//                             softWrap: true,
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 3,
//                           ),
//                         ),
//                         const Spacer(),
//                         IconButton(
//                             onPressed: () => Navigator.pop(context),
//                             icon: const Icon(Icons.cancel_outlined))
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     DateTimeRangePicker(
//                         // onDateFromSelected: (selectedFromDate) {
//                         //   fromDate = selectedFromDate;
//                         // },
//                         // onDateToSelected: (selectedToDate) {
//                         //   toDate = selectedToDate;
//                         // },
//                         onSpeedSelected: (selectedSpeed) {
//                           speed = selectedSpeed;
//                         },
//                         vin: vin,
//                         token: token),
//                     const Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Flexible(child: BadgeWidget(label: "Yesterday")),
//                         const SizedBox(width: 10),
//                         Flexible(child: BadgeWidget(label: "2 days ago")),
//                         const SizedBox(width: 10),
//                         Flexible(child: BadgeWidget(label: "3 days ago"))
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     BlocConsumer<RouteHistoryBloc, MapState>(
//                         builder: (BuildContext context, state) {
//                       if (state is MapLoading) {
//                         return const Center(child: CircularProgressIndicator());
//                       } else if (state is GetRouteHistoryDone) {
//                         return Flexible(
//                           child: RouteHistoryMap(
//                               data: state.resp.data, speed: speed),
//                         );
//                       } else {
//                         return RouteLastLocation(
//                             double.parse(latitude!), double.parse(longitude!));
//                       }
//                     }, listener: (context, state) {
//                       if (state is MapFailure) {
//                         if (state.message.contains("401")) {
//                           Navigator.pushNamed(context, "/login");
//                         }
//                         ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text(state.message)));
//                       }
//                     })
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//       transitionBuilder: (context, anim1, anim2, child) {
//         return SlideTransition(
//           position: Tween<Offset>(
//             begin: const Offset(0, -1),
//             end: Offset.zero,
//           ).animate(CurvedAnimation(
//             parent: anim1,
//             curve: Curves.easeInOut,
//           )),
//           child: child,
//         );
//       },
//       transitionDuration: const Duration(milliseconds: 300),
//     );
//   }
// }
//
// class BadgeWidget extends StatelessWidget {
//   final String label;
//   const BadgeWidget({super.key, required this.label});
//
//   @override
//   Widget build(BuildContext context) {
//     return Chip(
//       side: BorderSide.none,
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       backgroundColor: Colors.grey.shade200,
//       label: Text(
//         label,
//         style: AppStyle.cardSubtitle,
//       ),
//     );
//   }
// }
//
// const List<String> speedType = <String>['1x', '2x', '3x', '4x', '5x'];
//
// class DateTimeRangePicker extends StatefulWidget {
//   // final Function(DateTime?) onDateFromSelected;
//   // final Function(DateTime?) onDateToSelected;
//   final Function(String?) onSpeedSelected;
//   final String? vin, token;
//   const DateTimeRangePicker(
//       {super.key,
//       // required this.onDateFromSelected,
//       // required this.onDateToSelected,
//       required this.onSpeedSelected,
//       required this.vin,
//       required this.token});
//   @override
//   _DateTimeRangePickerState createState() => _DateTimeRangePickerState();
// }
//
// class _DateTimeRangePickerState extends State<DateTimeRangePicker> {
//   DateTime? fromDate;
//   DateTime? toDate;
//   String dropdownValue1 = speedType.first;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                   child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'From: ',
//                     style: AppStyle.cardTitle.copyWith(fontSize: 14),
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                           child: SizedBox(
//                         height: 40,
//                         child: TextFormField(
//                           decoration: InputDecoration(
//                             enabled: false,
//                             filled: true,
//                             fillColor: Colors.grey[200],
//                             label: Text(
//                               fromDate == null
//                                   ? 'Select End Date and Time'
//                                   : fromDate.toString(),
//                             ),
//                             // hintText: fromDate == null
//                             //     ? ''
//                             //     : widget.onDateFromSelected(fromDate),
//                             border: OutlineInputBorder(
//                                 borderSide: BorderSide.none,
//                                 borderRadius: BorderRadius.circular(5)),
//                           ),
//                         ),
//                       )),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       InkWell(
//                           onTap: () {
//                             DatePicker.showDateTimePicker(
//                               context,
//                               showTitleActions: true,
//                               onConfirm: (date) {
//                                 setState(() {
//                                   fromDate = date;
//                                 });
//                               },
//                               currentTime: DateTime.now(),
//                             );
//                           },
//                           child: const Icon(
//                             Icons.calendar_month,
//                             color: Colors.green,
//                           ))
//                     ],
//                   ),
//                 ],
//               )),
//             ],
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Row(
//             children: [
//               Expanded(
//                   child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'To: ',
//                     style: AppStyle.cardTitle.copyWith(fontSize: 14),
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                           child: SizedBox(
//                         height: 40,
//                         child: TextFormField(
//                           decoration: InputDecoration(
//                             enabled: false,
//                             filled: true,
//                             fillColor: Colors.grey[200],
//                             // suffixIcon:  InkWell(
//                             //     onTap: () {
//                             //       DatePicker.showDateTimePicker(
//                             //         context,
//                             //         showTitleActions: true,
//                             //         onConfirm: (date) {
//                             //           setState(() {
//                             //             fromDate = date;
//                             //           });
//                             //         },
//                             //         currentTime: DateTime.now(),
//                             //       );
//                             //     },
//                             //     child: const Icon(Icons.calendar_month)),
//                             label: Text(
//                               toDate == null
//                                   ? 'Select End Date and Time'
//                                   : toDate.toString(),
//                             ),
//                             // hintText: toDate == null
//                             //     ? ''
//                             //     : widget.onDateToSelected(toDate),
//                             border: OutlineInputBorder(
//                                 borderSide: BorderSide.none,
//                                 borderRadius: BorderRadius.circular(5)),
//                           ),
//                         ),
//                       )
//                           // Container(
//                           //   padding: EdgeInsets.all(10),
//                           //   decoration: BoxDecoration(
//                           //     color: Colors.grey.shade200
//                           //   ),
//                           //   child: Text(
//                           //     fromDate == null
//                           //         ? 'Select End Date and Time'
//                           //         : fromDate.toString(),
//                           //   ),
//                           // ),
//                           ),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       InkWell(
//                           onTap: () {
//                             DatePicker.showDateTimePicker(
//                               context,
//                               showTitleActions: true,
//                               onConfirm: (date) {
//                                 // widget.onDateToSelected(toDate);
//                                 setState(() {
//                                   toDate = date;
//                                 });
//                               },
//                               currentTime: DateTime.now(),
//                             );
//                           },
//                           child: const Icon(
//                             Icons.calendar_month,
//                             color: Colors.green,
//                           ))
//                     ],
//                   ),
//                 ],
//               )),
//             ],
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Text(
//             'Speed: ',
//             style: AppStyle.cardTitle.copyWith(fontSize: 14),
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: DropdownMenu<String>(
//                   width: MediaQuery.of(context).size.width - 45,
//                   textStyle: AppStyle.cardSubtitle
//                       .copyWith(fontWeight: FontWeight.w500),
//                   initialSelection: speedType.first,
//                   onSelected: (String? value) {
//                     setState(() {
//                       dropdownValue1 = value!;
//                     });
//                     widget.onSpeedSelected(value);
//                   },
//                   dropdownMenuEntries:
//                       speedType.map<DropdownMenuEntry<String>>((String value) {
//                     return DropdownMenuEntry<String>(
//                         // leadingIcon: const Icon(CupertinoIcons.add),
//                         value: value,
//                         label: value);
//                   }).toList(),
//                 ),
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//               //filter button
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: ElevatedButton.icon(
//                   onPressed: () {
//                     final routeHistoryReqEntity = RouteHistoryReqEntity(
//                         vehicle_vin: widget.vin!, //vin!,
//                         time_from: fromDate.toString().split('.').first ??
//                             "N/A", //?.toString().split('.').first ??
//                         //"2024-10-18 18:05:15",
//                         time_to: toDate.toString().split('.').first ?? "N/A",
//                         //"N/A", //"2024-10-21 18:05:15",
//                         token: widget.token!);
//                     // Dispatch an event to update the map or filter the data
//                     BlocProvider.of<RouteHistoryBloc>(context)
//                         .add(RouteHistoryEvent(routeHistoryReqEntity));
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                         Colors.green, // Set the background color to green
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(
//                           8), // Adjust the radius as needed
//                     ),
//                   ),
//                   icon: const Icon(Icons.filter_alt),
//                   label: Text(
//                     'Filter',
//                     style: AppStyle.cardSubtitle.copyWith(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class RouteHistoryMap extends StatefulWidget {
//   // final List<Map<String, dynamic>> locations; // This should contain your JSON data
//   final List<DatumEntity> data;
//   final String? speed;
//   const RouteHistoryMap(
//       {super.key, required this.data, required this.speed});
//
//   @override
//   _RouteHistoryMapState createState() => _RouteHistoryMapState();
// }
//
// class _RouteHistoryMapState extends State<RouteHistoryMap> {
//   late GoogleMapController _mapController;
//   List<LatLng> _polylineCoordinates = [];
//   Map<MarkerId, Marker> _markers = {};
//   PolylinePoints polylinePoints = PolylinePoints();
//   int _currentIndex = 0;
//   Marker? _vehicleMarker;
//   String _currentAddress = "Loading...";
//   BitmapDescriptor? _customIcon;
//   // Animation states
//   bool _isPlaying = false;
//   bool _isPaused = false;
//   bool _isStopped = true;
//   final PanelController _panelController = PanelController();
//   // Speed mapping
//   final Map<String, Duration> speedMap = {
//     '1x': const Duration(seconds: 2), // Slowest speed
//     '2x': const Duration(seconds: 1), // 2x speed
//     '3x': const Duration(milliseconds: 750), // 3x speed
//     '4x': const Duration(milliseconds: 500), // 4x speed
//     '5x': const Duration(milliseconds: 250), // Fastest speed (5x)
//   };
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeMarkersAndRoute();
//     _setCustomMarkerIcon();
//     // Load the custom vehicle icon
//   }
//
//   Future<void> _setCustomMarkerIcon() async {
//     print("_setCustomMarkerIcon");
//     try {
//       _customIcon = await BitmapDescriptor.fromAssetImage(
//         const ImageConfiguration(size: Size(24, 24)),
//         'assets/images/vehicle_map.png', // Path to your custom vehicle image
//       );
//       print('Custom marker icon loaded successfully');
//       setState(() {}); // Refresh to show the marker with the custom icon
//     } catch (e) {
//       print('Error loading custom marker icon: $e');
//     }
//   }
//
//   void _initializeMarkersAndRoute() {
//     final totalLocations = widget.data.length;
//     if (totalLocations > 0) {
//       // Add marker at the start point
//       _addMarker(widget.data.first, 'Start',
//           BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));
//
//       // Add markers at regular intervals (e.g., every 10 locations)
//       const interval = 20;
//       for (int i = interval; i < totalLocations - interval; i += interval) {
//         _addMarker(
//           widget.data[i],
//           'Checkpoint $i',
//           BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//         );
//       }
//
//       // Add marker at the end point
//       _addMarker(widget.data.last, 'End',
//           BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
//     }
//
//     // Populate the polyline coordinates
//     _polylineCoordinates = widget.data
//         .map((location) => LatLng(double.parse(location.latitude!),
//             double.parse(location.longitude!)))
//         .toList();
//   }
//
//   void _addMarker(location, String label, BitmapDescriptor icon) {
//     final lat = double.parse(location.latitude!);
//     final lng = double.parse(location.longitude!);
//     LatLng latLng = LatLng(lat, lng);
//     Marker marker = Marker(
//       markerId: MarkerId(location.id.toString()),
//       position: latLng,
//       infoWindow:
//           InfoWindow(title: label, snippet: "Speed: ${location.speed} km/h"),
//       icon: icon,
//     );
//     _markers[MarkerId(location.id.toString())] = marker;
//   }
//
// // Convert degrees to radians
//   double _degreesToRadians(double degrees) {
//     return degrees * pi / 180.0;
//   }
//
// // Convert radians to degrees
//   double _radiansToDegrees(double radians) {
//     return radians * 180.0 / pi;
//   }
//
//   // Method to calculate the bearing between two LatLng points
//   double _calculateBearing(LatLng start, LatLng end) {
//     double lat1 = _degreesToRadians(start.latitude);
//     double lon1 = _degreesToRadians(start.longitude);
//     double lat2 = _degreesToRadians(end.latitude);
//     double lon2 = _degreesToRadians(end.longitude);
//
//     double dLon = lon2 - lon1;
//
//     double y = sin(dLon) * cos(lat2);
//     double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
//
//     double bearing = _radiansToDegrees(atan2(y, x));
//
//     return (bearing + 360) % 360; // Normalize to 0-360 degrees
//   }
//
//   void _animateVehicleMovement() async {
//     if (_currentIndex >= _polylineCoordinates.length ||
//         !_isPlaying ||
//         _isPaused) {
//       return;
//     }
//
//     LatLng currentLocation = _polylineCoordinates[_currentIndex];
//     // LatLng nextLocation = _polylineCoordinates[_currentIndex + 1];
//
//     // Call the method to update the vehicle's position
//     _updateVehiclePosition(currentLocation);
//     // // Calculate the bearing between the current and the next location
//     // double bearing = _calculateBearing(currentLocation, nextLocation);
//
//     await _mapController.animateCamera(CameraUpdate.newLatLng(currentLocation));
//
//     // Calculate the bearing between the current and the next location
//     if (_currentIndex < _polylineCoordinates.length - 1) {
//       LatLng nextLocation = _polylineCoordinates[_currentIndex + 1];
//       double bearing = _calculateBearing(currentLocation, nextLocation);
//
//       await _mapController
//           .animateCamera(CameraUpdate.newLatLng(currentLocation));
//
//       setState(() {
//         _vehicleMarker = Marker(
//           markerId: const MarkerId('vehicle'),
//           position: currentLocation,
//           icon: _customIcon ??
//               BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//           rotation: bearing,
//           anchor: const Offset(0.5, 0.5),
//         );
//       });
//     }
//
//     _fetchAddress(currentLocation.latitude, currentLocation.longitude);
//     _currentIndex++;
//     print("speed: ${speedMap[widget.speed]}");
//     // Use the speed parameter to determine the delay between movements
//     Duration delay = speedMap[widget.speed] ??
//         const Duration(seconds: 1); // Default to 1 second if speed is not set
//     Future.delayed(delay, _animateVehicleMovement); // Recursively animate
//   }
//
//
//
//
//
//   void _fetchAddress(double latitude, double longitude) async {
//     List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
//     if (placemarks.isNotEmpty) {
//       Placemark place = placemarks[0];
//       setState(() {
//         _currentAddress =
//             "${place.street}, ${place.locality}, ${place.country}";
//       });
//     }
//   }
//
//   void _play() {
//     setState(() {
//       _isPlaying = true;
//       _isPaused = false;
//       _isStopped = false;
//       _animateVehicleMovement();
//     });
//   }
//
//   void _pause() {
//     setState(() {
//       _isPaused = true;
//       _isPlaying = false;
//     });
//   }
//
//   void _stop() {
//     setState(() {
//       _isStopped = true;
//       _isPlaying = false;
//       _isPaused = false;
//       _currentIndex = 0; // Reset index to start from the beginning
//       _vehicleMarker = null; // Remove the vehicle marker
//     });
//   }
//
//   double? _currentLatitude;
//   double? _currentLongitude;
//
//   // Assuming you have a method to update the vehicle's position
//   void _updateVehiclePosition(LatLng newPosition) {
//     setState(() {
//       _currentLatitude = newPosition.latitude;
//       _currentLongitude = newPosition.longitude;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Address container
//         Container(
//             color: Colors.white,
//             padding: const EdgeInsets.only(top: 8),
//             margin: const EdgeInsets.only(bottom: 8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Address: $_currentAddress',
//                     style: AppStyle.cardSubtitle.copyWith(fontSize: 14)),
//                 // Display latitude and longitude as a single line
//                 Text(
//                     'Coordinate: (${_currentLatitude?.toStringAsFixed(6) ?? 'N/A'}, '
//                     '${_currentLongitude?.toStringAsFixed(6) ?? 'N/A'})',
//                     style: AppStyle.cardSubtitle.copyWith(fontSize: 14)),
//               ],
//             )),
//
//         // Google Map widget
//         Flexible(
//           child: Stack(
//             children: [
//               Container(
//                 height: double.infinity, //MediaQuery.of(context).size.height * 0.7,
//                 // height: 280,
//                 margin: const EdgeInsets.only(top: 0.0),
//                 child: GoogleMap(
//                   initialCameraPosition: CameraPosition(
//                     target: _polylineCoordinates.first,
//                     zoom: 15.0,
//                   ),
//                   markers: _markers.values.toSet()..addIfNotNull(_vehicleMarker),
//                   polylines: {
//                     Polyline(
//                       polylineId: const PolylineId('route'),
//                       points: _polylineCoordinates,
//                       color: Colors.blue,
//                       width: 5,
//                     ),
//                   },
//                   onMapCreated: (controller) {
//                     _mapController = controller;
//                   },
//                 ),
//               ),
//               SlidingUpPanel(
//                 controller: _panelController,
//                 minHeight: 80.0,
//                 maxHeight: 700.0,
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
//                 panel: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                     children: [
//                       Container(
//                         alignment: Alignment.center,
//                         margin: const EdgeInsets.only(bottom: 10),
//                         width: 50,
//                         height: 5,
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade200,
//                           borderRadius: BorderRadius.circular(10)
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ElevatedButton.icon(
//                             onPressed: _isPlaying ? null : _play,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             icon: const Icon(Icons.play_arrow),
//                             label: const Text('Play'),
//                           ),
//                           const SizedBox(width: 10),
//                           ElevatedButton.icon(
//                             onPressed: !_isPlaying || _isPaused ? null : _pause,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             icon: const Icon(Icons.pause),
//                             label: const Text('Pause'),
//                           ),
//                           //const SizedBox(width: 10),
//                           ElevatedButton.icon(
//                             onPressed: !_isPlaying && !_isPaused ? null : _stop,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             icon: const Icon(Icons.stop),
//                             label: const Text('Stop'),
//                           ),
//                           //const SizedBox(width: 10),
//                           ElevatedButton(
//                             onPressed: (){},
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: Text(widget.speed!, style: const TextStyle(fontSize: 18),
//                             )
//                           ),
//                         ],
//                       ),
//
//                       Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Card(
//                           child: Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Flexible(
//                                   flex: 2,
//                                     child: Column(
//                                       // mainAxisAlignment: MainAxisAlignment.start,
//                                       // crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Icon(Icons.place, color: Colors.red,),
//                                         SizedBox(height: 40,),
//                                         Icon(Icons.place, color: Colors.green,)
//                                       ],
//                                     )),
//                                 Flexible(
//                                     flex: 6,
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(widget.data[0].latitude!+","+widget.data[0].longitude!),
//                                         Text(widget.data[0].created_at!),
//                                         const SizedBox(height: 20,),
//                                         Text(widget.data[1].latitude!+","+widget.data[0].longitude!),
//                                         Text(widget.data[2].created_at!),
//                                       ],
//                                     )),
//                                 Flexible(
//                                     flex: 2,
//                                     child: Container())
//                               ],
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//
//       ],
//     );
//   }
// }
//
// extension MarkerSetExtension on Set<Marker> {
//   void addIfNotNull(Marker? marker) {
//     if (marker != null) {
//       add(marker);
//     }
//   }
// }
//
// class RouteLastLocation extends StatefulWidget {
//   final double latitude, longitude;
//   const RouteLastLocation(this.latitude, this.longitude, {super.key});
//
//   @override
//   State<RouteLastLocation> createState() => _RouteLastLocationState();
// }
//
// class _RouteLastLocationState extends State<RouteLastLocation> {
//   late GoogleMapController mapController;
//   BitmapDescriptor? _customIcon;
//   late Future<void> _getAuthUserFuture;
//   Set<Marker> _markers = {};
//   @override
//   void initState() {
//     super.initState();
//     _getAuthUserFuture = _loadInitialData();
//     // Initialize Pusher after starting to load initial data
//   }
//
//   Future<void> _loadInitialData() async {
//     try {
//       await Future.wait([
//         // _getAuthUser(),
//         _setCustomMarkerIcon(),
//       ]);
//     } catch (e, stackTrace) {
//       print('Error during initialization: $e');
//       print("Stack trace: $stackTrace");
//     }
//   }
//
//   Future<void> _setCustomMarkerIcon() async {
//     print("_setCustomMarkerIcon");
//     try {
//       _customIcon = await BitmapDescriptor.fromAssetImage(
//         const ImageConfiguration(size: Size(24, 24)),
//         'assets/images/vehicle_map.png',
//       );
//       print('Custom marker icon loaded successfully');
//       setState(() {}); // Refresh to show the marker with the custom icon
//     } catch (e) {
//       print('Error loading custom marker icon: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: _getAuthUserFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(child: Text('Failed to fetch user data'));
//           } else {
//             final LatLng _center = LatLng(widget.latitude, widget.longitude);
//             _markers.addAll([
//               Marker(
//                 icon: _customIcon!,
//                 markerId: const MarkerId('id'),
//                 position: LatLng(widget.latitude, widget.longitude),
//               ),
//             ]);
//             return Flexible(
//               child: Container(
//                 margin: const EdgeInsets.only(top: 20.0),
//                 height:
//                     double.infinity, //MediaQuery.of(context).size.height * 0.4,
//                 child: GoogleMap(
//                   onMapCreated: (GoogleMapController controller) {
//                     mapController = controller;
//                   },
//                   initialCameraPosition: CameraPosition(
//                     target: _center,
//                     zoom: 11.0,
//                   ),
//                   markers: _markers,
//                   // polygons: _geofencePolygon != null ? {_geofencePolygon!} : {},
//                   // circles: {_geofenceCircle!}, // Show geofence circle
//                 ),
//               ),
//             );
//           }
//         });
//   }
// }
