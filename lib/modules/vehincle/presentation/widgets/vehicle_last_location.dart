import 'package:ctntelematics/modules/vehincle/presentation/widgets/vehicle_dashcam.dart';
import 'package:ctntelematics/modules/vehincle/presentation/widgets/vehicle_operations.dart';
import 'package:ctntelematics/modules/vehincle/presentation/widgets/vehicle_route_history.dart';
import 'package:ctntelematics/modules/vehincle/presentation/widgets/vehicle_share_route.dart';
import 'package:ctntelematics/modules/websocket/domain/entitties/resp_entities/vehicle_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  final String name, email, phone;
  const VehicleRouteLastLocation(
      {super.key,
      required this.brand,
      required this.model,
      required this.vin,
      this.latitude,
      this.longitude,
      required this.token,
      required this.number_plate, required this.name, required this.email, required this.phone});

  @override
  State<VehicleRouteLastLocation> createState() =>
      _VehicleRouteLastLocationState();
}

class _VehicleRouteLastLocationState extends State<VehicleRouteLastLocation> {
  late GoogleMapController mapController;
  BitmapDescriptor? _customIcon;
  late Future<void> _getAuthUserFuture;
  final Set<Marker> _markers = {};
  bool _isContainerVisible = false;
  bool _showShareRoute = false;
  bool _showDashCam = false;
  bool _showVehicleOperation = false;
  bool _showDriverInfo = false;

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

  // Function to calculate bearing
  double calculateBearing(LatLng start, LatLng end) {
    final lat1 = start.latitude * math.pi / 180;
    final lon1 = start.longitude * math.pi / 180;
    final lat2 = end.latitude * math.pi / 180;
    final lon2 = end.longitude * math.pi / 180;

    final dLon = lon2 - lon1;
    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    final bearing = math.atan2(y, x) * 180 / math.pi;
    return (bearing + 360) % 360; // Normalize to 0-360
  }

  @override
  Widget build(BuildContext context) {
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
                      // Listener code if needed
                    },
                    child:
                        BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
                      builder: (context, vehicles) {
                        if (vehicles.isEmpty) {
                          _markers.clear();
                          final LatLng _center = LatLng(
                              widget.latitude!.toDouble(),
                              widget.longitude!.toDouble());
                          _markers.add(Marker(
                            icon: _customIcon!,
                            markerId: MarkerId(widget.number_plate),
                            position: _center,
                            infoWindow: InfoWindow(title: widget.number_plate),
                          ));
                          return buildMap(_center);
                        }

                        final movingVehicles = vehicles.where((v) {
                          return v.locationInfo.vehicleStatus == "Moving" &&
                              v.locationInfo.vin == widget.vin;
                        }).toList();

                        if (movingVehicles.isNotEmpty) {
                          final currentVehicle = movingVehicles[0];
                          final tracker = currentVehicle.locationInfo.tracker!;
                          final startPosition = LatLng(
                              widget.latitude!.toDouble(),
                              widget.longitude!.toDouble());
                          final endPosition = LatLng(
                            tracker.position!.latitude ??
                                widget.latitude!.toDouble(),
                            tracker.position!.longitude ??
                                widget.longitude!.toDouble(),
                          );

                          final bearing =
                              calculateBearing(startPosition, endPosition);

                          _markers.clear();
                          _markers.add(Marker(
                            icon: _customIcon!,
                            markerId: MarkerId(widget.number_plate),
                            position: endPosition,
                            rotation: bearing, // Set bearing for the marker
                            infoWindow: InfoWindow(title: widget.number_plate),
                          ));

                          return buildMap(startPosition);
                        }

                        return const Center(
                            child: Text('No vehicle data available'));
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
                ),
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
                name: widget.name,
                phone: widget.phone,
                email: widget.email,
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

// Build GoogleMap widget
  Widget buildMap(LatLng center) {
    return Flexible(
      child: Container(
        margin: const EdgeInsets.only(top: 20.0),
        height: double.infinity,
        child: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
          initialCameraPosition: CameraPosition(
            target: center,
            zoom: 11.0,
          ),
          markers: _markers,
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   // final args =
  //   //     ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
  //   return Scaffold(
  //       body: Stack(
  //     children: [
  //
  //
  //       FutureBuilder(
  //           future: _getAuthUserFuture,
  //           builder: (context, snapshot) {
  //             if (snapshot.connectionState == ConnectionState.waiting) {
  //               return const Center(child: CircularProgressIndicator());
  //             } else if (snapshot.hasError) {
  //               return const Center(child: Text('Failed to fetch user data'));
  //             } else {
  //               return BlocListener<VehicleLocationBloc, List<VehicleEntity>>(
  //                 listener: (context, vehicles) {
  //                   // _updateVehicleCounts(vehicles);
  //                   // setState(() {
  //                   //   vehicles;
  //                   // });
  //                 },
  //                 child: BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
  //                   builder: (context, vehicles) {
  //
  //                     if (vehicles.isEmpty) {
  //                       _markers.clear();
  //                       final LatLng _center = LatLng(widget.latitude!.toDouble(),
  //                           widget.longitude!.toDouble());
  //                       _markers.addAll([
  //                         Marker(
  //                           icon: _customIcon!,
  //                           markerId: MarkerId(widget.number_plate),
  //                           position: LatLng(widget.latitude!.toDouble(), widget.longitude!.toDouble()),
  //                           infoWindow: InfoWindow(title: widget.number_plate),
  //                         ),
  //                       ]);
  //                       return Flexible(
  //                         child: Container(
  //                           margin: const EdgeInsets.only(top: 20.0),
  //                           height: double
  //                               .infinity, //MediaQuery.of(context).size.height * 0.4,
  //                           child: GoogleMap(
  //                             onMapCreated: (GoogleMapController controller) {
  //                               mapController = controller;
  //                             },
  //                             initialCameraPosition: CameraPosition(
  //                               target: _center,
  //                               zoom: 11.0,
  //                             ),
  //                             markers: _markers,
  //                             // polygons: _geofencePolygon != null ? {_geofencePolygon!} : {},
  //                             // circles: {_geofenceCircle!}, // Show geofence circle
  //                           ),
  //                         ),
  //                       );
  //                     }
  //
  //                     final movingVehicles = vehicles.where((v) {
  //                       return v.locationInfo.vehicleStatus == "Moving" &&
  //                           v.locationInfo.vin == widget.vin;
  //                     }).toList();
  //                     final latitude = movingVehicles[0]
  //                         .locationInfo
  //                         .tracker!
  //                         .position!
  //                         .latitude;
  //                     final longitude = movingVehicles[0]
  //                         .locationInfo
  //                         .tracker!
  //                         .position!
  //                         .longitude;
  //                     final LatLng _center = LatLng(widget.latitude!.toDouble(),
  //                         widget.longitude!.toDouble());
  //                     _markers.clear();
  //                     _markers.addAll([
  //                       Marker(
  //                         icon: _customIcon!,
  //                         markerId: MarkerId(widget.number_plate),
  //                         position: LatLng(
  //                             latitude ?? widget.latitude!.toDouble(),
  //                             longitude ?? widget.longitude!.toDouble()),
  //                         infoWindow: InfoWindow(title: widget.number_plate),
  //                       ),
  //                     ]);
  //
  //                     return Flexible(
  //                       child: Container(
  //                         margin: const EdgeInsets.only(top: 20.0),
  //                         height: double
  //                             .infinity, //MediaQuery.of(context).size.height * 0.4,
  //                         child: GoogleMap(
  //                           onMapCreated: (GoogleMapController controller) {
  //                             mapController = controller;
  //                           },
  //                           initialCameraPosition: CameraPosition(
  //                             target: _center,
  //                             zoom: 11.0,
  //                           ),
  //                           markers: _markers,
  //                           // polygons: _geofencePolygon != null ? {_geofencePolygon!} : {},
  //                           // circles: {_geofenceCircle!}, // Show geofence circle
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               );
  //             }
  //           }),
  //
  //       ///-------
  //       // AnimatedPositioned(
  //       //   duration: const Duration(milliseconds: 500),
  //       //   curve: Curves.easeInOut,
  //       //   top: _isContainerVisible ? 20 : -200,
  //       //   left: 10,
  //       //   right: 10,
  //       //   child: Container(
  //       //     // height: 200,
  //       //     constraints: BoxConstraints(
  //       //         maxHeight: MediaQuery.of(context).size.height * 0.15),
  //       //     decoration: const BoxDecoration(
  //       //       color: Colors.white,
  //       //     ),
  //       //     child: Column(
  //       //       mainAxisAlignment: MainAxisAlignment.start,
  //       //       crossAxisAlignment: CrossAxisAlignment.start,
  //       //       children: [
  //       //         Row(
  //       //           mainAxisAlignment: MainAxisAlignment.start,
  //       //           children: [
  //       //             Align(
  //       //               alignment: Alignment.topLeft,
  //       //               child: Text(widget.number_plate,
  //       //                   style:
  //       //                       AppStyle.pageTitle.copyWith(color: Colors.red)),
  //       //             ),
  //       //           ],
  //       //         ),
  //       //         Text("Model: ${widget.brand} ${widget.model}",
  //       //             style: AppStyle.cardSubtitle
  //       //                 .copyWith(color: Colors.grey[700])),
  //       //         Text("Vin: ${widget.vin}",
  //       //             style: AppStyle.cardSubtitle
  //       //                 .copyWith(color: Colors.grey[700])),
  //       //         // Text("Phone Number: ${widget.phone}",
  //       //         //     style: AppStyle.cardSubtitle
  //       //         //         .copyWith(color: Colors.grey[700])),
  //       //         // Text("Location: ${widget.location}",
  //       //         //     style: AppStyle.cardSubtitle
  //       //         //         .copyWith(color: Colors.grey[700])),
  //       //         Container(
  //       //           padding: const EdgeInsets.symmetric(
  //       //               vertical: 10.0, horizontal: 0.0),
  //       //           decoration: BoxDecoration(
  //       //             borderRadius: BorderRadius.circular(5),
  //       //             color: Colors.white,
  //       //           ),
  //       //           child: Row(
  //       //             mainAxisAlignment: MainAxisAlignment.start,
  //       //             children: [
  //       //               InkWell(
  //       //                   onTap: () => Navigator.of(context).push(
  //       //                       MaterialPageRoute(
  //       //                           builder: (context) => VehicleRouteHistory(
  //       //                               widget.brand,
  //       //                               widget.model,
  //       //                               widget.vin,
  //       //                               widget.latitude!.toDouble(),
  //       //                               widget.longitude!.toDouble(),
  //       //                               widget.token))),
  //       //                   child: const Icon(Icons.cable)),
  //       //               const SizedBox(
  //       //                 width: 20,
  //       //               ),
  //       //               InkWell(
  //       //                   onTap: () {
  //       //                     setState(() {
  //       //                       showShareRoute = !showShareRoute;
  //       //                     });
  //       //
  //       //                     // VehicleShareRoute
  //       //                     //     .showVehicleShareDialog(
  //       //                     //     context,
  //       //                     //     widget.brand,
  //       //                     //     widget.model,
  //       //                     //     widget.vin,
  //       //                     //     widget.token,
  //       //                     //     widget.latitude,
  //       //                     //     widget.longitude);
  //       //                   },
  //       //                   child: const Icon(Icons.share_outlined)),
  //       //               const SizedBox(
  //       //                 width: 20,
  //       //               ),
  //       //               InkWell(
  //       //                   onTap: () {
  //       //                     // VehicleLivePreview.showTopModal(context);
  //       //                   },
  //       //                   child: const Icon(CupertinoIcons.photo_camera)),
  //       //               const SizedBox(
  //       //                 width: 20,
  //       //               ),
  //       //               InkWell(
  //       //                   onTap: () {
  //       //                     // showModalBottomSheet(
  //       //                     //     context: context,
  //       //                     //     isDismissible: false,
  //       //                     //     isScrollControlled: true,
  //       //                     //     //useSafeArea: true,
  //       //                     //     shape:
  //       //                     //     const RoundedRectangleBorder(
  //       //                     //       borderRadius:
  //       //                     //       BorderRadius.only(
  //       //                     //           topLeft: Radius
  //       //                     //               .circular(20),
  //       //                     //           topRight: Radius
  //       //                     //               .circular(20)),
  //       //                     //     ),
  //       //                     //     builder: (BuildContext
  //       //                     //     context) {
  //       //                     //       return const VehicleRouteOperation();
  //       //                     //     });
  //       //                   },
  //       //                   child: const Icon(
  //       //                       CupertinoIcons.rectangle_on_rectangle)),
  //       //               const SizedBox(
  //       //                 width: 20,
  //       //               ),
  //       //               InkWell(
  //       //                   onTap: () {
  //       //                     // VehicleDriverDialog
  //       //                     //     .showDriverDialog(
  //       //                     //     context, name);
  //       //                   },
  //       //                   child: const Icon(CupertinoIcons.person)),
  //       //             ],
  //       //           ),
  //       //         ),
  //       //       ],
  //       //     ),
  //       //   ),
  //       // ),
  //
  //       // Information panel
  //       AnimatedPositioned(
  //         duration: const Duration(milliseconds: 500),
  //         curve: Curves.easeInOut,
  //         top: _isContainerVisible ? 20 : -200,
  //         left: 10,
  //         right: 10,
  //         child: buildInfoPanel(),
  //       ),
  //
  //       if (_showShareRoute)
  //         AnimatedPositioned(
  //           duration: const Duration(milliseconds: 500),
  //           curve: Curves.easeInOut,
  //           top: MediaQuery.of(context).size.height / 2 -
  //               (MediaQuery.of(context).size.height * 0.3),
  //           left: _isContainerVisible
  //               ? 10
  //               : MediaQuery.of(context)
  //                   .size
  //                   .width, // Starts off-screen and slides in
  //           right: _isContainerVisible
  //               ? 10
  //               : -MediaQuery.of(context)
  //                   .size
  //                   .width, // Adjust right as well for slide-in effect
  //           child: VehicleShareRoute(
  //             brand: widget.brand,
  //             model: widget.model,
  //             vin: widget.vin,
  //             token: widget.token,
  //             latitude: widget.latitude!,
  //             longitude: widget.longitude!,
  //             onClose: () {
  //               setState(() {
  //                 _showShareRoute = false;
  //               });
  //             },
  //           ),
  //         ),
  //
  //       if (_showDashCam)
  //         AnimatedPositioned(
  //           duration: const Duration(milliseconds: 500),
  //           curve: Curves.easeInOut,
  //           top: _isContainerVisible ? 10 : -200,
  //           left: 10,
  //           right: 10,
  //           child: Material(
  //               color: Colors.white
  //                   .withOpacity(0.9), // Background with slight opacity
  //               borderRadius: BorderRadius.circular(10),
  //               child: VehicleDashCam(
  //                 brand: widget.brand,
  //                 model: widget.model,
  //                 vin: widget.vin,
  //                 token: widget.token,
  //                 latitude: widget.latitude!,
  //                 longitude: widget.longitude!,
  //                 onClose: () {
  //                   setState(() {
  //                     _showDashCam = false;
  //                   });
  //                 },
  //               )),
  //         ),
  //
  //       if (_showVehicleOperation)
  //         AnimatedPositioned(
  //           duration: const Duration(milliseconds: 500),
  //           curve: Curves.easeInOut,
  //           // top: _isContainerVisible ? 20 : -200,
  //           left: 0,
  //           right: 0,
  //           bottom: _isContainerVisible ? 0 : -200,
  //           child: Material(
  //             color: Colors.white
  //                 .withOpacity(0.9), // Background with slight opacity
  //             borderRadius: BorderRadius.circular(10),
  //             child: VehicleOperations(
  //               onClose: () {
  //                 setState(() {
  //                   _showVehicleOperation = false;
  //                   // _isContainerVisible = false; // Set visibility state
  //                 });
  //               },
  //             ),
  //           ),
  //         ),
  //     ],
  //   ));
  // }

  // Separate buildInfoPanel to keep code clean
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
          buildIcon(icon: CupertinoIcons.person, onTap: () {
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
