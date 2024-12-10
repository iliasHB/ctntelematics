import 'dart:math';

import 'package:ctntelematics/modules/vehincle/presentation/widgets/vehicle_dashcam.dart';
import 'package:ctntelematics/modules/vehincle/presentation/widgets/vehicle_operations.dart';
import 'package:ctntelematics/modules/vehincle/presentation/widgets/vehicle_route_history.dart';
import 'package:ctntelematics/modules/vehincle/presentation/widgets/vehicle_share_route.dart';
import 'package:ctntelematics/modules/websocket/domain/entitties/resp_entities/vehicle_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/usecase/provider_usecase.dart';
import '../../../../core/utils/app_export_util.dart';
import '../../../websocket/presentation/bloc/vehicle_location_bloc.dart';
import 'dart:math' as math;

import 'driver_info.dart';

class VehicleRouteLastLocation extends StatefulWidget {
  final String brand;
  final String model;
  final String vin;
  final double? latitude;
  final double? longitude;
  final String token;
  final String number_plate;
  final String? name, email, phone;
  final String status;
  final String updated_at;
  final String speed;
  final String voltage_level;
  final String gsm_signal_strength;
  final bool real_time_gps;
  const VehicleRouteLastLocation(
      {super.key,
      required this.brand,
      required this.model,
      required this.vin,
      this.latitude,
      this.longitude,
      required this.token,
      required this.number_plate,
      this.name,
      this.email,
      this.phone,
      required this.status,
      required this.updated_at,
      required this.speed,
      required this.voltage_level,
      required this.gsm_signal_strength,
      required this.real_time_gps});

  @override
  State<VehicleRouteLastLocation> createState() => _VehicleRouteLastLocationState();
}

class _VehicleRouteLastLocationState extends State<VehicleRouteLastLocation> {
  late GoogleMapController mapController;
  BitmapDescriptor? _offlineCustomIcon;
  BitmapDescriptor? _movingCustomIcon;
  late Future<void> _initializationFuture;
  final Set<Marker> _markers = {};
  bool _isContainerVisible = false;
  bool _showShareRoute = false;
  bool _showDashCam = false;
  bool _showVehicleOperation = false;
  bool _showDriverInfo = false;
  Polygon? _geofencePolygon;
  @override
  void initState() {
    super.initState();
    _initializationFuture = _loadInitialData();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _isContainerVisible = true;
      });
    });
  }

  Future<void> _loadInitialData() async {
    try {
      await _setOfflineCustomMarkerIcon();
    } catch (e, stackTrace) {
      print('Error during initialization: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<void> _setOfflineCustomMarkerIcon() async {
    try {
      final iconSize = 15.0;
      final image = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(iconSize, iconSize)),
        'assets/images/vehicle_map.png',
      );
      setState(() {
        _offlineCustomIcon = image;
      });
    } catch (e) {
      print('Error loading custom marker icon: $e');
    }
  }

  Future<void> _setOnlineCustomMarkerIcon() async {
    try {
      final iconSize = 15.0; // Adjust this size as needed

      // Load and resize the image
      final image = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
            size: Size(iconSize, iconSize)), // Size of the marker icon
        'assets/images/green_moving_car_01.png', // Your custom image path
      );

      setState(() {
        _movingCustomIcon = image; // Save the custom icon to use on the map
      });
    } catch (e) {
      print('Error loading custom marker icon: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: _initializationFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: Colors.green,
                  ),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Failed to fetch data',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                );
              }

              // FutureBuilder is ready, proceed with BlocBuilder
              return BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
                builder: (context, vehicles) {
                  final isGeofence = context.watch<GeofenceProvider>().isGeofence;

                  if (vehicles.isEmpty) {
                    // If no vehicles, place static marker at the initial position
                    final LatLng center = LatLng(
                      widget.latitude!.toDouble(),
                      widget.longitude!.toDouble(),
                    );
                    _markers.add(
                      Marker(
                        icon: _offlineCustomIcon!,
                        markerId: MarkerId(widget.number_plate),
                        position: center,
                        infoWindow: InfoWindow(title: widget.number_plate),
                      ),
                    );
                    return buildMap(isGeofence, center);
                  }

                  // Filter for moving and online vehicles
                  final movingVehicles = vehicles.where((v) {
                    return v.locationInfo.vehicleStatus.toLowerCase() == "moving" &&
                        (v.locationInfo.vin == widget.vin &&
                            v.locationInfo.tracker?.status!.toLowerCase() == "online");
                  }).toList();

                  if (movingVehicles.isNotEmpty) {
                    // Handle the first moving vehicle
                    final currentVehicle = movingVehicles[0];
                    final tracker = currentVehicle.locationInfo.tracker!;
                    final LatLng targetPosition = LatLng(
                      tracker.position!.latitude!.toDouble(),
                      tracker.position!.longitude!.toDouble(),
                    );

                    // Smoothly animate the vehicle's movement
                    _animateVehicleMovement(
                      markerId: widget.number_plate,
                      newPosition: targetPosition,
                    );

                    return buildMap(isGeofence, targetPosition);
                  }
                  // Handle case where no vehicles are moving
                  if (movingVehicles.isEmpty) {
                    final LatLng center = LatLng(widget.latitude!.toDouble(), widget.longitude!.toDouble());
                    _markers.clear(); // Clear existing markers if necessary
                    _markers.add(
                      Marker(
                        icon: _offlineCustomIcon!,
                        markerId: MarkerId(widget.number_plate),
                        position: center,
                        infoWindow: InfoWindow(title: widget.number_plate),
                      ),
                    );
                    return buildMap(isGeofence, center);
                  }
                  final LatLng center = LatLng(widget.latitude!.toDouble(), widget.longitude!.toDouble());

                  return buildMap(isGeofence, center); // Placeholder
                },
              );
            },
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            top: _isContainerVisible ? 20 : -200,
            left: 10,
            right: 10,
            child: buildInfoPanel(),
          ),
          if (_showShareRoute)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              top: MediaQuery.of(context).size.height / 2 -
                  (MediaQuery.of(context).size.height * 0.3),
              left: _isContainerVisible
                  ? 10
                  : MediaQuery.of(context)
                  .size
                  .width, // Starts off-screen and slides in
              right: _isContainerVisible
                  ? 10
                  : -MediaQuery.of(context)
                  .size
                  .width, // Adjust right as well for slide-in effect
              child: VehicleShareRoute(
                brand: widget.brand,
                model: widget.model,
                vin: widget.vin,
                token: widget.token,
                latitude: widget.latitude!,
                longitude: widget.longitude!,
                onClose: () {
                  setState(() {
                    _showShareRoute = false;
                  });
                },
              ),
            ),
          if (_showDashCam)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              top: _isContainerVisible ? 10 : -200,
              left: 10,
              right: 10,
              child: Material(
                  color: Colors.white
                      .withOpacity(0.9), // Background with slight opacity
                  borderRadius: BorderRadius.circular(10),
                  child: VehicleDashCam(
                    brand: widget.brand,
                    model: widget.model,
                    vin: widget.vin,
                    token: widget.token,
                    latitude: widget.latitude!,
                    longitude: widget.longitude!,
                    onClose: () {
                      setState(() {
                        _showDashCam = false;
                      });
                    },
                  )),
            ),
          if (_showVehicleOperation)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              // top: _isContainerVisible ? 20 : -200,
              left: 0,
              right: 0,
              bottom: _isContainerVisible ? 0 : -200,
              child: Material(
                color: Colors.white
                    .withOpacity(0.9), // Background with slight opacity
                borderRadius: BorderRadius.circular(10),
                child: VehicleOperations(
                    onClose: () {
                      setState(() {
                        _showVehicleOperation = false;
                        // _isContainerVisible = false; // Set visibility state
                      });
                    },
                    token: widget.token,
                    vin: widget.vin,
                    status: widget.status,
                    updated_at: widget.updated_at,
                    longitude: widget.longitude.toString(),
                    latitude: widget.latitude.toString(),
                    speed: widget.speed,
                    number_plate: widget.number_plate,
                    voltage_level: widget.voltage_level,
                    gsm_signal_strength: widget.gsm_signal_strength,
                    real_time_gps: widget.real_time_gps,
                    brand: widget.brand,
                    model: widget.model),
              ),
            ),
          if (_showDriverInfo)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              top: MediaQuery.of(context).size.height / 2 -
                  (MediaQuery.of(context).size.height * 0.3),
              left: _isContainerVisible
                  ? 10
                  : MediaQuery.of(context)
                  .size
                  .width, // Starts off-screen and slides in
              right: _isContainerVisible
                  ? 10
                  : -MediaQuery.of(context)
                  .size
                  .width, // Adjust right as well for slide-in effect
              child: DriverInfo(
                vin: widget.vin,
                name: widget.name!,
                phone: widget.phone!,
                email: widget.email!,
                number_plate: widget.number_plate,
                onClose: () {
                  setState(() {
                    _showDriverInfo = false;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  double _calculateBearing(LatLng start, LatLng end) {
    final startLat = start.latitude * pi / 180;
    final startLng = start.longitude * pi / 180;
    final endLat = end.latitude * pi / 180;
    final endLng = end.longitude * pi / 180;

    final dLng = endLng - startLng;
    final x = sin(dLng) * cos(endLat);
    final y = cos(startLat) * sin(endLat) - sin(startLat) * cos(endLat) * cos(dLng);
    final bearing = atan2(x, y) * 180 / pi;
    return (bearing + 360) % 360; // Normalize to 0-360
  }
  Future<void> _animateVehicleMovement({
    required String markerId,
    required LatLng newPosition,
  }) async {
    // Get the current marker (or fallback to a default position if none exists)
    final oldMarker = _markers.firstWhere(
          (marker) => marker.markerId.value == markerId,
      orElse: () => Marker(
        markerId: MarkerId(markerId),
        position: LatLng(widget.latitude!.toDouble(), widget.longitude!.toDouble()), // Fallback to initial position
      ),
    );

    LatLng oldPosition = oldMarker.position;

    // Calculate the number of steps for interpolation (e.g., 50 steps)
    int steps = _calculateSteps(oldPosition, newPosition);

    // Calculate the bearing (optional for marker rotation)
    double bearing = _calculateBearing(oldPosition, newPosition);

    if (_movingCustomIcon == null) {
      await _setOnlineCustomMarkerIcon(); // Ensure you have a custom icon
    }

    // Loop over the number of steps to animate the marker smoothly
    for (int i = 0; i <= steps; i++) {
      // Calculate the interpolation factor (0.0 to 1.0)
      double t = i / steps;

      // Get the interpolated position between old and new
      LatLng interpolatedPosition = _interpolatePosition(oldPosition, newPosition, t);

      // Remove old marker and add a new one with the interpolated position
      _markers.removeWhere((marker) => marker.markerId.value == markerId);
      _markers.add(
        Marker(
          markerId: MarkerId(markerId),
          position: interpolatedPosition,
          rotation: bearing, // Optional: Rotate the marker to face the direction of movement
          icon: _movingCustomIcon!,
          infoWindow: InfoWindow(title: widget.number_plate),
        ),
      );

      // Optionally animate the camera to follow the vehicle
      mapController.animateCamera(CameraUpdate.newLatLng(interpolatedPosition));

      // Trigger a UI rebuild after the position update
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });

      // Delay between steps to make the movement smooth (adjust the duration as necessary)
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  int _calculateSteps(LatLng oldPosition, LatLng newPosition) {
    // You can adjust the number of steps based on the distance or preference for smoothness
    return 50; // For example, 50 steps for smooth movement
  }

  LatLng _interpolatePosition(LatLng start, LatLng end, double t) {
    // Interpolate the latitude and longitude between start and end positions
    double lat = start.latitude + (end.latitude - start.latitude) * t;
    double lng = start.longitude + (end.longitude - start.longitude) * t;
    return LatLng(lat, lng);
  }


  Widget buildMap(bool isGeofence, LatLng center) {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;

        // Optionally move camera to Nigeria when map loads
        mapController.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: center, // Center of Nigeria
              zoom: 6.0, // Adjust zoom for a clear view of Nigeria
            ),
          ),
        );
      },
      initialCameraPosition: CameraPosition(
        target: center, // Center of Nigeria
        zoom: 6.0, // Adjust zoom for initialization
      ),
      markers: Set<Marker>.of(_markers),
      polygons: isGeofence && _geofencePolygon != null
          ? {_geofencePolygon!}
          : {}, // Toggle geofence
      // onCameraIdle: () {
      //   _fetchMarkersInViewport();
      // },
    );
  }

// // Build GoogleMap widget
//   Widget buildMap(LatLng center) {
//     return GoogleMap(
//       onMapCreated: (GoogleMapController controller) {
//         mapController = controller;
//       },
//       initialCameraPosition: CameraPosition(
//         target: center,
//         zoom: 11.0,
//       ),
//       markers: _markers,
//     );
//   }

  void _addGeofencePolygon(List<Coordinate> coordinates) {
    if (coordinates != null && coordinates.length > 3) {
      _geofencePolygon = Polygon(
        polygonId: const PolygonId("geofencePolygon"),
        points:
        coordinates.map((coord) => LatLng(coord.lat, coord.lng)).toList(),
        strokeColor: Colors.blue,
        strokeWidth: 2,
        fillColor: Colors.blue.withOpacity(0.2),
      );
    }
  }

  Widget buildInfoPanel() {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.number_plate,
                  style: AppStyle.cardTitle,
                ),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.cancel_outlined))
            ],
          ),
          Text(
            "Model: ${widget.brand} ${widget.model}",
            style: AppStyle.cardfooter,
          ),
          Text(
            "Vin: ${widget.vin}",
            style: AppStyle.cardfooter,
          ),
          buildIconRow(),
        ],
      ),
    );
  }

  // Separate icon row to keep code clean
  Widget buildIconRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildIcon(
            icon: Icons.cable,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => VehicleRouteHistory(
                widget.brand,
                widget.model,
                widget.vin,
                widget.latitude!.toDouble(),
                widget.longitude!.toDouble(),
                widget.token,
              ),
            )),
          ),
          buildIcon(
            icon: Icons.share_outlined,
            onTap: () {
              setState(() {
                //_showDashCam = !_showDashCam;
                _showShareRoute = !_showShareRoute; // Control visibility here
              });
            },
          ),
          buildIcon(
              icon: CupertinoIcons.photo_camera,
              onTap: () {
                setState(() {
                  _showDashCam = !_showDashCam;
                });
              }),
          buildIcon(
              icon: CupertinoIcons.rectangle_on_rectangle,
              onTap: () {
                setState(() {
                  _showVehicleOperation = !_showVehicleOperation;
                });
              }),
          buildIcon(
              icon: CupertinoIcons.person,
              onTap: () {
                setState(() {
                  _showDriverInfo = !_showDriverInfo;
                });
              }),
        ],
      ),
    );
  }

// Helper for reusable icon with spacing
  Widget buildIcon({required IconData icon, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: InkWell(
        onTap: onTap,
        child: Icon(icon),
      ),
    );
  }
}



// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: Stack(
//       children: [
//         FutureBuilder(
//           future: _initializationFuture,
//           builder: (context, snapshot) {
//             final isGeofence =
//                 context.watch<GeofenceProvider>().isGeofence;
//
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2.0,
//                   color: Colors.green,
//                 ),
//               );
//             } else if (snapshot.hasError) {
//               return const Center(
//                 child: Text(
//                   'Failed to fetch data',
//                   style: TextStyle(fontSize: 16, color: Colors.red),
//                 ),
//               );
//             }
//
//             BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
//               builder: (context, vehicles) {
//                 if (vehicles.isEmpty) {
//                   // Add a static marker if no vehicles are available
//                   final LatLng center = LatLng(
//                     widget.latitude!.toDouble(),
//                     widget.longitude!.toDouble(),
//                   );
//
//                   _markers.add(
//                     Marker(
//                       icon: _offlineCustomIcon!,
//                       markerId: MarkerId(widget.number_plate),
//                       position: center,
//                       infoWindow: InfoWindow(title: widget.number_plate),
//                     ),
//                   );
//                   return buildMap(isGeofence, center);
//                 }
//
//                 final movingVehicles = vehicles.where((v) {
//                   return v.locationInfo.vehicleStatus.toLowerCase() == "moving" &&
//                       (v.locationInfo.vin == widget.vin &&
//                           v.locationInfo.tracker?.status!.toLowerCase() == "online");
//                 }).toList();
//
//                 if (movingVehicles.isNotEmpty) {
//                   final currentVehicle = movingVehicles[0];
//                   final tracker = currentVehicle.locationInfo.tracker!;
//                   final LatLng targetPosition = LatLng(
//                     tracker.position!.latitude!.toDouble(),
//                     tracker.position!.longitude!.toDouble(),
//                   );
//
//                   // Smooth movement
//                   _animateVehicleMovement(
//                     markerId: widget.number_plate,
//                     newPosition: targetPosition,
//                   );
//
//                   return buildMap(isGeofence, targetPosition);
//                 } else {
//                   final LatLng center = LatLng(
//                     widget.latitude!.toDouble(),
//                     widget.longitude!.toDouble(),
//                   );
//
//                   _markers.add(
//                     Marker(
//                       icon: _offlineCustomIcon!,
//                       markerId: MarkerId(widget.number_plate),
//                       position: center,
//                       infoWindow: InfoWindow(title: widget.number_plate),
//                     ),
//                   );
//                   return buildMap(isGeofence, center);
//                 }
//               },
//             );
//
//
//
//             // return BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
//             //   listener: (context, vehicles) {
//             //     // Listener code if needed
//             //   },
//             //   child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
//             //       builder: (context, vehicles) {
//             //     if (vehicles.isEmpty) {
//             //       // _markers.clear();
//             //       final LatLng center = LatLng(
//             //         widget.latitude!.toDouble(),
//             //         widget.longitude!.toDouble(),
//             //       );
//             //       _markers.add(
//             //         Marker(
//             //           icon: _offlineCustomIcon!,
//             //           markerId: MarkerId(widget.number_plate),
//             //           position: center,
//             //           infoWindow: InfoWindow(
//             //             title: widget.number_plate
//             //           )
//             //         ),
//             //       );
//             //       return buildMap(isGeofence, center);
//             //     }
//             //
//             //     final movingVehicles = vehicles.where((v) {
//             //       return v.locationInfo.vehicleStatus.toLowerCase() == "moving" &&
//             //               (v.locationInfo.vin == widget.vin && v.locationInfo.tracker?.status!.toLowerCase() == "online");
//             //     }).toList();
//             //
//             //     if (movingVehicles.isNotEmpty) {
//             //       final currentVehicle = movingVehicles[0];
//             //       final tracker = currentVehicle.locationInfo.tracker!;
//             //
//             //       final startPosition = LatLng(widget.latitude!.toDouble(),
//             //           widget.longitude!.toDouble());
//             //
//             //
//             //
//             //       return buildMap(isGeofence, startPosition);
//             //
//             //     } else {
//             //       final LatLng center = LatLng(
//             //         widget.latitude!.toDouble(),
//             //         widget.longitude!.toDouble(),
//             //       );
//             //
//             //       _markers.add(
//             //         Marker(
//             //           icon: _offlineCustomIcon!,
//             //           markerId: MarkerId(widget.number_plate),
//             //           position: center,
//             //             infoWindow: InfoWindow(
//             //                 title: widget.number_plate
//             //             )
//             //         ),
//             //       );
//             //       return buildMap(isGeofence, center);
//             //     }
//             //   }),
//             // );
//           },
//         ),
//         AnimatedPositioned(
//           duration: const Duration(milliseconds: 500),
//           curve: Curves.easeInOut,
//           top: _isContainerVisible ? 20 : -200,
//           left: 10,
//           right: 10,
//           child: buildInfoPanel(),
//         ),
//         if (_showShareRoute)
//           AnimatedPositioned(
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//             top: MediaQuery.of(context).size.height / 2 -
//                 (MediaQuery.of(context).size.height * 0.3),
//             left: _isContainerVisible
//                 ? 10
//                 : MediaQuery.of(context)
//                     .size
//                     .width, // Starts off-screen and slides in
//             right: _isContainerVisible
//                 ? 10
//                 : -MediaQuery.of(context)
//                     .size
//                     .width, // Adjust right as well for slide-in effect
//             child: VehicleShareRoute(
//               brand: widget.brand,
//               model: widget.model,
//               vin: widget.vin,
//               token: widget.token,
//               latitude: widget.latitude!,
//               longitude: widget.longitude!,
//               onClose: () {
//                 setState(() {
//                   _showShareRoute = false;
//                 });
//               },
//             ),
//           ),
//         if (_showDashCam)
//           AnimatedPositioned(
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//             top: _isContainerVisible ? 10 : -200,
//             left: 10,
//             right: 10,
//             child: Material(
//                 color: Colors.white
//                     .withOpacity(0.9), // Background with slight opacity
//                 borderRadius: BorderRadius.circular(10),
//                 child: VehicleDashCam(
//                   brand: widget.brand,
//                   model: widget.model,
//                   vin: widget.vin,
//                   token: widget.token,
//                   latitude: widget.latitude!,
//                   longitude: widget.longitude!,
//                   onClose: () {
//                     setState(() {
//                       _showDashCam = false;
//                     });
//                   },
//                 )),
//           ),
//         if (_showVehicleOperation)
//           AnimatedPositioned(
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//             // top: _isContainerVisible ? 20 : -200,
//             left: 0,
//             right: 0,
//             bottom: _isContainerVisible ? 0 : -200,
//             child: Material(
//               color: Colors.white
//                   .withOpacity(0.9), // Background with slight opacity
//               borderRadius: BorderRadius.circular(10),
//               child: VehicleOperations(
//                   onClose: () {
//                     setState(() {
//                       _showVehicleOperation = false;
//                       // _isContainerVisible = false; // Set visibility state
//                     });
//                   },
//                   token: widget.token,
//                   vin: widget.vin,
//                   status: widget.status,
//                   updated_at: widget.updated_at,
//                   longitude: widget.longitude.toString(),
//                   latitude: widget.latitude.toString(),
//                   speed: widget.speed,
//                   number_plate: widget.number_plate,
//                   voltage_level: widget.voltage_level,
//                   gsm_signal_strength: widget.gsm_signal_strength,
//                   real_time_gps: widget.real_time_gps,
//                   brand: widget.brand,
//                   model: widget.model),
//             ),
//           ),
//         if (_showDriverInfo)
//           AnimatedPositioned(
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//             top: MediaQuery.of(context).size.height / 2 -
//                 (MediaQuery.of(context).size.height * 0.3),
//             left: _isContainerVisible
//                 ? 10
//                 : MediaQuery.of(context)
//                     .size
//                     .width, // Starts off-screen and slides in
//             right: _isContainerVisible
//                 ? 10
//                 : -MediaQuery.of(context)
//                     .size
//                     .width, // Adjust right as well for slide-in effect
//             child: DriverInfo(
//               vin: widget.vin,
//               name: widget.name!,
//               phone: widget.phone!,
//               email: widget.email!,
//               number_plate: widget.number_plate,
//               onClose: () {
//                 setState(() {
//                   _showDriverInfo = false;
//                 });
//               },
//             ),
//           ),
//       ],
//     ),
//   );
// }
//
// double _calculateDistance(LatLng start, LatLng end) {
//   return Geolocator.distanceBetween(
//     start.latitude,
//     start.longitude,
//     end.latitude,
//     end.longitude,
//   );
// }
//
//
// void _animateVehicleMovement({required String markerId, required LatLng newPosition,}) {
//   final oldMarker = _markers.firstWhere(
//         (marker) => marker.markerId.value == markerId,
//     orElse: () => null,
//   );
//
//   if (oldMarker != null) {
//     final oldPosition = oldMarker.position;
//
//     // Calculate bearing
//     double bearing = _calculateBearing(oldPosition, newPosition);
//
//     // Remove the old marker
//     _markers.remove(oldMarker);
//
//     // Add new marker with bearing and smooth movement
//     _markers.add(
//       Marker(
//         markerId: MarkerId(markerId),
//         position: newPosition,
//         rotation: bearing, // Add bearing for direction
//         icon: _movingVehicleIcon!,
//         infoWindow: InfoWindow(title: widget.number_plate),
//       ),
//     );
//
//     // Optionally animate the camera to follow the vehicle
//     mapController.animateCamera(
//       CameraUpdate.newLatLng(newPosition),
//     );
//
//     // Trigger a UI rebuild
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         setState(() {
//         });
//       }
//     });
//   }
// }


///

// class _VehicleRouteLastLocationState extends State<VehicleRouteLastLocation> {
//   late GoogleMapController mapController;
//   bool _isCustomIconSet =
//       false; // Track if the custom marker icon is already set
//   BitmapDescriptor? _offlineCustomIcon;
//   BitmapDescriptor? _movingCustomIcon;
//   late Future<void> _getAuthUserFuture;
//   final Set<Marker> _markers = {};
//   bool _isContainerVisible = false;
//   bool _showShareRoute = false;
//   bool _showDashCam = false;
//   bool _showVehicleOperation = false;
//   bool _showDriverInfo = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _getAuthUserFuture = _loadInitialData();
//     // Trigger the animation after a slight delay
//     Future.delayed(const Duration(milliseconds: 300), () {
//       setState(() {
//         _isContainerVisible = true;
//         _showShareRoute = false;
//       });
//     });
//     // Initialize Pusher after starting to load initial data
//   }
//
//   Future<void> _loadInitialData() async {
//     try {
//       await Future.wait([
//         // _getAuthUser(),
//         _setOfflineCustomMarkerIcon(),
//       ]);
//     } catch (e, stackTrace) {
//       print('Error during initialization: $e');
//       print("Stack trace: $stackTrace");
//     }
//   }
//
//   Future<void> _setOfflineCustomMarkerIcon() async {
//     try {
//       final iconSize = 15.0; // Adjust this size as needed
//
//       // Load and resize the image
//       final image = await BitmapDescriptor.fromAssetImage(
//         ImageConfiguration(
//             size: Size(iconSize, iconSize)), // Size of the marker icon
//         'assets/images/vehicle_map.png', // Your custom image path
//       );
//
//       setState(() {
//         _offlineCustomIcon = image; // Save the custom icon to use on the map
//       });
//     } catch (e) {
//       print('Error loading custom marker icon: $e');
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           FutureBuilder(
//               future: _getAuthUserFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(
//                       child: CircularProgressIndicator(
//                     strokeWidth: 2.0,
//                     color: Colors.green,
//                   ));
//                 } else if (snapshot.hasError) {
//                   return Center(
//                       child: Text(
//                     'Failed to fetch user data',
//                     style: AppStyle.cardfooter,
//                   ));
//                 } else {
///
//                   return FutureBuilder(
//                       future: _getAuthUserFuture,
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return const Center(
//                               child: CircularProgressIndicator(
//                             strokeWidth: 2.0,
//                             color: Colors.green,
//                           ));
//                         } else if (snapshot.hasError) {
//                           return const Center(
//                               child: Text('Failed to fetch user data'));
//                         } else {
//                           final LatLng _center = LatLng(
//                               widget.latitude!.toDouble(),
//                               widget.longitude!.toDouble());
//                           _markers.addAll([
//                             Marker(
//                                 icon: _offlineCustomIcon!,
//                                 markerId: MarkerId(widget.number_plate),
//                                 position: _center //LatLng(widget.latitude, widget.longitude),
//                                 ),
//                           ]);
//                           return Flexible(
//                             child: Container(
//                               margin: const EdgeInsets.only(top: 20.0),
//                               height: double.infinity, //MediaQuery.of(context).size.height * 0.4,
//                               child: GoogleMap(
//                                 onMapCreated: (GoogleMapController controller) {
//                                   mapController = controller;
//                                 },
//                                 initialCameraPosition: CameraPosition(
//                                   target: _center,
//                                   zoom: 11.0,
//                                 ),
//                                 markers: _markers,
//                                 // polygons: _geofencePolygon != null ? {_geofencePolygon!} : {},
//                                 // circles: {_geofenceCircle!}, // Show geofence circle
//                               ),
//                             ),
//                           );
///
//                         }
//                       });
//
///
//                   // return BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
//                   //   listener: (context, vehicles) {
//                   //     // Listener code if needed
//                   //   },
//                   //   child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
//                   //     builder: (context, vehicles) {
//                   //       if (vehicles.isEmpty) {
//                   //         _markers.clear();
//                   //         final LatLng _center = LatLng(
//                   //             widget.latitude!.toDouble(),
//                   //             widget.longitude!.toDouble());
//                   //         if (!_isCustomIconSet) {
//                   //           _setCustomMarkerIcon();
//                   //         }
//                   //
//                   //         _markers.addAll([Marker(
//                   //           icon: _customIcon!,
//                   //           markerId: MarkerId(widget.number_plate),
//                   //           position: _center,
//                   //           infoWindow: InfoWindow(title: widget.number_plate),
//                   //         )]);
//                   //         return buildMap(_center);
//                   //       }
//                   //
//                   //       final movingVehicles = vehicles.where((v) {
//                   //         return v.locationInfo.vehicleStatus == "Moving" &&
//                   //             v.locationInfo.vin == widget.vin;
//                   //       }).toList();
//                   //
//                   //       if (movingVehicles.isNotEmpty) {
//                   //         final currentVehicle = movingVehicles[0];
//                   //         final tracker = currentVehicle.locationInfo.tracker!;
//                   //         final startPosition = LatLng(
//                   //             widget.latitude!.toDouble(),
//                   //             widget.longitude!.toDouble());
//                   //         final endPosition = LatLng(
//                   //           tracker.position!.latitude ??
//                   //               widget.latitude!.toDouble(),
//                   //           tracker.position!.longitude ??
//                   //               widget.longitude!.toDouble(),
//                   //         );
//                   //
//                   //         final bearing =
//                   //             calculateBearing(startPosition, endPosition);
//                   //
//                   //         // _markers.clear();
//                   //         // Load moving icon only if it has not been set
//                   //         if (_movingCustomIcon == null) {
//                   //           _setOnlineCustomMarkerIcon();
//                   //         }
//                   //         _markers.add(Marker(
//                   //           icon: _movingCustomIcon!,
//                   //           markerId: MarkerId(widget.number_plate),
//                   //           position: endPosition,
//                   //           rotation: bearing, // Set bearing for the marker
//                   //           infoWindow: InfoWindow(title: widget.number_plate),
//                   //         ));
//                   //
//                   //         return buildMap(startPosition);
//                   //       }
//                   //
//                   //       return Center(
//                   //           child: Text('No vehicle data available', style: AppStyle.cardfooter,));
//                   //     },
//                   //   ),
//                   // );
//                 }
//               }),
///
//           AnimatedPositioned(
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//             top: _isContainerVisible ? 20 : -200,
//             left: 10,
//             right: 10,
//             child: buildInfoPanel(),
//           ),
//           if (_showShareRoute)
//             AnimatedPositioned(
//               duration: const Duration(milliseconds: 500),
//               curve: Curves.easeInOut,
//               top: MediaQuery.of(context).size.height / 2 -
//                   (MediaQuery.of(context).size.height * 0.3),
//               left: _isContainerVisible
//                   ? 10
//                   : MediaQuery.of(context)
//                       .size
//                       .width, // Starts off-screen and slides in
//               right: _isContainerVisible
//                   ? 10
//                   : -MediaQuery.of(context)
//                       .size
//                       .width, // Adjust right as well for slide-in effect
//               child: VehicleShareRoute(
//                 brand: widget.brand,
//                 model: widget.model,
//                 vin: widget.vin,
//                 token: widget.token,
//                 latitude: widget.latitude!,
//                 longitude: widget.longitude!,
//                 onClose: () {
//                   setState(() {
//                     _showShareRoute = false;
//                   });
//                 },
//               ),
//             ),
//           if (_showDashCam)
//             AnimatedPositioned(
//               duration: const Duration(milliseconds: 500),
//               curve: Curves.easeInOut,
//               top: _isContainerVisible ? 10 : -200,
//               left: 10,
//               right: 10,
//               child: Material(
//                   color: Colors.white
//                       .withOpacity(0.9), // Background with slight opacity
//                   borderRadius: BorderRadius.circular(10),
//                   child: VehicleDashCam(
//                     brand: widget.brand,
//                     model: widget.model,
//                     vin: widget.vin,
//                     token: widget.token,
//                     latitude: widget.latitude!,
//                     longitude: widget.longitude!,
//                     onClose: () {
//                       setState(() {
//                         _showDashCam = false;
//                       });
//                     },
//                   )),
//             ),
//           if (_showVehicleOperation)
//             AnimatedPositioned(
//               duration: const Duration(milliseconds: 500),
//               curve: Curves.easeInOut,
//               // top: _isContainerVisible ? 20 : -200,
//               left: 0,
//               right: 0,
//               bottom: _isContainerVisible ? 0 : -200,
//               child: Material(
//                 color: Colors.white
//                     .withOpacity(0.9), // Background with slight opacity
//                 borderRadius: BorderRadius.circular(10),
//                 child: VehicleOperations(
//                     onClose: () {
//                       setState(() {
//                         _showVehicleOperation = false;
//                         // _isContainerVisible = false; // Set visibility state
//                       });
//                     },
//                     token: widget.token,
//                     vin: widget.vin,
//                     status: widget.status,
//                     updated_at: widget.updated_at,
//                     longitude: widget.longitude.toString(),
//                     latitude: widget.latitude.toString(),
//                     speed: widget.speed,
//                     number_plate: widget.number_plate,
//                     voltage_level: widget.voltage_level,
//                     gsm_signal_strength: widget.gsm_signal_strength,
//                     real_time_gps: widget.real_time_gps,
//                     brand: widget.brand,
//                     model: widget.model),
//               ),
//             ),
//           if (_showDriverInfo)
//             AnimatedPositioned(
//               duration: const Duration(milliseconds: 500),
//               curve: Curves.easeInOut,
//               top: MediaQuery.of(context).size.height / 2 -
//                   (MediaQuery.of(context).size.height * 0.3),
//               left: _isContainerVisible
//                   ? 10
//                   : MediaQuery.of(context)
//                       .size
//                       .width, // Starts off-screen and slides in
//               right: _isContainerVisible
//                   ? 10
//                   : -MediaQuery.of(context)
//                       .size
//                       .width, // Adjust right as well for slide-in effect
//               child: DriverInfo(
//                 vin: widget.vin,
//                 name: widget.name!,
//                 phone: widget.phone!,
//                 email: widget.email!,
//                 number_plate: widget.number_plate,
//                 onClose: () {
//                   setState(() {
//                     _showDriverInfo = false;
//                   });
//                 },
//               ),
//             ),
///
//         ],
//       ),
//     );
//   }
//
//
//   Future<void> _setOnlineCustomMarkerIcon() async {
//     try {
//       final iconSize = 15.0; // Adjust this size as needed
//
//       // Load and resize the image
//       final image = await BitmapDescriptor.fromAssetImage(
//         ImageConfiguration(
//             size: Size(iconSize, iconSize)), // Size of the marker icon
//         'assets/images/green_moving_car_01.png', // Your custom image path
//       );
//
//       setState(() {
//         _movingCustomIcon = image; // Save the custom icon to use on the map
//       });
//     } catch (e) {
//       print('Error loading custom marker icon: $e');
//     }
//   }
//
//   // Function to calculate bearing
//   double calculateBearing(LatLng start, LatLng end) {
//     final lat1 = start.latitude * math.pi / 180;
//     final lon1 = start.longitude * math.pi / 180;
//     final lat2 = end.latitude * math.pi / 180;
//     final lon2 = end.longitude * math.pi / 180;
//
//     final dLon = lon2 - lon1;
//     final y = math.sin(dLon) * math.cos(lat2);
//     final x = math.cos(lat1) * math.sin(lat2) -
//         math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
//
//     final bearing = math.atan2(y, x) * 180 / math.pi;
//     return (bearing + 360) % 360; // Normalize to 0-360
//   }
//
// // Build GoogleMap widget
//   Widget buildMap(LatLng center) {
//     return Flexible(
//       child: Container(
//         margin: const EdgeInsets.only(top: 20.0),
//         height: double.infinity,
//         child: GoogleMap(
//           onMapCreated: (GoogleMapController controller) {
//             mapController = controller;
//           },
//           initialCameraPosition: CameraPosition(
//             target: center,
//             zoom: 11.0,
//           ),
//           markers: _markers,
//         ),
//       ),
//     );
//   }
//
//   // @override
//   // Widget build(BuildContext context) {
//   //   // final args =
//   //   //     ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
//   //   return Scaffold(
//   //       body: Stack(
//   //     children: [
//   //
//   //
//   //       FutureBuilder(
//   //           future: _getAuthUserFuture,
//   //           builder: (context, snapshot) {
//   //             if (snapshot.connectionState == ConnectionState.waiting) {
//   //               return const Center(child: CircularProgressIndicator());
//   //             } else if (snapshot.hasError) {
//   //               return const Center(child: Text('Failed to fetch user data'));
//   //             } else {
//   //               return BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
//   //                 listener: (context, vehicles) {
//   //                   // _updateVehicleCounts(vehicles);
//   //                   // setState(() {
//   //                   //   vehicles;
//   //                   // });
//   //                 },
//   //                 child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
//   //                   builder: (context, vehicles) {
//   //
//   //                     if (vehicles.isEmpty) {
//   //                       _markers.clear();
//   //                       final LatLng _center = LatLng(widget.latitude!.toDouble(),
//   //                           widget.longitude!.toDouble());
//   //                       _markers.addAll([
//   //                         Marker(
//   //                           icon: _customIcon!,
//   //                           markerId: MarkerId(widget.number_plate),
//   //                           position: LatLng(widget.latitude!.toDouble(), widget.longitude!.toDouble()),
//   //                           infoWindow: InfoWindow(title: widget.number_plate),
//   //                         ),
//   //                       ]);
//   //                       return Flexible(
//   //                         child: Container(
//   //                           margin: const EdgeInsets.only(top: 20.0),
//   //                           height: double
//   //                               .infinity, //MediaQuery.of(context).size.height * 0.4,
//   //                           child: GoogleMap(
//   //                             onMapCreated: (GoogleMapController controller) {
//   //                               mapController = controller;
//   //                             },
//   //                             initialCameraPosition: CameraPosition(
//   //                               target: _center,
//   //                               zoom: 11.0,
//   //                             ),
//   //                             markers: _markers,
//   //                             // polygons: _geofencePolygon != null ? {_geofencePolygon!} : {},
//   //                             // circles: {_geofenceCircle!}, // Show geofence circle
//   //                           ),
//   //                         ),
//   //                       );
//   //                     }
//   //
//   //                     final movingVehicles = vehicles.where((v) {
//   //                       return v.locationInfo.vehicleStatus == "Moving" &&
//   //                           v.locationInfo.vin == widget.vin;
//   //                     }).toList();
//   //                     final latitude = movingVehicles[0]
//   //                         .locationInfo
//   //                         .tracker!
//   //                         .position!
//   //                         .latitude;
//   //                     final longitude = movingVehicles[0]
//   //                         .locationInfo
//   //                         .tracker!
//   //                         .position!
//   //                         .longitude;
//   //                     final LatLng _center = LatLng(widget.latitude!.toDouble(),
//   //                         widget.longitude!.toDouble());
//   //                     _markers.clear();
//   //                     _markers.addAll([
//   //                       Marker(
//   //                         icon: _customIcon!,
//   //                         markerId: MarkerId(widget.number_plate),
//   //                         position: LatLng(
//   //                             latitude ?? widget.latitude!.toDouble(),
//   //                             longitude ?? widget.longitude!.toDouble()),
//   //                         infoWindow: InfoWindow(title: widget.number_plate),
//   //                       ),
//   //                     ]);
//   //
//   //                     return Flexible(
//   //                       child: Container(
//   //                         margin: const EdgeInsets.only(top: 20.0),
//   //                         height: double
//   //                             .infinity, //MediaQuery.of(context).size.height * 0.4,
//   //                         child: GoogleMap(
//   //                           onMapCreated: (GoogleMapController controller) {
//   //                             mapController = controller;
//   //                           },
//   //                           initialCameraPosition: CameraPosition(
//   //                             target: _center,
//   //                             zoom: 11.0,
//   //                           ),
//   //                           markers: _markers,
//   //                           // polygons: _geofencePolygon != null ? {_geofencePolygon!} : {},
//   //                           // circles: {_geofenceCircle!}, // Show geofence circle
//   //                         ),
//   //                       ),
//   //                     );
//   //                   },
//   //                 ),
//   //               );
//   //             }
//   //           }),
//   //
//   //       ///-------
//   //       // AnimatedPositioned(
//   //       //   duration: const Duration(milliseconds: 500),
//   //       //   curve: Curves.easeInOut,
//   //       //   top: _isContainerVisible ? 20 : -200,
//   //       //   left: 10,
//   //       //   right: 10,
//   //       //   child: Container(
//   //       //     // height: 200,
//   //       //     constraints: BoxConstraints(
//   //       //         maxHeight: MediaQuery.of(context).size.height * 0.15),
//   //       //     decoration: const BoxDecoration(
//   //       //       color: Colors.white,
//   //       //     ),
//   //       //     child: Column(
//   //       //       mainAxisAlignment: MainAxisAlignment.start,
//   //       //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       //       children: [
//   //       //         Row(
//   //       //           mainAxisAlignment: MainAxisAlignment.start,
//   //       //           children: [
//   //       //             Align(
//   //       //               alignment: Alignment.topLeft,
//   //       //               child: Text(widget.number_plate,
//   //       //                   style:
//   //       //                       AppStyle.pageTitle.copyWith(color: Colors.red)),
//   //       //             ),
//   //       //           ],
//   //       //         ),
//   //       //         Text("Model: ${widget.brand} ${widget.model}",
//   //       //             style: AppStyle.cardSubtitle
//   //       //                 .copyWith(color: Colors.grey[700])),
//   //       //         Text("Vin: ${widget.vin}",
//   //       //             style: AppStyle.cardSubtitle
//   //       //                 .copyWith(color: Colors.grey[700])),
//   //       //         // Text("Phone Number: ${widget.phone}",
//   //       //         //     style: AppStyle.cardSubtitle
//   //       //         //         .copyWith(color: Colors.grey[700])),
//   //       //         // Text("Location: ${widget.location}",
//   //       //         //     style: AppStyle.cardSubtitle
//   //       //         //         .copyWith(color: Colors.grey[700])),
//   //       //         Container(
//   //       //           padding: const EdgeInsets.symmetric(
//   //       //               vertical: 10.0, horizontal: 0.0),
//   //       //           decoration: BoxDecoration(
//   //       //             borderRadius: BorderRadius.circular(5),
//   //       //             color: Colors.white,
//   //       //           ),
//   //       //           child: Row(
//   //       //             mainAxisAlignment: MainAxisAlignment.start,
//   //       //             children: [
//   //       //               InkWell(
//   //       //                   onTap: () => Navigator.of(context).push(
//   //       //                       MaterialPageRoute(
//   //       //                           builder: (context) => VehicleRouteHistory(
//   //       //                               widget.brand,
//   //       //                               widget.model,
//   //       //                               widget.vin,
//   //       //                               widget.latitude!.toDouble(),
//   //       //                               widget.longitude!.toDouble(),
//   //       //                               widget.token))),
//   //       //                   child: const Icon(Icons.cable)),
//   //       //               const SizedBox(
//   //       //                 width: 20,
//   //       //               ),
//   //       //               InkWell(
//   //       //                   onTap: () {
//   //       //                     setState(() {
//   //       //                       showShareRoute = !showShareRoute;
//   //       //                     });
//   //       //
//   //       //                     // VehicleShareRoute
//   //       //                     //     .showVehicleShareDialog(
//   //       //                     //     context,
//   //       //                     //     widget.brand,
//   //       //                     //     widget.model,
//   //       //                     //     widget.vin,
//   //       //                     //     widget.token,
//   //       //                     //     widget.latitude,
//   //       //                     //     widget.longitude);
//   //       //                   },
//   //       //                   child: const Icon(Icons.share_outlined)),
//   //       //               const SizedBox(
//   //       //                 width: 20,
//   //       //               ),
//   //       //               InkWell(
//   //       //                   onTap: () {
//   //       //                     // VehicleLivePreview.showTopModal(context);
//   //       //                   },
//   //       //                   child: const Icon(CupertinoIcons.photo_camera)),
//   //       //               const SizedBox(
//   //       //                 width: 20,
//   //       //               ),
//   //       //               InkWell(
//   //       //                   onTap: () {
//   //       //                     // showModalBottomSheet(
//   //       //                     //     context: context,
//   //       //                     //     isDismissible: false,
//   //       //                     //     isScrollControlled: true,
//   //       //                     //     //useSafeArea: true,
//   //       //                     //     shape:
//   //       //                     //     const RoundedRectangleBorder(
//   //       //                     //       borderRadius:
//   //       //                     //       BorderRadius.only(
//   //       //                     //           topLeft: Radius
//   //       //                     //               .circular(20),
//   //       //                     //           topRight: Radius
//   //       //                     //               .circular(20)),
//   //       //                     //     ),
//   //       //                     //     builder: (BuildContext
//   //       //                     //     context) {
//   //       //                     //       return const VehicleRouteOperation();
//   //       //                     //     });
//   //       //                   },
//   //       //                   child: const Icon(
//   //       //                       CupertinoIcons.rectangle_on_rectangle)),
//   //       //               const SizedBox(
//   //       //                 width: 20,
//   //       //               ),
//   //       //               InkWell(
//   //       //                   onTap: () {
//   //       //                     // VehicleDriverDialog
//   //       //                     //     .showDriverDialog(
//   //       //                     //     context, name);
//   //       //                   },
//   //       //                   child: const Icon(CupertinoIcons.person)),
//   //       //             ],
//   //       //           ),
//   //       //         ),
//   //       //       ],
//   //       //     ),
//   //       //   ),
//   //       // ),
//   //
//   //       // Information panel
//   //       AnimatedPositioned(
//   //         duration: const Duration(milliseconds: 500),
//   //         curve: Curves.easeInOut,
//   //         top: _isContainerVisible ? 20 : -200,
//   //         left: 10,
//   //         right: 10,
//   //         child: buildInfoPanel(),
//   //       ),
//   //
//   //       if (_showShareRoute)
//   //         AnimatedPositioned(
//   //           duration: const Duration(milliseconds: 500),
//   //           curve: Curves.easeInOut,
//   //           top: MediaQuery.of(context).size.height / 2 -
//   //               (MediaQuery.of(context).size.height * 0.3),
//   //           left: _isContainerVisible
//   //               ? 10
//   //               : MediaQuery.of(context)
//   //                   .size
//   //                   .width, // Starts off-screen and slides in
//   //           right: _isContainerVisible
//   //               ? 10
//   //               : -MediaQuery.of(context)
//   //                   .size
//   //                   .width, // Adjust right as well for slide-in effect
//   //           child: VehicleShareRoute(
//   //             brand: widget.brand,
//   //             model: widget.model,
//   //             vin: widget.vin,
//   //             token: widget.token,
//   //             latitude: widget.latitude!,
//   //             longitude: widget.longitude!,
//   //             onClose: () {
//   //               setState(() {
//   //                 _showShareRoute = false;
//   //               });
//   //             },
//   //           ),
//   //         ),
//   //
//   //       if (_showDashCam)
//   //         AnimatedPositioned(
//   //           duration: const Duration(milliseconds: 500),
//   //           curve: Curves.easeInOut,
//   //           top: _isContainerVisible ? 10 : -200,
//   //           left: 10,
//   //           right: 10,
//   //           child: Material(
//   //               color: Colors.white
//   //                   .withOpacity(0.9), // Background with slight opacity
//   //               borderRadius: BorderRadius.circular(10),
//   //               child: VehicleDashCam(
//   //                 brand: widget.brand,
//   //                 model: widget.model,
//   //                 vin: widget.vin,
//   //                 token: widget.token,
//   //                 latitude: widget.latitude!,
//   //                 longitude: widget.longitude!,
//   //                 onClose: () {
//   //                   setState(() {
//   //                     _showDashCam = false;
//   //                   });
//   //                 },
//   //               )),
//   //         ),
//   //
//   //       if (_showVehicleOperation)
//   //         AnimatedPositioned(
//   //           duration: const Duration(milliseconds: 500),
//   //           curve: Curves.easeInOut,
//   //           // top: _isContainerVisible ? 20 : -200,
//   //           left: 0,
//   //           right: 0,
//   //           bottom: _isContainerVisible ? 0 : -200,
//   //           child: Material(
//   //             color: Colors.white
//   //                 .withOpacity(0.9), // Background with slight opacity
//   //             borderRadius: BorderRadius.circular(10),
//   //             child: VehicleOperations(
//   //               onClose: () {
//   //                 setState(() {
//   //                   _showVehicleOperation = false;
//   //                   // _isContainerVisible = false; // Set visibility state
//   //                 });
//   //               },
//   //             ),
//   //           ),
//   //         ),
//   //     ],
//   //   ));
//   // }
//

//   // Separate buildInfoPanel to keep code clean
///
//   Widget buildInfoPanel() {
//     return Container(
//       padding: const EdgeInsets.only(left: 10),
//       constraints: BoxConstraints(
//         maxHeight: MediaQuery.of(context).size.height * 0.16,
//       ),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   widget.number_plate,
//                   style: AppStyle.cardTitle,
//                 ),
//               ),
//               const Spacer(),
//               IconButton(
//                   onPressed: () => Navigator.pop(context),
//                   icon: const Icon(Icons.cancel_outlined))
//             ],
//           ),
//           Text(
//             "Model: ${widget.brand} ${widget.model}",
//             style: AppStyle.cardfooter,
//           ),
//           Text(
//             "Vin: ${widget.vin}",
//             style: AppStyle.cardfooter,
//           ),
//           buildIconRow(),
//         ],
//       ),
//     );
//   }
///
//   // Separate icon row to keep code clean
//   Widget buildIconRow() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(5),
//         color: Colors.white,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           buildIcon(
//             icon: Icons.cable,
//             onTap: () => Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => VehicleRouteHistory(
//                 widget.brand,
//                 widget.model,
//                 widget.vin,
//                 widget.latitude!.toDouble(),
//                 widget.longitude!.toDouble(),
//                 widget.token,
//               ),
//             )),
//           ),
//           buildIcon(
//             icon: Icons.share_outlined,
//             onTap: () {
//               setState(() {
//                 //_showDashCam = !_showDashCam;
//                 _showShareRoute = !_showShareRoute; // Control visibility here
//               });
//             },
//           ),
//           buildIcon(
//               icon: CupertinoIcons.photo_camera,
//               onTap: () {
//                 setState(() {
//                   _showDashCam = !_showDashCam;
//                 });
//               }),
//           buildIcon(
//               icon: CupertinoIcons.rectangle_on_rectangle,
//               onTap: () {
//                 setState(() {
//                   _showVehicleOperation = !_showVehicleOperation;
//                 });
//               }),
//           buildIcon(
//               icon: CupertinoIcons.person,
//               onTap: () {
//                 setState(() {
//                   _showDriverInfo = !_showDriverInfo;
//                 });
//               }),
//         ],
//       ),
//     );
//   }
//
// // Helper for reusable icon with spacing
//   Widget buildIcon({required IconData icon, required VoidCallback onTap}) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 20.0),
//       child: InkWell(
//         onTap: onTap,
//         child: Icon(icon),
//       ),
//     );
//   }
// }
