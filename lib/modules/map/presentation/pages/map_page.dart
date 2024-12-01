import 'dart:math';

import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/core/widgets/appBar.dart';
import 'package:ctntelematics/modules/map/domain/entitties/req_entities/token_req_entity.dart';
import 'package:ctntelematics/modules/map/domain/entitties/resp_entities/last_location_resp_entity.dart';
// import 'package:ctntelematics/modules/map/domain/entitties/resp_entities/last_location_resp_entity.dart';
import 'package:ctntelematics/modules/map/presentation/bloc/map_bloc.dart';
import 'package:ctntelematics/modules/map/presentation/widgets/vehicle_tooltip.dart';
import 'package:ctntelematics/modules/websocket/presentation/bloc/vehicle_location_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/usecase/provider_usecase.dart';
import '../../../../service_locator.dart';
import '../../../websocket/domain/entitties/resp_entities/vehicle_entity.dart';

class MapPage extends StatefulWidget {
  MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  BitmapDescriptor? _offlineCustomIcon;
  BitmapDescriptor? _onlineCustomIcon;

  final double _geofenceRadius = 5000;
  PrefUtils prefUtils = PrefUtils();
  Polygon? _geofencePolygon;
  Set<Marker> _markers = {};
  Circle? _geofenceCircle;
  String? first_name, last_name, middle_name, email, token, userId;
  Map<String, LatLng> _previousPositions = {};

  bool _isConnected = false;
  late Future<void> _getAuthUserFuture;
  bool isFetchingData = false;
  LatLngBounds? lastFetchedBounds;

  @override
  void initState() {
    super.initState();
    _getAuthUserFuture = _loadInitialData();
    _getAuthUser();
  }

  Future<void> _loadInitialData() async {
    try {
      await Future.wait([
        _setOfflineCustomMarkerIcon(),
      ]);
    } catch (e) {
      print('Error during initialization: $e');
    }
  }

  Future<void> _setOfflineCustomMarkerIcon() async {
    try {
      final iconSize = 15.0; // Adjust this size as needed

      // Load and resize the image
      final image = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
            size: Size(iconSize, iconSize)), // Size of the marker icon
        'assets/images/vehicle_map.png', // Your custom image path
      );

      setState(() {
        _offlineCustomIcon = image; // Save the custom icon to use on the map
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
        _onlineCustomIcon = image; // Save the custom icon to use on the map
      });
    } catch (e) {
      print('Error loading custom marker icon: $e');
    }
  }

  Future<void> _getAuthUser() async {
    try {
      List<String>? authUser = await prefUtils.getStringList('auth_user');
      if (authUser != null) {
        setState(() {
          first_name = authUser[0].isNotEmpty ? authUser[0] : null;
          last_name = authUser[1].isNotEmpty ? authUser[1] : null;
          middle_name = authUser[2].isNotEmpty ? authUser[2] : null;
          email = authUser[3].isNotEmpty ? authUser[3] : null;
          token = authUser[4].isNotEmpty ? authUser[4] : null;
          userId = authUser[5].isEmpty ? null : authUser[5];
        });
      }
    } catch (e) {
      print("Error fetching auth user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AnimatedAppBar(firstname: first_name ?? ""),
      body: FutureBuilder(
        future: _getAuthUserFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to fetch user data'));
          } else {
            final tokenReq = TokenReqEntity(
              token: token ?? '',
              contentType: 'application/json',
            );

            return BlocProvider(
              create: (_) =>
                  sl<LastLocationBloc>()..add(LastLocationEvent(tokenReq)),
              child: BlocConsumer<LastLocationBloc, MapState>(
                listener: (context, state) {
                  if (state is MapFailure) {
                    if (state.message.contains("Unauthenticated")) {
                      Navigator.pushNamed(context, "/login");
                    }
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  final isGeofence =
                      context.watch<GeofenceProvider>().isGeofence;

                  if (state is MapLoading) {
                    return Stack(
                      children: [
                        GoogleMap(
                          onMapCreated: (GoogleMapController controller) {
                            mapController = controller;
                          },

                          initialCameraPosition: const CameraPosition(
                            target: LatLng(9.0820, 8.6753), // Center of Nigeria
                            zoom: 6.0, // Adjust zoom for initialization
                          ),

                          markers: Set<Marker>.of(_markers),
                          polygons: isGeofence && _geofencePolygon != null
                              ? {_geofencePolygon!}
                              : {}, // Toggle geofence
                        ),
                        const Positioned(
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (state is GetLastLocationDone) {
                    // Add markers for all vehicles' last known location
                    _updateMarkers(state.resp, vehicles: []);

                    return BlocListener<VehicleLocationBloc,
                        List<VehicleEntity>>(
                      listener: (context, vehicles) {
                        // Handle additional logic if needed
                      },
                      child:
                          BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
                        builder: (context, vehicles) {
                          // Update markers for vehicles that have moved
                          _updateMarkers(state.resp, vehicles: vehicles);

                          return buildMap(isGeofence);
                        },
                      ),
                    );
                  } else {
                    return const Center(child: Text('No records found'));
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }

// Build GoogleMap widget
  Widget buildMap(bool isGeofence) {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;

        // Optionally move camera to Nigeria when map loads
        mapController.moveCamera(
          CameraUpdate.newCameraPosition(
            const CameraPosition(
              target: LatLng(9.0820, 8.6753), // Center of Nigeria
              zoom: 6.0, // Adjust zoom for a clear view of Nigeria
            ),
          ),
        );
      },
      initialCameraPosition: const CameraPosition(
        target: LatLng(9.0820, 8.6753), // Center of Nigeria
        zoom: 6.0, // Adjust zoom for initialization
      ),
      markers: Set<Marker>.of(_markers),
      polygons: isGeofence && _geofencePolygon != null
          ? {_geofencePolygon!}
          : {}, // Toggle geofence
      onCameraIdle: () {
        _fetchMarkersInViewport();
      },
    );
  }

// Update markers for all vehicles and moving vehicles
  void _updateMarkers(
    List<LastLocationRespEntity> allVehicles, {
    required List<VehicleEntity> vehicles,
  }) {
    _markers.clear(); // Clear existing markers
    // Add markers for all vehicles' last known locations
    for (var vehicle in allVehicles) {
      print('object-------------allVehicles');
      if (vehicle.vehicle != null &&
          vehicle.vehicle!.details?.last_location != null) {
        _addGeofencePolygon(vehicle.vehicle?.geofence?.coordinates);

        final currentPosition = LatLng(
          double.parse(
              vehicle.vehicle!.details!.last_location!.latitude.toString()),
          double.parse(
              vehicle.vehicle!.details!.last_location!.longitude.toString()),
        );

        // Cache the current position as the "previous position" if not already present
        final numberPlate = vehicle.vehicle!.details!.number_plate!;
        _previousPositions.putIfAbsent(numberPlate, () => currentPosition);
        // _setOfflineCustomMarkerIcon();
        _markers.add(
          Marker(
            icon: _offlineCustomIcon!, // Icon for stationary vehicles
            markerId: MarkerId(numberPlate),
            position: currentPosition,
            onTap: () {
              _showVehicleToolTip(vehicle);
            },
            infoWindow: InfoWindow(
              title: numberPlate,
            ),
          ),
        );
      }

    }

    // Update markers for vehicles that have moved
    for (var vehicle in vehicles) {
      print(">>>>>>>>>>>>>>>> moving vehicle block 01<<<<<<<<<<<<<<<<<<<<<");
      print('vehicle status: ${vehicle.locationInfo.vehicleStatus}');
      print('status: ${vehicle.locationInfo.tracker!.status}');
      if (vehicle.locationInfo.vehicleStatus == "Moving" &&
          vehicle.locationInfo.tracker!.position!.latitude != null &&
          vehicle.locationInfo.tracker!.position!.longitude != null) {
        _addGeofencePolygon2(vehicle.locationInfo.withinGeofence!.coordinates);

        print(">>>>>>>>>>>>>>>> moving vehicle block 02<<<<<<<<<<<<<<<<<<<<<");

        final currentPosition = LatLng(
          double.parse(
              vehicle.locationInfo.tracker!.position!.latitude.toString()),
          double.parse(
              vehicle.locationInfo.tracker!.position!.longitude.toString()),
        );

        final numberPlate = vehicle.locationInfo.numberPlate;

        // Retrieve the previous position for bearing calculation
        final previousPosition = _previousPositions[numberPlate];

        // Cache the current position as the new previous position
        _previousPositions[numberPlate] = currentPosition;

        // Calculate bearing if we have a previous position
        double? bearing;
        if (previousPosition != null) {
          bearing = _calculateBearing(previousPosition, currentPosition);
        }

        _setOnlineCustomMarkerIcon();

        _markers.add(
          Marker(
            icon: _onlineCustomIcon!, // Icon for moving vehicles
            markerId: MarkerId(numberPlate),
            position: currentPosition,
            onTap: () {
              _showVehicleToolTip(vehicle);
            },
            infoWindow: InfoWindow(
              title: numberPlate,
            ),
            rotation:
                bearing ?? 0, // Set bearing if available, otherwise default
          ),
        );
      }
      else {
        print('>>>>>>>>>> not moving here <<<<<<<<<<<<<<<<');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Vehicle is not moving', style: AppStyle.cardfooter,),
        //     backgroundColor: Colors.red,
        //   ),
        // );
      }
    }
  }

  double _calculateBearing(LatLng start, LatLng end) {
    final lat1 = _toRadians(start.latitude);
    final lon1 = _toRadians(start.longitude);
    final lat2 = _toRadians(end.latitude);
    final lon2 = _toRadians(end.longitude);

    final dLon = lon2 - lon1;

    final y = sin(dLon) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    final bearing = atan2(y, x);

    // Convert to degrees and normalize to 0-360
    return (_toDegrees(bearing) + 360) % 360;
  }

  double _toRadians(double degrees) {
    return degrees * pi / 180;
  }

  double _toDegrees(double radians) {
    return radians * 180 / pi;
  }

  void _showVehicleToolTip(vehicle) {
    VehicleToolTipDialog.showVehicleToolTipDialog(
      context,
      vehicle.vehicle!.details!.number_plate,
      vehicle.vehicle!.details!.vin,
      vehicle.vehicle!.address,
      vehicle.vehicle!.driver!.phone,
      vehicle.vehicle!.driver!.name,
      vehicle.vehicle!.details!.brand,
      vehicle.vehicle!.details!.model,
      token,
      vehicle.vehicle!.details!.last_location!.latitude,
      vehicle.vehicle!.details!.last_location!.longitude,
      vehicle.vehicle.details.last_location.voltage_level,
      vehicle.vehicle.details.last_location.speed,
      vehicle.vehicle.details.last_location.real_time_gps,
      vehicle.vehicle.details.last_location.status,
      vehicle.vehicle.details.last_location.gsm_signal_strength,
      vehicle.vehicle.details.last_location.updated_at,
      vehicle.vehicle!.driver!.email,
      vehicle.vehicle!.driver!.country,
      vehicle.vehicle!.driver!.licence_number,
    );
  }

  void _addGeofencePolygon(List<CenterEntity>? coordinates) {
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

  void _addGeofencePolygon2(List<Coordinate> coordinates) {
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

  Future<void> _fetchMarkersInViewport() async {
    if (isFetchingData) return;

    final bounds = await mapController.getVisibleRegion();

    if (_hasViewportChanged(bounds)) {
      setState(() => isFetchingData = true);

      final vehicles = await fetchVehiclesWithinBounds(bounds);
      setState(() {
        _markers.addAll(_createMarkersFromVehicles(vehicles));
        lastFetchedBounds = bounds;
        isFetchingData = false;
      });
    }
  }

  bool _hasViewportChanged(LatLngBounds newBounds) {
    if (lastFetchedBounds == null) return true;

    final padding = 0.02; // Tolerance
    return !(newBounds.southwest.latitude >=
            lastFetchedBounds!.southwest.latitude - padding &&
        newBounds.northeast.latitude <=
            lastFetchedBounds!.northeast.latitude + padding &&
        newBounds.southwest.longitude >=
            lastFetchedBounds!.southwest.longitude - padding &&
        newBounds.northeast.longitude <=
            lastFetchedBounds!.northeast.longitude + padding);
  }

  Set<Marker> _createMarkersFromVehicles(
      List<LastLocationRespEntity> vehicles) {
    return vehicles.map((data) {
      return Marker(
        markerId: MarkerId(data.vehicle!.details!.number_plate!),
        position: LatLng(
            double.parse(data.vehicle!.details!.last_location!.latitude!),
            double.parse(data.vehicle!.details!.last_location!.longitude!)),
        icon: _offlineCustomIcon!,
        onTap: () {
          _showVehicleToolTip(data);
        },
      );
    }).toSet();
  }

  Future<List<LastLocationRespEntity>> fetchVehiclesWithinBounds(
      LatLngBounds bounds) async {
    return [];
    // Replace with actual API call to fetch vehicles within the bounds
  }


}
// Widget handleLocationUpdate(){
//   return  BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
//     builder: (context, vehicles) {
//       if (vehicles.isEmpty) {
//         return Container();
//       }
//       return Container();
//     },
//   );
// }
///
//   void _updateMarkers(List<LastLocationRespEntity> allVehicles, {required List<VehicleEntity> vehicles}) {
//     _markers.clear(); // Clear existing markers
//
//     // Add markers for all vehicles' last known locations
//     for (var vehicle in allVehicles) {
//       if (vehicle.vehicle != null &&
//           vehicle.vehicle!.details?.last_location != null) {
//         _addGeofencePolygon(vehicle.vehicle?.geofence?.coordinates);
//         _markers.add(
//           Marker(
//             icon: _customIcon!, // Icon for stationary vehicles
//             markerId: MarkerId(vehicle.vehicle!.details!.number_plate!),
//             position: LatLng(
//               double.parse(vehicle.vehicle!.details!.last_location!.latitude.toString()),
//               double.parse(vehicle.vehicle!.details!.last_location!.longitude.toString()),
//             ),
//             onTap: () {
//               _showVehicleToolTip(vehicle);
//             },
//             infoWindow: InfoWindow(
//               title: vehicle.vehicle!.details!.number_plate!,
//             ),
//           ),
//         );
//       }
//     }
//
//     // Update markers for vehicles that have moved
//     for (var vehicle in vehicles) {
//       if (vehicle.locationInfo.vehicleStatus == "Moving" &&
//           vehicle.locationInfo.tracker!.position!.latitude != null &&
//           vehicle.locationInfo.tracker!.position!.longitude != null) {
//         _addGeofencePolygon2(vehicle.locationInfo.withinGeofence!.coordinates);
//         _markers.add(
//           Marker(
//             icon: _customIcon!, // Icon for moving vehicles
//             markerId: MarkerId(vehicle.locationInfo.numberPlate),
//             position: LatLng(
//               double.parse(vehicle.locationInfo.tracker!.position!.latitude.toString()),
//               double.parse(vehicle.locationInfo.tracker!.position!.longitude.toString()),
//             ),
//             onTap: () {
//               _showVehicleToolTip(vehicle);
//             },
//             infoWindow: InfoWindow(
//               title: vehicle.locationInfo.numberPlate,
//             ),
//           ),
//         );
//       }
//     }
//   }

///--------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AnimatedAppBar(firstname: first_name ?? ""),
//       body: FutureBuilder(
//         future: _getAuthUserFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(child: Text('Failed to fetch user data'));
//           } else {
//             final tokenReq = TokenReqEntity(
//               token: token ?? '',
//               contentType: 'application/json',
//             );
//
//             return BlocProvider(
//               create: (_) =>
//               sl<LastLocationBloc>()..add(LastLocationEvent(tokenReq)),
//               child: BlocConsumer<LastLocationBloc, MapState>(
//                 listener: (context, state) {
//                   if (state is MapFailure) {
//                     Navigator.pushNamed(context, "/login");
//                     ScaffoldMessenger.of(context)
//                         .showSnackBar(SnackBar(content: Text(state.message)));
//                   }
//                 },
//                 builder: (context, state) {
//                   final isGeofence =
//                    context.watch<GeofenceProvider>().isGeofence;
//
//                   if (state is MapLoading) {
//                     return Stack(
//                       children: [
//                         GoogleMap(
//                           onMapCreated: (GoogleMapController controller) {
//                             mapController = controller;
//                           },
//                           initialCameraPosition: const CameraPosition(
//                             target: LatLng(0.0, 20.0), // Center of Africa
//                             zoom: 3.0, // Broad view of Africa
//                           ),
//                           markers: Set<Marker>.of(_markers),
//                           polygons: isGeofence && _geofencePolygon != null
//                               ? {_geofencePolygon!}
//                               : {}, // Toggle geofence
//                         ),
//                         const Positioned(
//                           child: Center(
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2.0,
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   } else if (state is GetLastLocationDone) {
//                     _markers.clear(); // Clear previous markers
//
//                     return BlocListener<VehicleLocationBloc,
//                         List<VehicleEntity>>(
//                       listener: (context, vehicles) {
//                         // You can handle additional logic here if needed
//                       },
//                       child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
//                         builder: (context, vehicles) {
//                           if (vehicles.isEmpty) {
//                             _addVehicleMarkers(state.resp, vehicles);
//                           }
//
//                           final movingVehicles = vehicles.where((v) {
//                             return v.locationInfo.vehicleStatus == "Moving";
//                           }).toList();
//
//                           _addVehicleMarkers(state.resp, vehicles); // Show all vehicles
//                           _addVehicleMarkers(state.resp, movingVehicles); // Show moving vehicles
//
//                           return buildMap(isGeofence); // Rebuild the map
//                         },
//                       ),
//                     );
//                   } else {
//                     return const Center(child: Text('No records found'));
//                   }
//                 },
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
//
// // Build GoogleMap widget
//   Widget buildMap(bool isGeofence) {
//     return GoogleMap(
//       onMapCreated: (GoogleMapController controller) {
//         mapController = controller;
//
//         // Optionally move camera to Africa when map loads
//         mapController.moveCamera(
//           CameraUpdate.newCameraPosition(
//             const CameraPosition(
//               target: LatLng(0.0, 20.0), // Center of Africa
//               zoom: 3.0, // Broad view of Africa
//             ),
//           ),
//         );
//       },
//       initialCameraPosition: const CameraPosition(
//         target: LatLng(0.0, 20.0), // Center of Africa
//         zoom: 3.0, // Broad view of Africa
//       ),
//       markers: Set<Marker>.of(_markers),
//       polygons: isGeofence && _geofencePolygon != null
//           ? {_geofencePolygon!}
//           : {}, // Toggle geofence
//       onCameraIdle: () {
//         _fetchMarkersInViewport();
//       },
//     );
//   }
//
//   void _addVehicleMarkers(
//       List<LastLocationRespEntity> vehicles,
//       List<VehicleEntity> movingVehicles,
//       ) {
//     _markers.clear(); // Clear existing markers
//     for (var vehicle in vehicles) {
//       if (vehicle.vehicle != null &&
//           vehicle.vehicle!.details?.last_location != null) {
//         _addGeofencePolygon(vehicle.vehicle?.geofence?.coordinates);
//
//         // For all vehicles
//         _markers.add(
//           Marker(
//             icon: _customIcon!,
//             markerId: MarkerId(vehicle.vehicle!.details!.number_plate!),
//             position: LatLng(
//               double.parse(
//                   vehicle.vehicle!.details!.last_location!.latitude.toString()),
//               double.parse(
//                   vehicle.vehicle!.details!.last_location!.longitude
//                       .toString()),
//             ),
//             onTap: () {
//               _showVehicleToolTip(vehicle);
//             },
//             infoWindow:
//             InfoWindow(title: vehicle.vehicle!.details!.number_plate!),
//           ),
//         );
//       }
//     }
//
//     // For moving vehicles, you can use a different icon or color if needed
//     for (var vehicle in movingVehicles) {
//       if (vehicle.locationInfo != null &&
//           vehicle.locationInfo.vehicleStatus != null) {
//         _markers.add(
//           Marker(
//             icon: _customIcon!, // Use a different icon for moving vehicles
//             markerId: MarkerId(vehicle.locationInfo.numberPlate),
//             position: LatLng(
//               double.parse(
//                   vehicle.locationInfo.tracker!.position!.latitude.toString()),
//               double.parse(
//                   vehicle.locationInfo.tracker!.position!.longitude.toString()),
//             ),
//             onTap: () {
//               _showVehicleToolTip(vehicle);
//             },
//             infoWindow: InfoWindow(title: vehicle.locationInfo.numberPlate),
//           ),
//         );
//       }
//     }
//   }

///-------
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AnimatedAppBar(firstname: first_name ?? ""),
//     body: FutureBuilder(
//       future: _getAuthUserFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return const Center(child: Text('Failed to fetch user data'));
//         } else {
//           final tokenReq = TokenReqEntity(
//             token: token ?? '',
//             contentType: 'application/json',
//           );
//
//           return BlocProvider(
//             create: (_) =>
//                 sl<LastLocationBloc>()..add(LastLocationEvent(tokenReq)),
//             child: BlocConsumer<LastLocationBloc, MapState>(
//               listener: (context, state) {
//                 if (state is MapFailure) {
//                   Navigator.pushNamed(context, "/login");
//                   ScaffoldMessenger.of(context)
//                       .showSnackBar(SnackBar(content: Text(state.message)));
//                 }
//               },
//               builder: (context, state) {
//                 final isGeofence =
//                     context.watch<GeofenceProvider>().isGeofence;
//
//                 if (state is MapLoading) {
//                   return Stack(
//                     children: [
//                       GoogleMap(
//                         onMapCreated: (GoogleMapController controller) {
//                           mapController = controller;
//                         },
//                         initialCameraPosition: const CameraPosition(
//                           target: LatLng(0.0, 20.0), // Center of Africa
//                           zoom: 3.0, // Broad view of Africa
//                         ),
//                         markers: Set<Marker>.of(_markers),
//                         polygons: isGeofence && _geofencePolygon != null
//                             ? {_geofencePolygon!}
//                             : {}, // Toggle geofence
//                       ),
//                       const Positioned(
//                         child: Center(
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2.0,
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 } else if (state is GetLastLocationDone) {
//                   _markers.clear(); // Clear previous markers
//
//                   return BlocListener<VehicleLocationBloc,
//                       List<VehicleEntity>>(
//                     listener: (context, vehicles) {
//                     },
//                     child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
//                       builder: (context, vehicles) {
//
//
//                         if(vehicles.isEmpty){
//                           _addVehicleMarkers(state.resp, vehicles);
//                         }
//
//                         final movingVehicles = vehicles.where((v) {
//                           return v.locationInfo.vehicleStatus == "Moving";
//                         }).toList();
//                         _addVehicleMarkers(state.resp, movingVehicles);
//                         return buildMap(isGeofence);
//                       },
//                     ),
//                   );
//
//                   // Add markers for current view
//                 } else {
//                   return const Center(child: Text('No records found'));
//                 }
//               },
//             ),
//           );
//         }
//       },
//     ),
//   );
// }
//
// // Build GoogleMap widget
// Widget buildMap(bool isGeofence) {
//   return GoogleMap(
//     onMapCreated: (GoogleMapController controller) {
//       mapController = controller;
//
//       // Optionally move camera to Africa when map loads
//       mapController.moveCamera(
//         CameraUpdate.newCameraPosition(
//           const CameraPosition(
//             target: LatLng(0.0, 20.0), // Center of Africa
//             zoom: 3.0, // Broad view of Africa
//           ),
//         ),
//       );
//     },
//     initialCameraPosition: const CameraPosition(
//       target: LatLng(0.0, 20.0), // Center of Africa
//       zoom: 3.0, // Broad view of Africa
//     ),
//     markers: Set<Marker>.of(_markers),
//     polygons: isGeofence && _geofencePolygon != null
//         ? {_geofencePolygon!}
//         : {}, // Toggle geofence
//     onCameraIdle: () {
//       _fetchMarkersInViewport();
//     },
//   );
// }
//
// void _addVehicleMarkers(List<LastLocationRespEntity> vehicles, List<VehicleEntity> movingVehicles,) {
//   for (var vehicle in vehicles) {
//     if ((vehicle.vehicle != null &&
//             vehicle.vehicle!.details?.last_location != null) ) {
//
//       _addGeofencePolygon(vehicle.vehicle?.geofence?.coordinates);
//       _markers.add(
//         Marker(
//           icon: _customIcon!,
//           markerId: MarkerId(vehicle.vehicle!.details!.number_plate!),
//           position: LatLng(
//             double.parse(
//                 vehicle.vehicle!.details!.last_location!.latitude.toString()),
//             double.parse(
//                 vehicle.vehicle!.details!.last_location!.longitude
//                     .toString()),
//           ),
//           onTap: () {
//             _showVehicleToolTip(vehicle);
//           },
//           infoWindow:
//               InfoWindow(title: vehicle.vehicle!.details!.number_plate!),
//         ),
//       );
//     }
//   }
// }
///------------ paginated ----------------------
// class _MapPageState extends State<MapPage> {
//   late GoogleMapController mapController;
//   BitmapDescriptor? _customIcon;
//   Set<Marker> _markers = {};
//   Polygon? _geofencePolygon;
//
//   // Pagination state
//   int currentPage = 1;
//   bool isFetchingData = false;
//   bool hasMoreData = true; // To track if more data can be fetched
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//   }
//
//   Future<void> _initializeData() async {
//     await _setCustomMarkerIcon();
//     _fetchMarkersInViewport(resetPagination: true); // Initial fetch
//   }
//
//   Future<void> _setCustomMarkerIcon() async {
//     _customIcon = await BitmapDescriptor.fromAssetImage(
//       const ImageConfiguration(size: Size(24, 24)),
//       'assets/images/vehicle_map.png',
//     );
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Vehicle Map')),
//       body: BlocConsumer<LastLocationBloc, MapState>(
//         listener: (context, state) {
//           if (state is MapFailure) {
//             Navigator.pushNamed(context, "/login");
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(SnackBar(content: Text(state.message)));
//           }
//         },
//         builder: (context, state) {
//           if (state is MapLoading && _markers.isEmpty) {
//             return Center(child: CircularProgressIndicator());
//           } else if (state is GetLastLocationDone) {
//             _handleNewMarkers(state.resp);
//
//             return GoogleMap(
//               onMapCreated: (GoogleMapController controller) {
//                 mapController = controller;
//               },
//               initialCameraPosition: const CameraPosition(
//                 target: LatLng(6.5480551, 3.2839595),
//                 zoom: 11.0,
//               ),
//               markers: _markers,
//               polygons: _geofencePolygon != null ? {_geofencePolygon!} : {},
//               onCameraIdle: () => _fetchMarkersInViewport(),
//             );
//           } else {
//             return const Center(child: Text('No records found'));
//           }
//         },
//       ),
//     );
//   }
//
//   // Function to handle and append new markers from paginated API response
//   void _handleNewMarkers(List<LastLocationRespEntity> vehicles) {
//     if (vehicles.isEmpty) {
//       setState(() => hasMoreData = false); // No more data to fetch
//       return;
//     }
//
//     // Add new markers to the existing set
//     final newMarkers = vehicles.map((vehicle) {
//       if (vehicle.vehicle != null && vehicle.vehicle!.details?.last_location != null) {
//         return Marker(
//           icon: _customIcon!,
//           markerId: MarkerId(vehicle.vehicle!.id.toString()),
//           position: LatLng(
//             double.parse(vehicle.vehicle!.details!.last_location!.latitude.toString()),
//             double.parse(vehicle.vehicle!.details!.last_location!.longitude.toString()),
//           ),
//           infoWindow: InfoWindow(title: vehicle.vehicle!.details!.vin),
//         );
//       }
//       return null;
//     }).whereType<Marker>().toSet();
//
//     setState(() {
//       _markers.addAll(newMarkers); // Append new markers
//       currentPage++; // Increment page for the next request
//       isFetchingData = false; // Reset fetching state
//     });
//   }
//
//   // Fetch markers for the current map view with pagination
//   Future<void> _fetchMarkersInViewport({bool resetPagination = false}) async {
//     if (isFetchingData || !hasMoreData) return;
//
//     if (resetPagination) {
//       currentPage = 1;
//       hasMoreData = true;
//       _markers.clear();
//     }
//
//     setState(() => isFetchingData = true);
//
//     // Fetch paginated vehicle data
//     context.read<LastLocationBloc>().add(
//       LastLocationEvent(tokenReq, page: currentPage),
//     );
//   }
// }
///---------------------------------------------
///------
// class _MapPageState extends State<MapPage> {
//   late GoogleMapController mapController;
//   BitmapDescriptor? _customIcon;
//
//   final double _geofenceRadius = 5000;
//   PrefUtils prefUtils = PrefUtils();
//   Polygon? _geofencePolygon;
//   // late Echo echo;
//   // late Echo<PUSHER.PusherClient, PusherChannel> echo;
//
//   Set<Marker> _markers = {};
//   Circle? _geofenceCircle;
//   String? first_name, last_name, middle_name, email, token, userId;
//   // Track connection status
//   bool _isConnected = false;
//   // Cache the future to ensure it's only called once
//   late Future<void> _getAuthUserFuture;
//   bool isFetchingData = false;
//   LatLngBounds? lastFetchedBounds;
//   // late PusherService pusherService;
//   @override
//   void initState() {
//     super.initState();
//     _getAuthUserFuture = _loadInitialData();
//     _getAuthUser();
//   }
//
//   Future<void> _loadInitialData() async {
//     try {
//       await Future.wait([
//         _setCustomMarkerIcon(),
//       ]);
//     } catch (e, stackTrace) {
//       print('Error during initialization: $e');
//       print("Stack trace: $stackTrace");
//     }
//   }
//
//   ///--------------------
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
//   Future<void> _getAuthUser() async {
//     try {
//       List<String>? authUser = await prefUtils.getStringList('auth_user');
//       if (authUser != null) {
//         setState(() {
//           first_name = authUser[0].isNotEmpty ? authUser[0] : null;
//           last_name = authUser[1].isNotEmpty ? authUser[1] : null;
//           middle_name = authUser[2].isNotEmpty ? authUser[2] : null;
//           email = authUser[3].isNotEmpty ? authUser[3] : null;
//           token = authUser[4].isNotEmpty ? authUser[4] : null;
//           userId = authUser[5].isEmpty
//               ? null
//               : authUser[5]; // assuming userId is at index 5
//         });
//         print("Auth user data fetched successfully.");
//         // Register PusherService with token and userId dynamically
//         if (token != null) {
//           // if (!sl.isRegistered<PusherService>()) {
//           //   print("not registered anywhere");
//           //   sl.registerSingleton<PusherService>(PusherService(token!, userId!));
//           //   // sl.registerFactory<PusherService>(() => PusherService(token!, userId!));
//           //   // Retrieve the PusherService and initialize only if it hasn’t been already
//           //   final pusherService = sl<PusherService>();
//           //   pusherService.initializePusher();
//           // }
//         }
//       } else {
//         print("Auth user data is null.");
//       }
//     } catch (e) {
//       print("Error fetching auth user data: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AnimatedAppBar(firstname: first_name ?? ""),
//       body: FutureBuilder(
//         future: _getAuthUserFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(child: Text('Failed to fetch user data'));
//           } else {
//             final tokenReq = TokenReqEntity(
//               token: token ?? '',
//               contentType: 'application/json',
//             );
//
//             return BlocProvider(
//               create: (_) =>
//                   sl<LastLocationBloc>()..add(LastLocationEvent(tokenReq)),
//               child: BlocConsumer<LastLocationBloc, MapState>(
//                 listener: (context, state) {
//                   if (state is MapFailure) {
//                     Navigator.pushNamed(context, "/login");
//                     ScaffoldMessenger.of(context)
//                         .showSnackBar(SnackBar(content: Text(state.message)));
//                   }
//                 },
//                 builder: (context, state) {
//                   if (state is MapLoading) {
//                     return Stack(
//                       children: [
//                         GoogleMap(
//                           onMapCreated: (GoogleMapController controller) {
//                             mapController = controller;
//                           },
//                           initialCameraPosition: const CameraPosition(
//                             target: LatLng(6.5480551, 3.2839595),
//                             zoom: 11.0,
//                           ),
//                           markers: Set<Marker>.of(_markers),
//                           polygons:
//                               _geofencePolygon != null ? {_geofencePolygon!} : {},
//                         ),
//                         const Positioned(
//                             child: Center(child: CircularProgressIndicator()))
//                       ],
//                     );
//                   } else if (state is GetLastLocationDone) {
//                     // Clear previous markers and polygons before adding new ones
//                     _markers.clear();
//                     _addVehicleMarkers(state.resp);
//                     // Ensure coordinates are valid before adding the geofence polygon
//                     var geofenceCoordinates =
//                         state.resp[0].vehicle!.geofence?.coordinates;
//                     if (geofenceCoordinates != null &&
//                         geofenceCoordinates.isNotEmpty) {
//                       _addGeofencePolygon(geofenceCoordinates);
//                     }
//
//                     return GoogleMap(
//                       onMapCreated: (GoogleMapController controller) {
//                         mapController = controller;
//                       },
//                       initialCameraPosition: const CameraPosition(
//                         target: LatLng(6.5480551, 3.2839595),
//                         zoom: 11.0,
//                       ),
//                       markers: Set<Marker>.of(_markers),
//                       polygons:
//                           _geofencePolygon != null ? {_geofencePolygon!} : {},
//                       onCameraIdle: () {
//                         // Fetch markers only if the viewport has changed significantly
//                         _fetchMarkersInViewport();
//                       },
//                     );
//                   } else {
//                     return const Center(child: Text('No records found'));
//                   }
//                 },
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
//
// // Helper method to add vehicle markers to the map
//   void _addVehicleMarkers(List<LastLocationRespEntity> vehicles) {
//     for (var vehicle in vehicles) {
//       if (vehicle.vehicle != null &&
//           vehicle.vehicle!.details?.last_location != null) {
//         _markers.add(
//           Marker(
//             icon: _customIcon!,
//             markerId: MarkerId(vehicle.vehicle!.id.toString()),
//             position: LatLng(
//               double.parse(
//                   vehicle.vehicle!.details!.last_location!.latitude.toString()),
//               double.parse(vehicle.vehicle!.details!.last_location!.longitude
//                   .toString()),
//             ),
//             onTap: () {
//               _showVehicleToolTip(vehicle);
//             },
//             infoWindow: InfoWindow(title: vehicle.vehicle!.details!.vin),
//           ),
//         );
//       }
//     }
//   }
//
// // Helper method to display tooltip dialog for a vehicle
//   void _showVehicleToolTip(vehicle) {
//     VehicleToolTipDialog.showVehicleToolTipDialog(
//       context,
//       vehicle.vehicle!.details!.number_plate,
//       vehicle.vehicle!.details!.vin,
//       vehicle.vehicle!.address,
//       vehicle.vehicle!.driver!.phone,
//       vehicle.vehicle!.driver!.name,
//       vehicle.vehicle!.details!.brand,
//       vehicle.vehicle!.details!.model,
//       token,
//       vehicle.vehicle!.details!.last_location!.latitude,
//       vehicle.vehicle!.details!.last_location!.longitude,
//     );
//   }
//
//   void _addGeofencePolygon(List<CenterEntity>? coordinates) {
//     if (coordinates != null && coordinates.length > 3) {
//       _geofencePolygon = Polygon(
//         polygonId: const PolygonId("geofencePolygon"),
//         points: coordinates.map((coord) => LatLng(coord.lat, coord.lng)).toList(),
//         strokeColor: Colors.blue,
//         strokeWidth: 2,
//         fillColor: Colors.blue.withOpacity(0.2),
//       );
//     }
//   }
//
//   Future<void> _fetchMarkersInViewport() async {
//     if (isFetchingData) return;
//
//     final bounds = await mapController.getVisibleRegion();
//
//     // Check if the new bounds are different enough from the last fetched bounds
//     if (_hasViewportChanged(bounds)) {
//       setState(() => isFetchingData = true);
//
//       // Replace this with your actual API call to fetch vehicles within bounds
//       final vehicles = await fetchVehiclesWithinBounds(bounds);
//
//       // Clear existing markers and add new markers
//       setState(() {
//         _markers.clear();
//         _markers.addAll(_createMarkersFromVehicles(vehicles));
//         lastFetchedBounds = bounds;
//         isFetchingData = false;
//       });
//     }
//   }
//
//   bool _hasViewportChanged(LatLngBounds newBounds) {
//     if (lastFetchedBounds == null) return true;
//
//     // Compare new bounds with the last fetched bounds (add padding for tolerance)
//     final padding = 0.02; // Adjust based on desired sensitivity
//     return !(newBounds.southwest.latitude >=
//             lastFetchedBounds!.southwest.latitude - padding &&
//         newBounds.northeast.latitude <=
//             lastFetchedBounds!.northeast.latitude + padding &&
//         newBounds.southwest.longitude >=
//             lastFetchedBounds!.southwest.longitude - padding &&
//         newBounds.northeast.longitude <=
//             lastFetchedBounds!.northeast.longitude + padding);
//   }
//
//   Set<Marker> _createMarkersFromVehicles(List<LastLocationRespEntity> vehicles) {
//     return vehicles.map((data) {
//       return Marker(
//         markerId: MarkerId(
//             data.vehicle!.details!.last_location!.vehicle_id.toString()),
//         position: LatLng(
//             double.parse(data.vehicle!.details!.last_location!.latitude!),
//             double.parse(data.vehicle!.details!.last_location!.longitude!)),
//         icon: _customIcon!,
//         onTap: () {
//           _showVehicleToolTip(data);
//         },
//       );
//     }).toSet();
//   }
//
//   Future<List<LastLocationRespEntity>> fetchVehiclesWithinBounds(
//       LatLngBounds bounds) async {
//     return [];
//     // Replace with your actual API call, passing bounds as a parameter
//     // Example:
//     // return apiService.getVehiclesWithinBounds(bounds);
//   }
//
// }
