import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/modules/vehincle/presentation/widgets/vehicle_dashcam.dart';
import 'package:ctntelematics/modules/vehincle/presentation/widgets/vehicle_operations.dart';
import 'package:ctntelematics/modules/vehincle/presentation/widgets/vehicle_route_history.dart';
import 'package:ctntelematics/modules/vehincle/presentation/widgets/vehicle_share_route.dart';
import 'package:ctntelematics/modules/websocket/domain/entitties/resp_entities/vehicle_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../websocket/presentation/bloc/vehicle_location_bloc.dart';

class VehicleRouteLastLocationAndUpdate extends StatefulWidget {
  final String brand;
  final String model;
  final String vin;
  final double? latitude;
  final double? longitude;
  final String token;
  final String number_plate;
  final String voltage_level, speed, status, updated_at, gsm_signal_strength;
  final bool real_time_gps;
  const VehicleRouteLastLocationAndUpdate(
      {super.key,
      required this.brand,
      required this.model,
      required this.vin,
      this.latitude,
      this.longitude,
      required this.token,
      required this.number_plate,
      required this.real_time_gps,
        required this.gsm_signal_strength,
        required this.voltage_level,
        required this.speed,
        required this.updated_at,
        required this.status
      });

  @override
  State<VehicleRouteLastLocationAndUpdate> createState() =>
      _VehicleRouteLastLocationAndUpdateState();
}

class _VehicleRouteLastLocationAndUpdateState
    extends State<VehicleRouteLastLocationAndUpdate> {
  late GoogleMapController mapController;
  BitmapDescriptor? _customIcon;
  late Future<void> _getAuthUserFuture;
  final Set<Marker> _markers = {};
  bool _isContainerVisible = false;
  bool _showShareRoute = false;
  bool _showDashCam = false;
  bool _showVehicleOperation = false;

  @override
  void initState() {
    super.initState();
    _getAuthUserFuture = _loadInitialData();
    // Trigger the animation after a slight delay
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _isContainerVisible = true;
        _showShareRoute = false;
      });
    });
    // Initialize Pusher after starting to load initial data
  }

  Future<void> _loadInitialData() async {
    try {
      await Future.wait([
        // _getAuthUser(),
        _setCustomMarkerIcon(),
      ]);
    } catch (e, stackTrace) {
      print('Error during initialization: $e');
      print("Stack trace: $stackTrace");
    }
  }

  Future<void> _setCustomMarkerIcon() async {
    print("_setCustomMarkerIcon");
    try {
      _customIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(24, 24)),
        'assets/images/vehicle_map.png',
      );
      print('Custom marker icon loaded successfully');
      setState(() {}); // Refresh to show the marker with the custom icon
    } catch (e) {
      print('Error loading custom marker icon: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final args =
    //     ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return Scaffold(
        body: Stack(
      children: [
        FutureBuilder(
            future: _getAuthUserFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Failed to fetch user data'));
              } else {
                return BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
                  listener: (context, vehicles) {
                    // _updateVehicleCounts(vehicles);
                    setState(() {
                      vehicles;
                    });
                  },
                  child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
                    builder: (context, vehicles) {
                      if (vehicles.isEmpty) {
                        final LatLng _center = LatLng(
                            widget.latitude!.toDouble(),
                            widget.longitude!.toDouble());
                        _markers.addAll([
                          Marker(
                            icon: _customIcon!,
                            markerId: MarkerId(widget.number_plate),
                            position: LatLng(widget.latitude!.toDouble(),
                                widget.longitude!.toDouble()),
                            infoWindow: InfoWindow(title: widget.number_plate),
                          ),
                        ]);
                        return Flexible(
                          child: Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            height: double
                                .infinity, //MediaQuery.of(context).size.height * 0.4,
                            child: GoogleMap(
                              onMapCreated: (GoogleMapController controller) {
                                mapController = controller;
                              },
                              initialCameraPosition: CameraPosition(
                                target: _center,
                                zoom: 11.0,
                              ),
                              markers: _markers,
                              // polygons: _geofencePolygon != null ? {_geofencePolygon!} : {},
                              // circles: {_geofenceCircle!}, // Show geofence circle
                            ),
                          ),
                        );
                      }
                      // final movingVehicles = vehicles
                      //     .where(
                      //         (v) => v.locationInfo.vehicleStatus == "Moving")
                      //     .toList();

                      final movingVehicles = vehicles.where((v) {
                        return v.locationInfo.vehicleStatus == "Moving" &&
                            v.locationInfo.numberPlate == widget.number_plate;
                      }).toList();

                      //List<VehicleEntity> displayedVehicles = _filterVehicles(vehicles);

                      final LatLng _center = LatLng(widget.latitude!.toDouble(),
                          widget.longitude!.toDouble());
                      _markers.addAll([
                        Marker(
                          icon: _customIcon!,
                          markerId: MarkerId(
                              movingVehicles[0].locationInfo.numberPlate != null
                                  ? movingVehicles[0].locationInfo.numberPlate
                                  : widget.number_plate),
                          position: LatLng(
                              movingVehicles[0]
                                          .locationInfo
                                          .tracker!
                                          .position!
                                          .latitude!
                                          .toDouble() !=
                                      0.0000000
                                  ? movingVehicles[0]
                                      .locationInfo
                                      .tracker!
                                      .position!
                                      .latitude!
                                      .toDouble()
                                  : widget.latitude!.toDouble(),
                              widget.latitude!.toDouble()),
                          infoWindow: InfoWindow(
                              title: movingVehicles[0]
                                          .locationInfo
                                          .numberPlate ==
                                      null
                                  ? widget.number_plate
                                  : movingVehicles[0].locationInfo.numberPlate),
                        ),
                      ]);
                      return Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          height: double
                              .infinity, //MediaQuery.of(context).size.height * 0.4,
                          child: GoogleMap(
                            onMapCreated: (GoogleMapController controller) {
                              mapController = controller;
                            },
                            initialCameraPosition: CameraPosition(
                              target: _center,
                              zoom: 11.0,
                            ),
                            markers: _markers,
                            // polygons: _geofencePolygon != null ? {_geofencePolygon!} : {},
                            // circles: {_geofenceCircle!}, // Show geofence circle
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            }),
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
              ),
            ),
          ),
      ],
    ));
  }

  // Separate buildInfoPanel to keep code clean
  Widget buildInfoPanel() {
    return Container(
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
                  style: AppStyle.cardTitle.copyWith(color: Colors.red),
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
            style: AppStyle.cardSubtitle.copyWith(color: Colors.grey[700]),
          ),
          Text(
            "Vin: ${widget.vin}",
            style: AppStyle.cardSubtitle.copyWith(color: Colors.grey[700]),
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
          buildIcon(icon: CupertinoIcons.person, onTap: () {}),
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
