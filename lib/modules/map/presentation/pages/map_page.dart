import 'dart:async';
import 'dart:math';

import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/core/widgets/appBar.dart';
import 'package:ctntelematics/core/widgets/custom_button.dart';
import 'package:ctntelematics/modules/map/domain/entitties/req_entities/token_req_entity.dart';
import 'package:ctntelematics/modules/map/domain/entitties/resp_entities/last_location_resp_entity.dart';
// import 'package:ctntelematics/modules/map/domain/entitties/resp_entities/last_location_resp_entity.dart';
import 'package:ctntelematics/modules/map/presentation/bloc/map_bloc.dart';
import 'package:ctntelematics/modules/map/presentation/widgets/vehicle_tooltip.dart';
import 'package:ctntelematics/modules/websocket/presentation/bloc/vehicle_location_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/usecase/provider_usecase.dart';
import '../../../../service_locator.dart';
import '../../../websocket/domain/entitties/resp_entities/vehicle_entity.dart';

class MapPage extends StatefulWidget {
  MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  late GoogleMapController mapController;
  final ValueNotifier<Set<Marker>> _markers = ValueNotifier<Set<Marker>>({});
  // final _valueNotifier = ValueNotifier<Set<Marker>>({});
  final Map<String, bool> _isAnimating = {};
  BitmapDescriptor? _offlineCustomIcon;
  BitmapDescriptor? _onlineCustomIcon;
  Map<String, List<LatLng>> _routes = {};
  final double _geofenceRadius = 5000;
  PrefUtils prefUtils = PrefUtils();
  Polygon? _geofencePolygon;
  Set<Marker> _mark = {};
  List<Marker> _marker = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AnimatedAppBar(firstname: first_name ?? ""),
      body: FutureBuilder(
        future: _getAuthUserFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              strokeWidth: 2.0,
              color: Colors.green,
            ));
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
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/login", (route) => false);
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

                            markers: Set<Marker>.of(_mark),
                            polygons: isGeofence && _geofencePolygon != null
                                ? {_geofencePolygon!}
                                : {}, // Toggle geofence
                          ),
                        const Positioned(
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (state is GetLastLocationDone) {
                    // Add markers for all vehicles' last known location
                    _updateMarkers(state.resp, vehicles: []);

                    return BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
                      listener: (context, vehicles) {
                        // Handle additional logic if needed
                      },
                      child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
                        builder: (context, vehicles) {
                          // Update markers for vehicles that have moved
                          _updateMarkers(state.resp, vehicles: vehicles);

                          return buildMap(isGeofence);
                        },
                      ),
                    );
                  } else {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'No records found',
                          style: AppStyle.cardfooter,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        CustomSecondaryButton(
                            label: 'Refresh',
                            onPressed: () {
                              BlocProvider.of<LastLocationBloc>(context)
                                  .add(LastLocationEvent(tokenReq));
                            })
                      ],
                    ));
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildMap(bool isGeofence) {
    return ValueListenableBuilder<Set<Marker>>(
      valueListenable: _markers,
      builder: (context, markers, child){
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
          markers: markers,//Set<Marker>.of(_markers),
          polylines: _buildPolylines(), // Add polylines
          polygons: isGeofence && _geofencePolygon != null
              ? {_geofencePolygon!}
              : {}, // Toggle geofence
          onCameraIdle: () {
            _fetchMarkersInViewport();
          },
        );
}
    );
  }

  Set<Polyline> _buildPolylines() {
    return _routes.entries.where((entry) => entry.value.isNotEmpty).map((entry) {
      final numberPlate = entry.key;
      final route = entry.value;

      return Polyline(
        polylineId: PolylineId(numberPlate),
        points: route,
        color: Colors.blue, // Line color
        width: 2, // Line width
      );
    }).toSet();
  }



  void _updateMarkers(List<LastLocationRespEntity> allVehicles, {required List<VehicleEntity> vehicles}) async {
    // Set<Marker> updatedMarkers = {};
    final Map<String, Marker> updatedMarkers = Map.fromEntries(
      _markers.value.map((marker) => MapEntry(marker.markerId.value, marker)),
    );
    final interpolatedPositions = <LatLng>[];
    final Set<String> activeVehicles = {};
    // List<Marker> updatedMarkers = List.from(_markers);
// Map to track timers for inactive vehicles
    final Map<String, Timer> _inactiveTimers = {};

    /// Offline vehicle markers
    for (var vehicle in allVehicles) {
      if (vehicle.vehicle != null && vehicle.vehicle!.details?.last_location != null) {
        _addGeofencePolygon(vehicle.vehicle?.geofence?.coordinates);

        final currentPosition = LatLng(
          double.parse(
              vehicle.vehicle!.details!.last_location!.latitude.toString()),
          double.parse(
              vehicle.vehicle!.details!.last_location!.longitude.toString()),
        );

        final numberPlate = vehicle.vehicle!.details!.number_plate!;

        // Add offline marker if the vehicle is not moving
        if (vehicle.vehicle!.details?.last_location?.status != 'Moving' ||
            vehicle.vehicle!.details?.last_location?.status != 'moving') {
          if (_offlineCustomIcon == null) {
            _setOfflineCustomMarkerIcon();
          }

          updatedMarkers[numberPlate] = Marker(
              icon: _offlineCustomIcon!, // Icon for stationary vehicles
              markerId: MarkerId(numberPlate),
              position: currentPosition,
              onTap: () {
                mapController.animateCamera(
                  CameraUpdate.newLatLngZoom(currentPosition, 15.0), // Reduced zoom level
                );
                _showVehicleOfflineToolTip(
                  number_plate: vehicle.vehicle?.details!.number_plate,
                  vin: vehicle.vehicle?.details?.vin ?? "N/A",
                  address: vehicle.vehicle?.address ?? "N/A",
                  phone: vehicle.vehicle?.driver?.phone ?? "N/A",
                  name: vehicle.vehicle?.driver?.name ?? "N/A",
                  brand: vehicle.vehicle?.details?.brand ?? "N/A",
                  model: vehicle.vehicle?.details?.model ?? "N/A",
                  token: token,
                  latitude: vehicle.vehicle?.details?.last_location?.latitude ?? "N/A",
                  longitude: vehicle.vehicle?.details?.last_location?.longitude ?? "N/A",
                  voltage_level: vehicle.vehicle?.details?.last_location?.voltage_level ?? "N/A",
                  speed: vehicle.vehicle?.details?.last_location?.speed ?? "N/A",
                  real_time_gps: vehicle.vehicle?.details?.last_location?.real_time_gps,
                  status: vehicle.vehicle?.details?.last_location?.status ?? "N/A",
                  gsm_signal_strength: vehicle.vehicle?.details?.last_location?.gsm_signal_strength,
                  updated_at: vehicle.vehicle?.details?.last_location?.created_at  ??  vehicle.vehicle?.details?.last_location?.fix_time,
                  email: vehicle.vehicle?.driver?.email ?? "N/A",
                  country: vehicle.vehicle?.driver?.country ?? "N/A",
                  licence_number: vehicle.vehicle?.driver?.licence_number ?? "N/A",
                );
              },
              infoWindow: InfoWindow(
                title: numberPlate,
              ),
            // ),
          );
        }
      }
    }

    /// Online moving vehicle markers
    for (var vehicle in vehicles) {
      print("tracker speed: ${vehicles[0].locationInfo.model} ${vehicles[0].locationInfo.type}");
      print("vehicle status: ${vehicles[0].locationInfo.vehicleStatus}");
      print("tracker status: ${vehicles[0].locationInfo.tracker?.status}");
      print("tracker speed: ${vehicles[0].locationInfo.tracker?.position?.speed}");
      print("tracker lat: ${vehicle.locationInfo.tracker!.position!.latitude}");
      print("tracker long: ${vehicle.locationInfo.tracker!.position!.longitude}");
      var vehicleDetails = allVehicles.firstWhere(
            (v) => v.vehicle?.details?.number_plate == vehicle.locationInfo.numberPlate,
      );

      if ((vehicle.locationInfo.vehicleStatus.toLowerCase() == "moving" &&
              vehicle.locationInfo.tracker!.status!.toLowerCase() == "online" &&
              vehicle.locationInfo.tracker!.position!.latitude != null &&
              vehicle.locationInfo.tracker!.position!.longitude != null)
      ) {

        //_addGeofencePolygon(vehicleDetails.vehicle?.geofence?.coordinates);

        final currentPosition = LatLng(
          double.parse(vehicle.locationInfo.tracker!.position!.latitude.toString()),
          double.parse(vehicle.locationInfo.tracker!.position!.longitude.toString()),
        );

        final numberPlate = vehicle.locationInfo.numberPlate;

        // Add the vehicle to the active set
        activeVehicles.add(numberPlate);

        if (_isAnimating[numberPlate] == true) {
          // Skip this marker if it's already animating
          continue;
        }
        _routes[numberPlate] = _routes[numberPlate] ?? [];

        // if (!_routes.containsKey(numberPlate)) {
        //   _routes[numberPlate] = [];
        // }


        final previousPosition = _previousPositions[numberPlate] ?? currentPosition;
        // Cache the current position as the new previous position
        _previousPositions[numberPlate] = currentPosition;

        // Calculate bearing if we have a previous position
        double? bearing;
        if (previousPosition != null) {
          bearing = _calculateBearing(previousPosition, currentPosition);
        }

        // final distance = _calculateDistance(previousPosition, currentPosition);
        // if (distance < 1) continue;

        // Add or update the marker only if the vehicle has moved significantly
        if (previousPosition == null || _calculateDistance(previousPosition, currentPosition) >= 1) {

          final distance = _calculateDistance(previousPosition, currentPosition);

          if (_onlineCustomIcon == null) {
            await _setOnlineCustomMarkerIcon();
          }
          // Ensure significant movement has occurred
          if (!_routes.containsKey(numberPlate)) {
            _routes[numberPlate] = [];
          }

          const int minSteps = 20; // Minimum steps for short distances
          const int maxSteps = 150; // Maximum steps for long distances
          const double maxDistance = 1000; // Maximum distance threshold for scaling
          final steps = (distance * (maxSteps - minSteps) / maxDistance + minSteps)
              .clamp(minSteps, maxSteps)
              .toInt();
          // Interpolate marker movement for smooth animation
          //const int steps = 100; // Number of steps for interpolation
          _isAnimating[numberPlate] = true; // Set animation flag to true
          for (int i = 1; i <= steps; i++) {
            final t = i / steps;
            final interpolatedPosition = LatLng(
              previousPosition == null
                  ? currentPosition.latitude
                  : previousPosition.latitude +
                  (currentPosition.latitude - previousPosition.latitude) * t,
              previousPosition == null
                  ? currentPosition.longitude
                  : previousPosition.longitude +
                  (currentPosition.longitude - previousPosition.longitude) * t,
            );

            updatedMarkers[numberPlate] = Marker(
              icon: _onlineCustomIcon ?? _offlineCustomIcon!,
              markerId: MarkerId(numberPlate),
              position: interpolatedPosition,
              onTap: () {
                mapController.animateCamera(
                  CameraUpdate.newLatLngZoom(currentPosition, 15.0),
                );
                // // Optionally animate the camera to follow the vehicle
                // mapController.animateCamera(CameraUpdate.newLatLng(interpolatedPosition));

                _showVehicleOnlineToolTip(
                  // Pass relevant data
                  numberPlate: vehicle.locationInfo.numberPlate,
                  vin: vehicle.locationInfo.vin,
                  address: vehicleDetails.vehicle?.address ?? "N/A",
                  phone: vehicleDetails.vehicle?.driver?.phone ?? "N/A",
                  name: vehicleDetails.vehicle?.driver?.name ?? "N/A",
                  brand: vehicle.locationInfo.brand,
                  model: vehicle.locationInfo.model,
                  token: token,
                  latitude: vehicle.locationInfo.tracker?.position?.latitude ?? 0.0,
                  longitude: vehicle.locationInfo.tracker?.position?.longitude ?? 0.0,
                  batteryLevel: vehicle.locationInfo.tracker?.position?.batteryLevel,
                  speed: vehicle.locationInfo.tracker?.position?.speed ?? 0.0,
                  real_time_gps: vehicleDetails.vehicle?.details?.last_location?.real_time_gps ?? false,
                  status: vehicle.locationInfo.tracker?.status ?? "N/A",
                  gsmRssi: vehicle.locationInfo.tracker?.position?.gsmRssi ?? 0,
                  lastUpdate: vehicle.locationInfo.tracker?.lastUpdate ?? DateTime.now().toString(),
                  email: vehicleDetails.vehicle?.driver?.email ?? "N/A",
                  country: vehicleDetails.vehicle?.driver?.country ?? "N/A",
                  licence_number: vehicleDetails.vehicle?.driver?.licence_number ?? "N/A",
                );
              },
              infoWindow: InfoWindow(
                title: numberPlate,
              ),
              rotation: bearing ?? 0, // Apply calculated bearing
            );

            // Update the markers on the map incrementally
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _markers.value = updatedMarkers.values.toSet();
            });
            _routes[numberPlate]!.add(currentPosition);

            // Delay for smooth animation
            await Future.delayed(const Duration(milliseconds: 50));
          }
          _isAnimating[numberPlate] = false; // Reset animation flag after completion
        }

        // Ensure the latest current position is stored as the previous position
        _previousPositions[numberPlate] = currentPosition;
      }
    }



    for (var numberPlate in _previousPositions.keys) {
      if (!activeVehicles.contains(numberPlate)) {
        if (!_inactiveTimers.containsKey(numberPlate)) {
          _inactiveTimers[numberPlate] =
              Timer(const Duration(seconds: 120), () async {
                final lastPosition = _previousPositions[numberPlate];
                if (lastPosition != null && _offlineCustomIcon != null) {
                  updatedMarkers[numberPlate] = Marker(
                    icon: _offlineCustomIcon!,
                    markerId: MarkerId(numberPlate),
                    position: lastPosition,
                    infoWindow: InfoWindow(title: numberPlate),
                  );

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _markers.value = updatedMarkers.values.toSet();
                  });
                }
                _inactiveTimers.remove(numberPlate);
              });
        }}}

    // // Schedule offline marker for inactive vehicles
    // for (var numberPlate in _routes.keys) {
    //   if (!activeVehicles.contains(numberPlate)) {
    //     // Only schedule if there's no existing timer
    //     if (!_inactiveTimers.containsKey(numberPlate)) {
    //       _inactiveTimers[numberPlate] = Timer(const Duration(seconds: 120), () async {
    //         // Change the marker to offline
    //         if (_offlineCustomIcon == null) {
    //           await _setOfflineCustomMarkerIcon();
    //         }
    //
    //         final currentPosition = _previousPositions[numberPlate] ?? _routes[numberPlate]?.last;
    //         if (currentPosition != null) {
    //           updatedMarkers[numberPlate] = Marker(
    //             icon: _offlineCustomIcon!,
    //             markerId: MarkerId(numberPlate),
    //             position: currentPosition,
    //             onTap: () {
    //               mapController.animateCamera(CameraUpdate.newLatLngZoom(currentPosition, 15.0));
    //             },
    //             infoWindow: InfoWindow(title: numberPlate),
    //           );
    //
    //           // Update the map markers
    //           WidgetsBinding.instance.addPostFrameCallback((_) {
    //             _markers.value = updatedMarkers.values.toSet();
    //           });
    //         }
    //
    //         // Remove the timer reference after updating the marker
    //         _inactiveTimers.remove(numberPlate);
    //       });
    //     }
    //   }
    // }


    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markers.value = updatedMarkers.values.toSet();
    });

  }



  double _calculateDistance(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
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

  _showVehicleOnlineToolTip(
      {required String numberPlate,
      required String vin,
      required String address,
      required String phone,
      required String name,
      required String brand,
      required String model,
      String? token,
      double? latitude,
      double? longitude,
      int? batteryLevel,
      double? speed,
      required bool real_time_gps,
      String? status,
      int? gsmRssi,
      String? lastUpdate,
      required String email,
      required String country,
      required String licence_number}) {
    // print('object-numberplate::::: ${numberPlate}');
    VehicleToolTipDialog.showVehicleToolTipDialog(
      context,
      numberPlate,
      vin,
      address,
      phone,
      name,
      brand,
      model,
      token,
      latitude.toString(),
      longitude.toString(),
      batteryLevel.toString(),
      speed.toString(),
      real_time_gps,
      status,
      gsmRssi.toString(),
      lastUpdate,
      email,
      country,
      licence_number,
    );
  }

  void _showVehicleOfflineToolTip(
      {String? number_plate,
      String? vin,
      String? address,
      String? phone,
      String? name,
      String? brand,
      String? model,
      String? token,
      String? latitude,
      String? longitude,
      String? voltage_level,
      String? speed,
      bool? real_time_gps,
      String? status,
      String? gsm_signal_strength,
      String? updated_at,
      String? email,
      String? country,
      String? licence_number}) {
    // print('object-numberplate::::: ${vehicle.details!.number_plate}');
    VehicleToolTipDialog.showVehicleToolTipDialog(
      context,
      number_plate,
      vin,
      address,
      phone,
      name,
      brand,
      model,
      token,
      latitude,
      longitude,
      voltage_level,
      speed,
      real_time_gps!,
      status,
      gsm_signal_strength,
      updated_at,
      email,
      country,
      licence_number,
    );
  }

  void _addGeofencePolygon(List<MapCenterEntity>? coordinates) {
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
        _mark.addAll(_createMarkersFromVehicles(vehicles));
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
          //_showVehicleOfflineToolTip(data);
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






///----i want to implement -----
//
// class VehicleMapScreen extends StatefulWidget {
//   @override
//   _VehicleMapScreenState createState() => _VehicleMapScreenState();
// }
//
// class _VehicleMapScreenState extends State<VehicleMapScreen> {
//   late GoogleMapController mapController;
//   final ValueNotifier<Set<Marker>> _markers = ValueNotifier<Set<Marker>>({});
//   Polygon? _geofencePolygon;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Vehicle Map')),
//       body: MultiBlocProvider(
//         providers: [
//           BlocProvider(create: (_) => LastLocationBloc()..add(FetchLastLocationEvent())),
//           BlocProvider(create: (_) => VehicleLocationBloc()..add(FetchVehicleLocationEvent())),
//         ],
//         child: Column(
//           children: [
//             Expanded(
//               child: BlocConsumer<LastLocationBloc, LastLocationState>(
//                 listener: (context, state) {
//                   if (state is LastLocationError) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(state.message)),
//                     );
//                   }
//                 },
//                 builder: (context, state) {
//                   if (state is LastLocationLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state is LastLocationLoaded) {
//                     _updateMarkers(state.vehicles);
//                     return BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
//                       listener: (context, vehicles) {
//                         // Additional logic or notifications can go here
//                       },
//                       child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
//                         builder: (context, vehicles) {
//                           _updateMarkers(state.vehicles, vehicles: vehicles);
//                           return _buildGoogleMap();
//                         },
//                       ),
//                     );
//                   } else {
//                     return const Center(child: Text('No data available'));
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGoogleMap() {
//     return ValueListenableBuilder<Set<Marker>>(
//       valueListenable: _markers,
//       builder: (context, markers, child) {
//         return GoogleMap(
//           onMapCreated: (GoogleMapController controller) {
//             mapController = controller;
//           },
//           initialCameraPosition: const CameraPosition(
//             target: LatLng(9.0820, 8.6753), // Center of Nigeria
//             zoom: 6.0,
//           ),
//           markers: markers,
//           polygons: _geofencePolygon != null ? {_geofencePolygon!} : {},
//         );
//       },
//     );
//   }
//
//   void _updateMarkers(List<LastLocationRespEntity> allVehicles, {List<VehicleEntity>? vehicles}) {
//     final updatedMarkers = <Marker>{};
//
//     for (var vehicle in allVehicles) {
//       if (vehicle.vehicle != null && vehicle.vehicle!.details?.last_location != null) {
//         final position = LatLng(
//           double.parse(vehicle.vehicle!.details!.last_location!.latitude.toString()),
//           double.parse(vehicle.vehicle!.details!.last_location!.longitude.toString()),
//         );
//         final marker = Marker(
//           markerId: MarkerId(vehicle.vehicle!.details!.number_plate!),
//           position: position,
//           infoWindow: InfoWindow(title: vehicle.vehicle!.details!.number_plate!),
//         );
//         updatedMarkers.add(marker);
//       }
//     }
//
//     vehicles?.forEach((vehicle) {
//       if (vehicle.locationInfo.tracker?.position != null) {
//         final position = LatLng(
//           vehicle.locationInfo.tracker!.position!.latitude,
//           vehicle.locationInfo.tracker!.position!.longitude,
//         );
//         final marker = Marker(
//           markerId: MarkerId(vehicle.locationInfo.numberPlate),
//           position: position,
//           infoWindow: InfoWindow(title: vehicle.locationInfo.numberPlate),
//         );
//         updatedMarkers.add(marker);
//       }
//     });
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _markers.value = updatedMarkers;
//     });
//   }
// }

///
///


class MapPage1 extends StatefulWidget {
  MapPage1({super.key});

  @override
  State<MapPage1> createState() => _MapPage1State();
}

class _MapPage1State extends State<MapPage1> with TickerProviderStateMixin {
  late GoogleMapController mapController;

  BitmapDescriptor? _offlineCustomIcon;
  BitmapDescriptor? _onlineCustomIcon;
  Map<String, List<LatLng>> _routes = {};
  final double _geofenceRadius = 5000;
  PrefUtils prefUtils = PrefUtils();
  Polygon? _geofencePolygon;
  Set<Marker> _markers = {};
  List<Marker> _marker = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AnimatedAppBar(firstname: first_name ?? ""),
      body: FutureBuilder(
        future: _getAuthUserFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: Colors.green,
                ));
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
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/login", (route) => false);
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
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (state is GetLastLocationDone) {
                    // Add markers for all vehicles' last known location
                    _updateMarkers(state.resp, vehicles: []);

                    return BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
                      listener: (context, vehicles) {
                        // Handle additional logic if needed
                      },
                      child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
                        builder: (context, vehicles) {
                          // Update markers for vehicles that have moved
                          _updateMarkers(state.resp, vehicles: vehicles);

                          return buildMap(isGeofence);
                        },
                      ),
                    );
                  } else {
                    return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'No records found',
                              style: AppStyle.cardfooter,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            CustomSecondaryButton(
                                label: 'Refresh',
                                onPressed: () {
                                  BlocProvider.of<LastLocationBloc>(context)
                                      .add(LastLocationEvent(tokenReq));
                                })
                          ],
                        ));
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }


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
      polylines: _buildPolylines(), // Add polylines
      polygons: isGeofence && _geofencePolygon != null
          ? {_geofencePolygon!}
          : {}, // Toggle geofence
      onCameraIdle: () {
        _fetchMarkersInViewport();
      },
    );
  }

  Set<Polyline> _buildPolylines() {
    return _routes.entries.map((entry) {
      final numberPlate = entry.key;
      final route = entry.value;

      return Polyline(
        polylineId: PolylineId(numberPlate),
        points: route,
        color: Colors.blue, // Line color
        width: 2, // Line width
      );
    }).toSet();
  }


  void _updateMarkers(List<LastLocationRespEntity> allVehicles,
      {required List<VehicleEntity> vehicles}) async {
    // Set<Marker> updatedMarkers = {};
    List<Marker> updatedMarkers = List.from(_markers);


    /// Offline vehicle markers
    for (var vehicle in allVehicles) {
      if (vehicle.vehicle != null && vehicle.vehicle!.details?.last_location != null) {
        _addGeofencePolygon(vehicle.vehicle?.geofence?.coordinates);

        final currentPosition = LatLng(
          double.parse(
              vehicle.vehicle!.details!.last_location!.latitude.toString()),
          double.parse(
              vehicle.vehicle!.details!.last_location!.longitude.toString()),
        );

        final numberPlate = vehicle.vehicle!.details!.number_plate!;

        // Add offline marker if the vehicle is not moving
        if (vehicle.vehicle!.details?.last_location?.status != 'Moving' ||
            vehicle.vehicle!.details?.last_location?.status != 'moving') {
          if (_offlineCustomIcon == null) {
            _setOfflineCustomMarkerIcon();
          }

          _markers.add(
            Marker(
              icon: _offlineCustomIcon!, // Icon for stationary vehicles
              markerId: MarkerId(numberPlate),
              position: currentPosition,
              onTap: () {
                mapController.animateCamera(
                  CameraUpdate.newLatLngZoom(currentPosition, 15.0), // Reduced zoom level
                );
                _showVehicleOfflineToolTip(
                  number_plate: vehicle.vehicle?.details!.number_plate,
                  vin: vehicle.vehicle?.details?.vin ?? "N/A",
                  address: vehicle.vehicle?.address ?? "N/A",
                  phone: vehicle.vehicle?.driver?.phone ?? "N/A",
                  name: vehicle.vehicle?.driver?.name ?? "N/A",
                  brand: vehicle.vehicle?.details?.brand ?? "N/A",
                  model: vehicle.vehicle?.details?.model ?? "N/A",
                  token: token,
                  latitude: vehicle.vehicle?.details?.last_location?.latitude ?? "N/A",
                  longitude: vehicle.vehicle?.details?.last_location?.longitude ?? "N/A",
                  voltage_level: vehicle.vehicle?.details?.last_location?.voltage_level ?? "N/A",
                  speed: vehicle.vehicle?.details?.last_location?.speed ?? "N/A",
                  real_time_gps: vehicle.vehicle?.details?.last_location?.real_time_gps,
                  status: vehicle.vehicle?.details?.last_location?.status ?? "N/A",
                  gsm_signal_strength: vehicle.vehicle?.details?.last_location?.gsm_signal_strength,
                  updated_at: vehicle.vehicle?.details?.last_location?.created_at  ??  vehicle.vehicle?.details?.last_location?.fix_time,
                  email: vehicle.vehicle?.driver?.email ?? "N/A",
                  country: vehicle.vehicle?.driver?.country ?? "N/A",
                  licence_number: vehicle.vehicle?.driver?.licence_number ?? "N/A",
                );
              },
              infoWindow: InfoWindow(
                title: numberPlate,
              ),
            ),
          );
        }
      }
    }

    /// Online moving vehicle markers
    for (var vehicle in vehicles) {
      print("vehicle status: ${vehicles[0].locationInfo.vehicleStatus}");
      print("tracker status: ${vehicles[0].locationInfo.tracker?.status}");

      var vehicleDetails = allVehicles.firstWhere(
            (v) => v.vehicle?.details?.number_plate == vehicle.locationInfo.numberPlate,
      );

      if ((vehicle.locationInfo.vehicleStatus.toLowerCase() == "moving" &&
          vehicle.locationInfo.tracker!.status!.toLowerCase() == "online" &&
          vehicle.locationInfo.tracker!.position!.latitude != null &&
          vehicle.locationInfo.tracker!.position!.longitude != null)
      // ||
      // (vehicle.locationInfo.vehicleStatus.toLowerCase() == "parked" &&
      //     vehicle.locationInfo.tracker!.status!.toLowerCase() == "online" &&
      //     vehicle.locationInfo.tracker!.position!.latitude != null &&
      //     vehicle.locationInfo.tracker!.position!.longitude != null) ||
      // (vehicle.locationInfo.vehicleStatus.toLowerCase() == "idling" &&
      //     vehicle.locationInfo.tracker!.status!.toLowerCase() == "online" &&
      //     vehicle.locationInfo.tracker!.position!.latitude != null &&
      //     vehicle.locationInfo.tracker!.position!.longitude != null)
      ) {
        _addGeofencePolygon2(
          vehicle.locationInfo.withinGeofence?.coordinates ?? [],
        );

        final currentPosition = LatLng(
          double.parse(vehicle.locationInfo.tracker!.position!.latitude.toString()),
          double.parse(vehicle.locationInfo.tracker!.position!.longitude.toString()),
        );

        final numberPlate = vehicle.locationInfo.numberPlate;

        // Add current position to the route for this vehicle
        if (!_routes.containsKey(numberPlate)) {
          _routes[numberPlate] = [];
        }
        _routes[numberPlate]!.add(currentPosition);

        // Retrieve the previous position for bearing calculation
        final previousPosition = _previousPositions[numberPlate];

        // Cache the current position as the new previous position
        _previousPositions[numberPlate] = currentPosition;

        // Calculate bearing if we have a previous position
        double? bearing;
        if (previousPosition != null) {
          bearing = _calculateBearing(previousPosition, currentPosition);
        }

        // Remove any existing marker with the same ID
        updatedMarkers.removeWhere((marker) => marker.markerId.value == numberPlate);

        // Add or update the marker only if the vehicle has moved significantly
        if (previousPosition == null || _calculateDistance(previousPosition, currentPosition) >= 1) {
          if (_onlineCustomIcon == null) {
            await _setOnlineCustomMarkerIcon();
          }

          // Interpolate marker movement for smooth animation
          const int steps = 50; // Number of steps for interpolation
          for (int i = 1; i <= steps; i++) {
            final t = i / steps;
            final interpolatedPosition = LatLng(
              previousPosition == null
                  ? currentPosition.latitude
                  : previousPosition.latitude +
                  (currentPosition.latitude - previousPosition.latitude) *
                      t,
              previousPosition == null
                  ? currentPosition.longitude
                  : previousPosition.longitude +
                  (currentPosition.longitude - previousPosition.longitude) *
                      t,
            );

            // Update the marker position
            _markers.add(
              Marker(
                icon: _onlineCustomIcon ?? _offlineCustomIcon!,
                markerId: MarkerId(numberPlate),
                position: interpolatedPosition,
                onTap: () {
                  mapController.animateCamera(
                    CameraUpdate.newLatLngZoom(currentPosition, 15.0), // Reduced zoom level
                  );
                  _showVehicleOnlineToolTip(
                      numberPlate: vehicle.locationInfo.numberPlate,
                      vin: vehicle.locationInfo.vin,
                      address: vehicleDetails.vehicle?.address == null ? "N/A" : vehicleDetails.vehicle!.address!,
                      phone: vehicleDetails.vehicle?.driver?.phone! == null ? "N/A" :  vehicleDetails.vehicle!.driver!.phone!,
                      name: vehicleDetails.vehicle?.driver?.name! == null ? "N/A" : vehicleDetails.vehicle!.driver!.name!,
                      brand: vehicle.locationInfo.brand,
                      model: vehicle.locationInfo.model,
                      token: token,
                      latitude: vehicle.locationInfo.tracker?.position?.latitude ?? 0.0000000,
                      longitude: vehicle.locationInfo.tracker?.position?.longitude ?? 0.0000000,
                      batteryLevel: vehicle.locationInfo.tracker?.position?.batteryLevel,
                      speed: vehicle.locationInfo.tracker?.position?.speed ?? 0.00,
                      real_time_gps: vehicleDetails.vehicle?.details?.last_location?.real_time_gps ?? false,
                      status: vehicle.locationInfo.tracker?.status ?? "N/A",
                      gsmRssi: vehicle.locationInfo.tracker?.position?.gsmRssi ?? 0,
                      lastUpdate: vehicle.locationInfo.tracker?.lastUpdate ?? DateTime.now().toString(),
                      email: vehicleDetails.vehicle?.driver?.email ?? "N/A",
                      country: vehicleDetails.vehicle?.driver?.country ?? "N/A",
                      licence_number: vehicleDetails.vehicle?.driver?.licence_number ?? "N/A"
                  );
                },
                infoWindow: InfoWindow(
                  title: numberPlate,
                ),
                rotation: bearing ?? 0, // Apply calculated bearing
              ),
            );

            // // Smooth camera follow (optional)
            // if (i % 5 == 0) {
            //   await mapController.animateCamera(CameraUpdate.newLatLng(interpolatedPosition));
            // }

            // Delay for smooth animation
            await Future.delayed(const Duration(milliseconds: 50));
          }
        }
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _marker = updatedMarkers;
        });
      }
    });
  }

  ///

//   void _animateMarkerMovement(String numberPlate, LatLng startPosition, LatLng endPosition, VehicleEntity vehicle) {
//     print('Animating marker for: $numberPlate');
//     const int animationDuration = 1000; // Animation duration in milliseconds
//
//     final AnimationController controller = AnimationController(
//       vsync: this, // Ensure your widget implements `TickerProviderStateMixin`
//       duration: const Duration(milliseconds: animationDuration),
//     );
//
//     final Animation<double> latTween = Tween<double>(
//       begin: startPosition.latitude,
//       end: endPosition.latitude,
//     ).animate(controller);
//
//     final Animation<double> lngTween = Tween<double>(
//       begin: startPosition.longitude,
//       end: endPosition.longitude,
//     ).animate(controller);
//
//     controller.addListener(() {
//       final intermediatePosition = LatLng(latTween.value, lngTween.value);
//
//       // Find the marker index
//       final index = _marker.indexWhere((marker) => marker.markerId.value == numberPlate);
//       print('Index found for numberPlate $numberPlate: $index');
//       if (index == -1) {
//         print('Marker not found for numberPlate $numberPlate, adding a new one.');
//         _marker.add(
//           Marker(
//             markerId: MarkerId(numberPlate),
//             position: endPosition,
//             icon: _onlineCustomIcon ?? _offlineCustomIcon!,
//             onTap: () => _showVehicleToolTip(vehicle),
//             infoWindow: InfoWindow(
//               title: numberPlate,
//             ),
//           ),
//         );
//       } else {
//         // Update the existing marker
//         print('Updating marker for numberPlate $numberPlate at index $index');
//         _marker[index] = Marker(
//           markerId: _marker[index].markerId,
//           position: intermediatePosition,
//           icon: _onlineCustomIcon ?? _offlineCustomIcon!,
//           onTap: () => _showVehicleToolTip(vehicle),
//           infoWindow: InfoWindow(
//             title: numberPlate,
//           ),
//           rotation: _calculateBearing(startPosition, intermediatePosition),
//         );
//       }
// // Trigger UI update
// //       setState(() {});
//     });
//
//     controller.forward().whenComplete(() {
//       controller.dispose();
//       print('Animation complete for: $numberPlate');
//     });
//   }
  ///

  // void _animateMarkerMovement(String numberPlate, LatLng startPosition, LatLng endPosition, VehicleEntity vehicle) {
  //   print('object::::::::::::: $numberPlate');
  //   const int animationDuration = 1000; // Animation duration in milliseconds
  //   final AnimationController controller = AnimationController(
  //     vsync: this, // Ensure your widget implements `TickerProviderStateMixin`
  //     duration: const Duration(milliseconds: animationDuration),
  //   );
  //
  //   final Animation<double> latTween = Tween<double>(
  //     begin: startPosition.latitude,
  //     end: endPosition.latitude,
  //   ).animate(controller);
  //
  //   final Animation<double> lngTween = Tween<double>(
  //     begin: startPosition.longitude,
  //     end: endPosition.longitude,
  //   ).animate(controller);
  //
  //
  //   controller.addListener(() {
  //     final intermediatePosition = LatLng(latTween.value, lngTween.value);
  //     final index = _marker.indexWhere((marker) => marker.markerId.value == numberPlate);
  //
  //     if (index != -1) {
  //       setState(() {
  //         _marker[index] = Marker(
  //           markerId: _marker[index].markerId,
  //           position: intermediatePosition,
  //           icon: _onlineCustomIcon ?? _offlineCustomIcon!,
  //           onTap: () => _showVehicleToolTip(vehicle),
  //           infoWindow: InfoWindow(
  //             title: numberPlate,
  //           ),
  //           rotation: _calculateBearing(startPosition, intermediatePosition),
  //         );
  //       });
  //     }
  //   });
  //
  //   controller.forward().whenComplete(() => controller.dispose());
  //
  //   // controller.addListener(() {
  //   //   final intermediatePosition = LatLng(latTween.value, lngTween.value);
  //   //
  //   //   // Update marker's intermediate position
  //   //   setState(() {
  //   //     _marker = _markers.map((marker) {
  //   //       if (marker.markerId.value == numberPlate) {
  //   //         return Marker(
  //   //           markerId: marker.markerId,
  //   //           position: intermediatePosition,
  //   //           icon: _onlineCustomIcon ?? _offlineCustomIcon!,
  //   //           onTap: () {
  //   //             _showVehicleToolTip(vehicle);
  //   //           },
  //   //           infoWindow: InfoWindow(
  //   //             title: numberPlate,
  //   //           ),
  //   //           rotation: _calculateBearing(startPosition, intermediatePosition),
  //   //         );
  //   //       }
  //   //       return marker;
  //   //     }).toList();
  //   //   });
  //   // });
  //
  //   // controller.forward();
  // }

  double _calculateDistance(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  //
  // void _updateMarkers(List<LastLocationRespEntity> allVehicles,
  //     {required List<VehicleEntity> vehicles}) {
  //   // Ensure offline markers are added for stationary vehicles
  //
  //   for (var vehicle in allVehicles) {
  //     if (vehicle.vehicle != null &&
  //         vehicle.vehicle!.details?.last_location != null) {
  //       _addGeofencePolygon(vehicle.vehicle?.geofence?.coordinates);
  //
  //       final currentPosition = LatLng(
  //         double.parse(
  //             vehicle.vehicle!.details!.last_location!.latitude.toString()),
  //         double.parse(
  //             vehicle.vehicle!.details!.last_location!.longitude.toString()),
  //       );
  //
  //       final numberPlate = vehicle.vehicle!.details!.number_plate!;
  //
  //       // Add offline marker if the vehicle is not moving
  //       if (vehicle.vehicle!.details?.last_location?.status != 'Moving' ||
  //           vehicle.vehicle!.details?.last_location?.status != 'moving'
  //       ) {
  //         if (_offlineCustomIcon == null) {
  //           _setOfflineCustomMarkerIcon();
  //         }
  //
  //         _markers.add(
  //           Marker(
  //             icon: _offlineCustomIcon!, // Icon for stationary vehicles
  //             markerId: MarkerId(numberPlate),
  //             position: currentPosition,
  //             onTap: () {
  //               _showVehicleToolTip(vehicle);
  //             },
  //             infoWindow: InfoWindow(
  //               title: numberPlate,
  //             ),
  //           ),
  //         );
  //       }
  //     }
  //   }
  //
  //   for (var vehicle in vehicles) {
  //     print("vehicle status: ${vehicles[0].locationInfo.vehicleStatus}");
  //     print("tracker status: ${vehicles[0].locationInfo.tracker?.status}");
  //
  //     if ((vehicle.locationInfo.vehicleStatus == "Moving" &&
  //             vehicle.locationInfo.tracker!.status == "online" &&
  //             vehicle.locationInfo.tracker!.position!.latitude != null &&
  //             vehicle.locationInfo.tracker!.position!.longitude != null) ||
  //         (vehicle.locationInfo.vehicleStatus == "Parked" &&
  //             vehicle.locationInfo.tracker!.status == "online" &&
  //             vehicle.locationInfo.tracker!.position!.latitude != null &&
  //             vehicle.locationInfo.tracker!.position!.longitude != null) ||
  //         (vehicle.locationInfo.vehicleStatus == "Idling" &&
  //             vehicle.locationInfo.tracker!.status == "online" &&
  //             vehicle.locationInfo.tracker!.position!.latitude != null &&
  //             vehicle.locationInfo.tracker!.position!.longitude != null
  //         )
  //     ) {
  //       _addGeofencePolygon2(
  //         vehicle.locationInfo.withinGeofence?.coordinates ?? [],
  //       );
  //
  //
  //       final currentPosition = LatLng(
  //         double.parse(
  //             vehicle.locationInfo.tracker!.position!.latitude.toString()),
  //         double.parse(
  //             vehicle.locationInfo.tracker!.position!.longitude.toString()),
  //       );
  //
  //       final numberPlate = vehicle.locationInfo.numberPlate;
  //
  //       // Retrieve the previous position for bearing calculation
  //       final previousPosition = _previousPositions[numberPlate];
  //
  //       // Cache the current position as the new previous position
  //       _previousPositions[numberPlate] = currentPosition;
  //
  //       // Calculate bearing if we have a previous position
  //       double? bearing;
  //       if (previousPosition != null) {
  //         bearing = _calculateBearing(previousPosition, currentPosition);
  //       }
  //
  //       // Remove the old marker (if any) for this specific vehicle
  //       _markers.removeWhere((marker) => marker.markerId.value == numberPlate);
  //
  //       // Add marker only if the vehicle has moved significantly
  //       // Adjust the distance threshold to update markers more frequently if necessary
  //       if (previousPosition == null ||
  //           _calculateDistance(previousPosition, currentPosition) > 0.2) {
  //         if (_onlineCustomIcon == null) {
  //           _setOnlineCustomMarkerIcon();
  //         }
  //
  //         _markers.add(
  //           Marker(
  //             icon: _onlineCustomIcon ??
  //                 BitmapDescriptor.defaultMarker, // Ensure custom icon is set
  //             markerId: MarkerId(numberPlate),
  //             position: currentPosition,
  //             onTap: () {
  //               _showVehicleToolTip(vehicle);
  //             },
  //             infoWindow: InfoWindow(
  //               title: numberPlate,
  //             ),
  //             rotation: bearing ?? 0, // Set bearing if available
  //           ),
  //         );
  //
  //         // Smoothly animate the camera to the new position
  //         mapController.animateCamera(CameraUpdate.newLatLng(currentPosition));
  //       }
  //     }
  //   }
  // }




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

  _showVehicleOnlineToolTip(
      {required String numberPlate,
        required String vin,
        required String address,
        required String phone,
        required String name,
        required String brand,
        required String model,
        String? token,
        double? latitude,
        double? longitude,
        int? batteryLevel,
        double? speed,
        required bool real_time_gps,
        String? status,
        int? gsmRssi,
        String? lastUpdate,
        required String email,
        required String country,
        required String licence_number}) {
    // print('object-numberplate::::: ${numberPlate}');
    VehicleToolTipDialog.showVehicleToolTipDialog(
      context,
      numberPlate,
      vin,
      address,
      phone,
      name,
      brand,
      model,
      token,
      latitude.toString(),
      longitude.toString(),
      batteryLevel.toString(),
      speed.toString(),
      real_time_gps,
      status,
      gsmRssi.toString(),
      lastUpdate,
      email,
      country,
      licence_number,
    );
  }

  void _showVehicleOfflineToolTip(
      {String? number_plate,
        String? vin,
        String? address,
        String? phone,
        String? name,
        String? brand,
        String? model,
        String? token,
        String? latitude,
        String? longitude,
        String? voltage_level,
        String? speed,
        bool? real_time_gps,
        String? status,
        String? gsm_signal_strength,
        String? updated_at,
        String? email,
        String? country,
        String? licence_number}) {
    // print('object-numberplate::::: ${vehicle.details!.number_plate}');
    VehicleToolTipDialog.showVehicleToolTipDialog(
      context,
      number_plate,
      vin,
      address,
      phone,
      name,
      brand,
      model,
      token,
      latitude,
      longitude,
      voltage_level,
      speed,
      real_time_gps!,
      status,
      gsm_signal_strength,
      updated_at,
      email,
      country,
      licence_number,
    );
  }

  void _addGeofencePolygon(List<MapCenterEntity>? coordinates) {
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
          //_showVehicleOfflineToolTip(data);
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

// void _updateMarkers(List<LastLocationRespEntity> allVehicles, {required List<VehicleEntity> vehicles,}) {
//   bool shouldUpdateOfflineIcon = false;
//   final updatedMarkers = <Marker>{}; // Temporary set for updated markers
//   _markers.clear(); // Clear existing markers
//
//   // Add markers for all vehicles' last known locations (stationary vehicles)
//   for (var vehicle in allVehicles) {
//     print('Processing allVehicles...');
//     if (vehicle.vehicle != null &&
//         vehicle.vehicle!.details?.last_location != null) {
//       _addGeofencePolygon(vehicle.vehicle?.geofence?.coordinates);
//
//       final currentPosition = LatLng(
//         double.parse(
//             vehicle.vehicle!.details!.last_location!.latitude.toString()),
//         double.parse(
//             vehicle.vehicle!.details!.last_location!.longitude.toString()),
//       );
//
//       final numberPlate = vehicle.vehicle!.details!.number_plate!;
//
//       // Check if the current position has changed
//       if (!_previousPositions.containsKey(numberPlate) ||
//           _previousPositions[numberPlate] != currentPosition) {
//         shouldUpdateOfflineIcon = true;
//       }
//
//       // Cache the current position as the previous position
//       _previousPositions[numberPlate] = currentPosition;
//
//       // Add stationary vehicle marker
//       _markers.add(
//         Marker(
//           icon: _offlineCustomIcon!, // Icon for stationary vehicles
//           markerId: MarkerId(numberPlate),
//           position: currentPosition,
//           onTap: () {
//             _showVehicleToolTip(vehicle);
//           },
//           infoWindow: InfoWindow(
//             title: numberPlate,
//           ),
//         ),
//       );
//     }
//   }
//
//   // Update the custom offline marker icon if needed
//   if (shouldUpdateOfflineIcon) {
//     _setOfflineCustomMarkerIcon();
//   }
//
//   // Add markers for moving vehicles
//   for (var vehicle in vehicles) {
//     print("Processing moving vehicles...");
//     if ((vehicle.locationInfo.vehicleStatus == "Moving" &&
//             vehicle.locationInfo.tracker?.position?.latitude != null &&
//             vehicle.locationInfo.tracker?.position?.longitude != null) ||
//         vehicle.locationInfo.vehicleStatus == "moving") {
//       _addGeofencePolygon2(
//           vehicle.locationInfo.withinGeofence?.coordinates != null
//               ? vehicle.locationInfo.withinGeofence!.coordinates
//               : []);
//       final currentPosition = LatLng(
//         double.parse(
//             vehicle.locationInfo.tracker!.position!.latitude.toString()),
//         double.parse(
//             vehicle.locationInfo.tracker!.position!.longitude.toString()),
//       );
//
//       final numberPlate = vehicle.locationInfo.numberPlate;
//
//       // Retrieve the previous position for bearing calculation
//       final previousPosition = _previousPositions[numberPlate];
//
//       // Cache the current position as the new previous position
//       _previousPositions[numberPlate] = currentPosition;
//
//       // Calculate bearing if we have a previous position
//       double? bearing;
//       if (previousPosition != null) {
//         bearing = _calculateBearing(previousPosition, currentPosition);
//       }
//
//       // Add marker only if the vehicle has moved significantly
//       if (previousPosition == null ||
//           _calculateDistance(previousPosition, currentPosition) > 4.0) {
//         if (_onlineCustomIcon == null) {
//           _setOnlineCustomMarkerIcon();
//         }
//         _markers.add(
//           Marker(
//             icon: _onlineCustomIcon ?? BitmapDescriptor.defaultMarker, // Icon for moving vehicles
//             markerId: MarkerId(numberPlate),
//             position: currentPosition,
//             onTap: () {
//               _showVehicleToolTip(vehicle);
//             },
//             infoWindow: InfoWindow(
//               title: numberPlate,
//             ),
//             rotation: bearing ?? 0, // Set bearing if available
//           ),
//         );
//
//         // Smoothly animate the camera to the new position
//         mapController.animateCamera(CameraUpdate.newLatLng(currentPosition));
//       }
//     }
//   }
// }

// Helper function to calculate distance between two points
///

// void _updateMarkers(List<LastLocationRespEntity> allVehicles, {required List<VehicleEntity> vehicles,}) async {
//   // Map<String, Marker> updatedMarkers = Map.fromIterable(
//   //   _markers,
//   //   key: (marker) => marker.markerId.value,
//   //   value: (marker) => marker,
//   // );
//   List<Marker> updatedMarkers = List.from(_markers);
//
//   // Offline Vehicle Markers
//   for (var vehicle in allVehicles) {
//     final details = vehicle.vehicle?.details;
//     final lastLocation = details?.last_location;
//     if (details != null && lastLocation != null) {
//       _addGeofencePolygon(vehicle.vehicle?.geofence?.coordinates);
//       final currentPosition = LatLng(
//         double.parse(lastLocation.latitude.toString()),
//         double.parse(lastLocation.longitude.toString()),
//       );
//
//       if (_offlineCustomIcon == null) await _setOfflineCustomMarkerIcon();
//
//       updatedMarkers[int.parse(details.number_plate!)] = Marker(
//         icon: _offlineCustomIcon!,
//         markerId: MarkerId(details.number_plate!),
//         position: currentPosition,
//         onTap: () => _showVehicleToolTip(vehicle),
//         infoWindow: InfoWindow(title: details.number_plate),
//       );
//     }
//   }
//
//   // Online Vehicle Markers
//   for (var vehicle in vehicles) {
//     final locationInfo = vehicle.locationInfo;
//     final tracker = locationInfo.tracker;
//     if ((tracker?.status?.toLowerCase() == "online" &&
//             locationInfo.vehicleStatus.toLowerCase() == "moving" &&
//             tracker?.position?.latitude != null &&
//             tracker?.position?.longitude != null) ||
//         (tracker?.status?.toLowerCase() == "online" &&
//             locationInfo.vehicleStatus.toLowerCase() == "idling") ||
//         (tracker?.status?.toLowerCase() == "online" &&
//             locationInfo.vehicleStatus.toLowerCase() == "parked")) {
//       _addGeofencePolygon2(locationInfo.withinGeofence?.coordinates ?? []);
//       final currentPosition = LatLng(
//         double.parse(tracker!.position!.latitude.toString()),
//         double.parse(tracker.position!.longitude.toString()),
//       );
//
//       final numberPlate = locationInfo.numberPlate;
//       final previousPosition = _previousPositions[numberPlate];
//       _previousPositions[numberPlate] = currentPosition;
//
//       double? bearing;
//       if (previousPosition != null) {
//         bearing = _calculateBearing(previousPosition, currentPosition);
//       }
//
//       if (previousPosition == null ||
//           _calculateDistance(previousPosition, currentPosition) >= 1) {
//         if (_onlineCustomIcon == null) await _setOnlineCustomMarkerIcon();
//
//         // Interpolate marker movement for smooth animation
//         const int steps = 20; // Number of steps for interpolation
//         for (int i = 1; i <= steps; i++) {
//           final t = i / steps;
//           final interpolatedPosition = LatLng(
//             previousPosition == null
//                 ? currentPosition.latitude
//                 : previousPosition.latitude +
//                     (currentPosition.latitude - previousPosition.latitude) * t,
//             previousPosition == null
//                 ? currentPosition.longitude
//                 : previousPosition.longitude +
//                     (currentPosition.longitude - previousPosition.longitude) * t,
//           );
//
//           // Update the marker position
//           updatedMarkers[int.parse(numberPlate)] = Marker(
//             icon: _onlineCustomIcon ?? _offlineCustomIcon!,
//             markerId: MarkerId(numberPlate),
//             position: currentPosition,
//             onTap: () => _showVehicleToolTip(vehicle),
//             infoWindow: InfoWindow(title: numberPlate),
//             rotation: bearing ?? 0,
//           );
//
//           // Smooth camera follow (optional)
//           if (i % 5 == 0) {
//             await mapController.animateCamera(CameraUpdate.newLatLng(interpolatedPosition));
//           }
//
//           // Delay for smooth animation
//           await Future.delayed(const Duration(milliseconds: 50));
//         }
//
//         // updatedMarkers[int.parse(numberPlate)] = Marker(
//         //   icon: _onlineCustomIcon!,
//         //   markerId: MarkerId(numberPlate),
//         //   position: currentPosition,
//         //   onTap: () => _showVehicleToolTip(vehicle),
//         //   infoWindow: InfoWindow(title: numberPlate),
//         //   rotation: bearing ?? 0,
//         // );
//       }
//     }
//   }
//
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     if (mounted) {
//       setState(() {
//         _marker = updatedMarkers;
//       });
//     }
//   });
// }

///

//  //
// // Update markers for all vehicles and moving vehicles
//   void _updateMarkers(List<LastLocationRespEntity> allVehicles, {required List<VehicleEntity> vehicles,}) {bool shouldUpdateOfflineIcon = false;
//
//     _markers.clear(); // Clear existing markers
//     // Add markers for all vehicles' last known locations
//     for (var vehicle in allVehicles) {
//       if (vehicle.vehicle != null &&
//           vehicle.vehicle!.details?.last_location != null) {
//         _addGeofencePolygon(vehicle.vehicle?.geofence?.coordinates);
//
//         final currentPosition = LatLng(
//           double.parse(
//               vehicle.vehicle!.details!.last_location!.latitude.toString()),
//           double.parse(
//               vehicle.vehicle!.details!.last_location!.longitude.toString()),
//         );
//
//         // Cache the current position as the "previous position" if not already present
//         final numberPlate = vehicle.vehicle!.details!.number_plate!;
//         // Check if the current position is different from the previously stored position
//         if (!_previousPositions.containsKey(numberPlate) ||
//             _previousPositions[numberPlate] != currentPosition) {
//           shouldUpdateOfflineIcon = true;
//         }
//         _previousPositions.putIfAbsent(numberPlate, () => currentPosition);
//         // _setOfflineCustomMarkerIcon();
//         _markers.add(
//           Marker(
//             icon: _offlineCustomIcon!, // Icon for stationary vehicles
//             markerId: MarkerId(numberPlate),
//             position: currentPosition,
//             onTap: () {
//               _showVehicleToolTip(vehicle);
//             },
//             infoWindow: InfoWindow(
//               title: numberPlate,
//             ),
//           ),
//         );
//       }
//     }
//
//     // Update the custom marker icon if needed
//     if (shouldUpdateOfflineIcon) {
//       _setOfflineCustomMarkerIcon();
//     }
//
//     // Update markers for vehicles that have moved
//     for (var vehicle in vehicles) {
//       print(">>>>>>>>>>>>>>>> moving vehicle block 01<<<<<<<<<<<<<<<<<<<<<");
//       print('vehicle status: ${vehicle.locationInfo.vehicleStatus}');
//       print('status: ${vehicle.locationInfo.tracker!.status}');
//       if (vehicle.locationInfo.vehicleStatus == "Moving" &&
//           vehicle.locationInfo.tracker!.position!.latitude != null &&
//           vehicle.locationInfo.tracker!.position!.longitude != null) {
//         // _addGeofencePolygon2(vehicle.locationInfo.withinGeofence!.coordinates);
//
//         print(">>>>>>>>>>>>>>>> moving vehicle block 02<<<<<<<<<<<<<<<<<<<<<");
//
//         final currentPosition = LatLng(
//           double.parse(
//               vehicle.locationInfo.tracker!.position!.latitude.toString()),
//           double.parse(
//               vehicle.locationInfo.tracker!.position!.longitude.toString()),
//         );
//
//         final numberPlate = vehicle.locationInfo.numberPlate;
//
//         // Retrieve the previous position for bearing calculation
//         final previousPosition = _previousPositions[numberPlate];
//
//         // Cache the current position as the new previous position
//         _previousPositions[numberPlate] = currentPosition;
//
//         // Calculate bearing if we have a previous position
//         double? bearing;
//         if (previousPosition != null) {
//           bearing = _calculateBearing(previousPosition, currentPosition);
//         }
//
//         if (_onlineCustomIcon == null) {
//           _setOnlineCustomMarkerIcon();
//         }
//         // _setOnlineCustomMarkerIcon();
//
//         _markers.add(
//           Marker(
//             icon: _onlineCustomIcon!, // Icon for moving vehicles
//             markerId: MarkerId(numberPlate),
//             position: currentPosition,
//             onTap: () {
//               _showVehicleToolTip(vehicle);
//             },
//             infoWindow: InfoWindow(
//               title: numberPlate,
//             ),
//             rotation:
//                 bearing ?? 0, // Set bearing if available, otherwise default
//           ),
//         );
//       } else {
//         print('>>>>>>>>>> not moving here <<<<<<<<<<<<<<<<');
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   SnackBar(
//         //     content: Text('Vehicle is not moving', style: AppStyle.cardfooter,),
//         //     backgroundColor: Colors.red,
//         //   ),
//         // );
//       }
//     }
//   }

///
//
// // Helper function to calculate bearing
//   double _calculateBearing(LatLng start, LatLng end) {
//     final lat1 = _toRadians(start.latitude);
//     final lon1 = _toRadians(start.longitude);
//     final lat2 = _toRadians(end.latitude);
//     final lon2 = _toRadians(end.longitude);
//
//     final dLon = lon2 - lon1;
//
//     final y = sin(dLon) * cos(lat2);
//     final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
//
//     final bearing = atan2(y, x);
//
//     // Convert to degrees and normalize to 0-360
//     return (_toDegrees(bearing) + 360) % 360;
//   }

// // Conversion utilities
//   double _toRadians(double degrees) => degrees * pi / 180;
//   double _toDegrees(double radians) => radians * 180 / pi;
//
// // Add geofence polygon to map
//   void _addGeofencePolygon(List<dynamic>? coordinates) {
//     if (coordinates != null) {
//       // Implement geofence polygon logic
//       print('Adding geofence polygon...');
//     }
//   }

// // Set custom marker icons
//   void _setOfflineCustomMarkerIcon() async {
//     _offlineCustomIcon = await BitmapDescriptor.fromAssetImage(
//       ImageConfiguration(size: Size(48, 48)),
//       'assets/offline_vehicle_icon.png',
//     );
//   }
//
//   void _setOnlineCustomMarkerIcon() async {
//     _onlineCustomIcon = await BitmapDescriptor.fromAssetImage(
//       ImageConfiguration(size: Size(48, 48)),
//       'assets/online_vehicle_icon.png',
//     );
//   }
//
// // Show vehicle tooltip
//   void _showVehicleToolTip(dynamic vehicle) {
//     // Implement tooltip display logic
//     print('Vehicle selected: ${vehicle.vehicle?.details?.number_plate}');
//   }
///
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

