import 'dart:math';

// import 'package:ctntelematics/modules/map/presentation/widgets/vehicle_route_history.dart';
import 'package:ctntelematics/modules/vehincle/domain/entities/req_entities/route_history_req_entity.dart';
import 'package:ctntelematics/modules/vehincle/domain/entities/resp_entities/route_history_resp_entity.dart';
import 'package:ctntelematics/modules/vehincle/presentation/widgets/vehicle_route_history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../config/theme/app_style.dart';
import '../../../../core/widgets/format_data.dart';
import '../../../vehincle/presentation/bloc/vehicle_bloc.dart';
import '../bloc/map_bloc.dart';


class VehicleRouteHistory1 extends StatefulWidget {
  final String brand, model, vin, token;
  final double latitude, longitude;
  const VehicleRouteHistory1(this.brand, this.model, this.vin, this.latitude,
      this.longitude, this.token,
      {super.key});

  @override
  State<VehicleRouteHistory1> createState() => _VehicleRouteHistory1State();
}

class _VehicleRouteHistory1State extends State<VehicleRouteHistory1> {
  bool _isDialogShown = false;
  bool _isContainerVisible =
  false; // Flag to check if the dialog is already shown
  DateTime? fromDate;
  DateTime? toDate;
  String? speed;
  @override
  void initState() {
    super.initState();
    // Trigger the animation after a slight delay
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _isContainerVisible = true;
      });
    });
    // Initialize Pusher after starting to load initial data
  }

  @override
  Widget build(BuildContext context) {
    // Show dialog only if it hasn't been shown yet
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                const EdgeInsets.only(top: 20.0, right: 0.0, left: 10.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.arrow_back)),
                        const SizedBox(width: 5),
                        Text('Route History', style: AppStyle.cardSubtitle),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _isDialogShown = !_isDialogShown;
                          });
                        },
                        icon: Icon(
                          CupertinoIcons.calendar,
                          color: Colors.green.shade900,
                        ))
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(top: 0.0, right: 10.0, left: 10.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        "Model: ${widget.brand} ${widget.model}",
                        style: AppStyle.cardfooter,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(top: 0.0, right: 10.0, left: 10.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        "Vin: ${widget.vin}",
                        style: AppStyle.cardfooter,
                      ),
                    ),
                  ],
                ),
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: SizedBox(
              //           height: 50,
              //           child: ListView(
              //             scrollDirection: Axis.horizontal,
              //             children: [
              //               const SizedBox(
              //                 width: 10,
              //               ),
              //               RouteWidget(
              //                   title: "Route Length",
              //                   subTitle: FormatData.handle2DecimalPointFormat(0.0),
              //                   color: Colors.green),
              //               const SizedBox(
              //                 width: 10,
              //               ),
              //               const RouteWidget(
              //                   title: "Move Duration",
              //                   subTitle: "33min 0s",
              //                   color: Colors.brown),
              //               const SizedBox(
              //                 width: 10,
              //               ),
              //               const RouteWidget(
              //                   title: "Stop Duration",
              //                   subTitle: "16h 32min 22s",
              //                   color: Colors.blue),
              //               const SizedBox(
              //                 width: 10,
              //               ),
              //               const RouteWidget(
              //                   title: "Max Speed",
              //                   subTitle: "6kph",
              //                   color: Colors.purpleAccent)
              //             ],
              //           )),
              //     )
              //   ],
              // ),

              BlocConsumer<VehicleRouteHistoryBloc, VehicleState>(
                  builder: (BuildContext context, state) {
                    if (state is VehicleLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetVehicleRouteHistoryDone) {
                      return Flexible(
                        child: RouteHistoryMap(resp: state.resp, speed: speed),
                      );
                    } else {
                      return RouteLastLocation(widget.latitude, widget.longitude);
                    }
                  }, listener: (context, state) {
                if (state is VehicleFailure) {
                  if (state.message.contains("401")) {
                  Navigator.pushNamed(context, "/login");
                  }
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              }),
            ],
          ),
          if (_isDialogShown)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              top: _isContainerVisible ? 115 : -200,
              left: 10,
              right: 10,
              child: Material(
                color: Colors.white
                    .withOpacity(0.9), // Background with slight opacity
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      DateTimeRangePicker(
                        onSpeedSelected: (selectedSpeed) {
                          setState(() {
                            speed = selectedSpeed;
                          });
                        },
                        vin: widget.vin,
                        token: widget.token,
                      ),
                      // const SizedBox(height: 10),
                      // const Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     BadgeWidget(label: "Yesterday"),
                      //     SizedBox(width: 10),
                      //     BadgeWidget(label: "2 days ago"),
                      //     SizedBox(width: 10),
                      //     BadgeWidget(label: "3 days ago"),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class RouteWidget extends StatelessWidget {
  final String title, subTitle;
  final Color color;
  const RouteWidget(
      {super.key,
        required this.title,
        required this.subTitle,
        required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Text(title,
                style: AppStyle.cardfooter
                    .copyWith(color: Colors.grey[500], fontSize: 12)),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                subTitle,
                style: AppStyle.cardfooter.copyWith(color: color, fontSize: 12),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class RouteHistoryMap extends StatefulWidget {
  final VehicleRouteHistoryRespEntity resp;
  final String? speed;
  const RouteHistoryMap({super.key, required this.resp, required this.speed});

  @override
  _RouteHistoryMapState createState() => _RouteHistoryMapState();
}

class _RouteHistoryMapState extends State<RouteHistoryMap> {
  late GoogleMapController _mapController;
  List<LatLng> _polylineCoordinates = [];
  final Map<MarkerId, Marker> _markers = {};
  PolylinePoints polylinePoints = PolylinePoints();
  int _currentIndex = 0;
  Marker? _vehicleMarker;
  String _currentAddress = "Loading...";
  BitmapDescriptor? _customIcon;
  // Animation states
  bool _isPlaying = false;
  bool _isPaused = false;
  bool _isStopped = true;
  bool _isContainerVisible = false;
  String vehicleSpeed = "0.00";
  double maxSpeed = 0.0;
  final PanelController _panelController = PanelController();
  List<String> addresses = [];

  // Durations
  Duration moveDuration = Duration.zero;
  Duration stopDuration = Duration.zero;
  DateTime? lastUpdateTime;
  bool isMoving = false;

  // Speed mapping
  final Map<String, Duration> speedMap = {
    '1x': const Duration(seconds: 2), // Slowest speed
    '2x': const Duration(seconds: 1), // 2x speed
    '3x': const Duration(milliseconds: 750), // 3x speed
    '4x': const Duration(milliseconds: 500), // 4x speed
    '5x': const Duration(milliseconds: 250), // Fastest speed (5x)
  };

  @override
  void initState() {
    super.initState();
    _initializeMarkersAndRoute();
    _setCustomMarkerIcon();
    _fetchAddresses();
    // Trigger the animation after a slight delay
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _isContainerVisible = true;
      });
    });
    // Initialize Pusher after starting to load initial data
    // Load the custom vehicle icon
  }

  void _updateMoveAndStopDurations(double speed) {
    final currentTime = DateTime.now();

    if (lastUpdateTime != null) {
      final timeElapsed = currentTime.difference(lastUpdateTime!);

      if (speed > 0.1) {
        if (!isMoving) {
          isMoving = true;
        }
        moveDuration += timeElapsed;
      } else {
        if (isMoving) {
          isMoving = false;
        }
        stopDuration += timeElapsed;
      }
    }

    lastUpdateTime = currentTime;
  }

  // Method to calculate the distance in kilometers between two LatLng points
  double _calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371.0; // Earth's radius in kilometers

    double dLat = _degreesToRadians(end.latitude - start.latitude);
    double dLon = _degreesToRadians(end.longitude - start.longitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(start.latitude)) *
            cos(_degreesToRadians(end.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // Distance in kilometers
  }

// Calculate the total distance covered in the entire route
  double getTotalDistance() {
    double totalDistance = 0.0;

    for (int i = 0; i < _polylineCoordinates.length - 1; i++) {
      totalDistance += _calculateDistance(
        _polylineCoordinates[i],
        _polylineCoordinates[i + 1],
      );
    }
    return totalDistance;
  }

  Future<void> _setCustomMarkerIcon() async {
    print("_setCustomMarkerIcon");
    try {
      _customIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(24, 24)),
        'assets/images/vehicle_map.png', // Path to your custom vehicle image
      );
      print('Custom marker icon loaded successfully');
      setState(() {}); // Refresh to show the marker with the custom icon
    } catch (e) {
      print('Error loading custom marker icon: $e');
    }
  }

  void _initializeMarkersAndRoute() {
    final totalLocations = widget.resp.data.length;
    if (totalLocations > 0) {
      // Add marker at the start point
      _addMarker(widget.resp.data.first, 'Start',
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));

      // Add markers at regular intervals (e.g., every 10 locations)
      const interval = 20;
      for (int i = interval; i < totalLocations - interval; i += interval) {
        _addMarker(
          widget.resp.data[i],
          'Checkpoint $i',
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        );
      }

      // Add marker at the end point
      _addMarker(widget.resp.data.last, 'End',
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
    }

    // Populate the polyline coordinates
    _polylineCoordinates = widget.resp.data
        .map((location) => LatLng(double.parse(location.latitude!),
        double.parse(location.longitude!)))
        .toList();
  }

  void _addMarker(location, String label, BitmapDescriptor icon) {
    final lat = double.parse(location.latitude!);
    final lng = double.parse(location.longitude!);
    LatLng latLng = LatLng(lat, lng);
    Marker marker = Marker(
      markerId: MarkerId(location.id.toString()),
      position: latLng,
      infoWindow:
      InfoWindow(title: label, snippet: "Speed: ${location.speed} km/h"),
      icon: icon,
    );
    _markers[MarkerId(location.id.toString())] = marker;
  }

// Convert degrees to radians
  double _degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }

// Convert radians to degrees
  double _radiansToDegrees(double radians) {
    return radians * 180.0 / pi;
  }

  // Method to calculate the bearing between two LatLng points
  double _calculateBearing(LatLng start, LatLng end) {
    double lat1 = _degreesToRadians(start.latitude);
    double lon1 = _degreesToRadians(start.longitude);
    double lat2 = _degreesToRadians(end.latitude);
    double lon2 = _degreesToRadians(end.longitude);

    double dLon = lon2 - lon1;

    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    double bearing = _radiansToDegrees(atan2(y, x));

    return (bearing + 360) % 360; // Normalize to 0-360 degrees
  }

  void _animateVehicleMovement() async {
    if (_currentIndex >= _polylineCoordinates.length ||
        !_isPlaying ||
        _isPaused) {
      return;
    }

    LatLng currentLocation = _polylineCoordinates[_currentIndex];
    // LatLng nextLocation = _polylineCoordinates[_currentIndex + 1];

    // Update the vehicle's speed based on the current index data
    setState(() {
      vehicleSpeed = widget.resp.data[_currentIndex].speed
          .toString(); // Update vehicle speed
      double currentSpeed = double.tryParse(vehicleSpeed) ?? 0;
      // Update max speed if current speed is higher
      if (currentSpeed > maxSpeed) {
        maxSpeed = currentSpeed;
      }
      _updateMoveAndStopDurations(double.tryParse(vehicleSpeed) ?? 0);
    });
    // Call the method to update the vehicle's position
    _updateVehiclePosition(currentLocation);
    // // Calculate the bearing between the current and the next location
    // double bearing = _calculateBearing(currentLocation, nextLocation);

    await _mapController.animateCamera(CameraUpdate.newLatLng(currentLocation));

    // Calculate the bearing between the current and the next location
    if (_currentIndex < _polylineCoordinates.length - 1) {
      LatLng nextLocation = _polylineCoordinates[_currentIndex + 1];
      double distanceToNextPoint =
      _calculateDistance(currentLocation, nextLocation);
      print(
          "Distance to next point: ${distanceToNextPoint.toStringAsFixed(2)} km");

      double bearing = _calculateBearing(currentLocation, nextLocation);

      await _mapController
          .animateCamera(CameraUpdate.newLatLng(currentLocation));

      setState(() {
        _vehicleMarker = Marker(
          markerId: const MarkerId('vehicle'),
          position: currentLocation,
          icon: _customIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          rotation: bearing,
          anchor: const Offset(0.5, 0.5),
        );
      });
    }

    _fetchAddress(currentLocation.latitude, currentLocation.longitude);
    _currentIndex++;
    print("speed: ${speedMap[widget.speed]}");
    // Use the speed parameter to determine the delay between movements
    Duration delay = speedMap[widget.speed] ??
        const Duration(seconds: 1); // Default to 1 second if speed is not set
    Future.delayed(delay, _animateVehicleMovement); // Recursively animate
  }

  void _fetchAddress(double latitude, double longitude) async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        "${place.street}, ${place.locality}, ${place.country}";
      });
    }
  }

  // Fetch addresses for each data point
  Future<void> _fetchAddresses() async {
    List<String> tempAddresses = [];

    for (var location in widget.resp.data) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          double.parse(location.latitude!),
          double.parse(location.longitude!),
        );

        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks.first;
          tempAddresses.add(
            "${placemark.street}, ${placemark.locality}, ${placemark.country}",
          );
        } else {
          tempAddresses.add("Address not found");
        }
      } catch (e) {
        print("Error retrieving address: $e"); // Debug print
        tempAddresses.add("Error retrieving address");
      }
    }

    setState(() {
      addresses = tempAddresses;
      print("Addresses fetched: $addresses"); // Debug print
    });
  }

  void _play() {
    setState(() {
      _isPlaying = true;
      _isPaused = false;
      _isStopped = false;
      _animateVehicleMovement();
    });
  }

  void _pause() {
    setState(() {
      _isPaused = true;
      _isPlaying = false;
    });
  }

  void _stop() {
    setState(() {
      _isStopped = true;
      _isPlaying = false;
      _isPaused = false;
      _currentIndex = 0; // Reset index to start from the beginning
      _vehicleMarker = null; // Remove the vehicle marker
    });
  }

  double? _currentLatitude;
  double? _currentLongitude;

  // Assuming you have a method to update the vehicle's position
  void _updateVehiclePosition(LatLng newPosition) {
    setState(() {
      _currentLatitude = newPosition.latitude;
      _currentLongitude = newPosition.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 8),
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                          height: 50,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              RouteWidget(
                                  title: "Route Length",
                                  subTitle:
                                  FormatData.handle2DecimalPointFormat(
                                      widget.resp.total_distance_km),
                                  color: Colors.green),
                              const SizedBox(
                                width: 10,
                              ),
                              const SizedBox(width: 10),
                              RouteWidget(
                                title: "Move Duration",
                                subTitle:
                                "${moveDuration.inHours}h ${moveDuration.inMinutes.remainder(60)}min ${moveDuration.inSeconds.remainder(60)}s",
                                color: Colors.brown,
                              ),
                              const SizedBox(width: 10),
                              RouteWidget(
                                title: "Stop Duration",
                                subTitle:
                                "${stopDuration.inHours}h ${stopDuration.inMinutes.remainder(60)}min ${stopDuration.inSeconds.remainder(60)}s",
                                color: Colors.blue,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              RouteWidget(
                                  title: "Max Speed",
                                  subTitle: "${maxSpeed} kph",
                                  color: Colors.purpleAccent)
                            ],
                          )),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Address: $_currentAddress',
                      style: AppStyle.cardSubtitle.copyWith(fontSize: 12)),
                ),
                // Display latitude and longitude as a single line
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                      'Coordinate: (${_currentLatitude?.toStringAsFixed(6) ?? 'N/A'}, '
                          '${_currentLongitude?.toStringAsFixed(6) ?? 'N/A'})',
                      style: AppStyle.cardSubtitle.copyWith(fontSize: 14)),
                ),
              ],
            )),
        Flexible(
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                margin: const EdgeInsets.only(top: 0.0),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _polylineCoordinates.first,
                    zoom: 15.0,
                  ),
                  markers: _markers.values.toSet()
                    ..addIfNotNull(_vehicleMarker),
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId('route'),
                      points: _polylineCoordinates,
                      color: Colors.blue,
                      width: 5,
                    ),
                  },
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                ),
              ),
              SlidingUpPanel(
                  controller: _panelController,
                  minHeight: 100.0,
                  maxHeight: 700.0,
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
                  panel: _buildAddressList()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressList() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 10),
            width: 50,
            height: 5,
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10)),
          ),
          Row(
            children: [
              Column(
                children: [
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(vehicleSpeed, style: const TextStyle(fontSize: 35)),
                      Text(
                        "kph",
                        style: AppStyle.cardfooter,
                      )
                    ],
                  ),
                  Text(
                    "${moveDuration.inHours}:${moveDuration.inMinutes.remainder(60)}:${moveDuration.inSeconds.remainder(60)}",
                    style: AppStyle.cardfooter,
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                height: 50,
                width: 5.0,
                color: Colors.grey.shade300,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _isPlaying ? null : _play,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: !_isPlaying || _isPaused ? null : _pause,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.pause),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: !_isPlaying && !_isPaused ? null : _stop,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.stop),
                  ),
                ],
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  widget.speed == null ? "" : widget.speed!,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: widget.resp.data.length,
              itemBuilder: (BuildContext context, index) {
                print('length of route ${widget.resp.data.length}');
                // _fetchAddresses();
                return Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Flexible(
                          flex: 2,
                          child: Column(
                            children: [
                              Icon(Icons.place, color: Colors.red),
                              SizedBox(height: 40),
                              Icon(Icons.place, color: Colors.green)
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(addresses.length > index
                                  ? addresses[index]
                                  : "Loading...", style: AppStyle.cardfooter,),
                              Text(widget.resp.data[index].created_at!, style: AppStyle.cardfooter,),
                              const SizedBox(height: 20),
                              Text(addresses.length > index + 1
                                  ? addresses[index + 1]
                                  : "Loading..."),
                              Text(widget.resp.data[index].created_at!, style: AppStyle.cardfooter,),
                            ],
                          ),
                        ),
                        Flexible(flex: 2, child: Container()),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// extension MarkerSetExtension on Set<Marker> {
//   void addIfNotNull(Marker? marker) {
//     if (marker != null) {
//       add(marker);
//     }
//   }
// }

///---------------------

class RouteLastLocation extends StatefulWidget {
  final double latitude, longitude;
  const RouteLastLocation(this.latitude, this.longitude, {super.key});

  @override
  State<RouteLastLocation> createState() => _RouteLastLocationState();
}

class _RouteLastLocationState extends State<RouteLastLocation> {
  late GoogleMapController mapController;
  BitmapDescriptor? _customIcon;
  late Future<void> _getAuthUserFuture;
  Set<Marker> _markers = {};
  @override
  void initState() {
    super.initState();
    _getAuthUserFuture = _loadInitialData();
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
    return FutureBuilder(
        future: _getAuthUserFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to fetch user data'));
          } else {
            final LatLng _center = LatLng(widget.latitude, widget.longitude);
            _markers.addAll([
              Marker(
                icon: _customIcon!,
                markerId: const MarkerId('id'),
                position: LatLng(widget.latitude, widget.longitude),
              ),
            ]);
            return Flexible(
              child: Container(
                margin: const EdgeInsets.only(top: 20.0),
                height:
                double.infinity, //MediaQuery.of(context).size.height * 0.4,
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
        });
  }
}

const List<String> speedType = <String>['1x', '2x', '3x', '4x', '5x'];

class DateTimeRangePicker extends StatefulWidget {
  // final Function(DateTime?) onDateFromSelected;
  // final Function(DateTime?) onDateToSelected;
  final Function(String?) onSpeedSelected;
  final String? vin, token;
  const DateTimeRangePicker(
      {super.key,
        // required this.onDateFromSelected,
        // required this.onDateToSelected,
        required this.onSpeedSelected,
        required this.vin,
        required this.token});
  @override
  _DateTimeRangePickerState createState() => _DateTimeRangePickerState();
}

class _DateTimeRangePickerState extends State<DateTimeRangePicker> {
  DateTime? fromDate;
  DateTime? toDate;
  String dropdownValue1 = speedType.first;

  void _setDateRange(int daysAgo) {
    final now = DateTime.now();
    setState(() {
      fromDate = DateTime(now.year, now.month, now.day - daysAgo, 0, 0, 0);
      toDate = DateTime(now.year, now.month, now.day - daysAgo, 23, 59, 59);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From: ',
                        style: AppStyle.cardTitle.copyWith(fontSize: 14),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                                height: 40,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    enabled: false,
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    label: Text(
                                      fromDate == null
                                          ? 'Select Start Date and Time'
                                          : fromDate.toString(),
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                              )),
                          const SizedBox(width: 5),
                          InkWell(
                              onTap: () {
                                DatePicker.showDateTimePicker(
                                  context,
                                  showTitleActions: true,
                                  onConfirm: (date) {
                                    setState(() {
                                      fromDate = date;
                                    });
                                  },
                                  currentTime: DateTime.now(),
                                );
                              },
                              child: const Icon(
                                Icons.calendar_month,
                                color: Colors.green,
                              ))
                        ],
                      ),
                    ],
                  )),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'To: ',
                        style: AppStyle.cardTitle.copyWith(fontSize: 14),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                                height: 40,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    enabled: false,
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    label: Text(
                                      toDate == null
                                          ? 'Select End Date and Time'
                                          : toDate.toString(),
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                              )),
                          const SizedBox(width: 5),
                          InkWell(
                              onTap: () {
                                DatePicker.showDateTimePicker(
                                  context,
                                  showTitleActions: true,
                                  onConfirm: (date) {
                                    setState(() {
                                      toDate = date;
                                    });
                                  },
                                  currentTime: DateTime.now(),
                                );
                              },
                              child: const Icon(
                                Icons.calendar_month,
                                color: Colors.green,
                              ))
                        ],
                      ),
                    ],
                  )),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Speed: ',
            style: AppStyle.cardTitle.copyWith(fontSize: 14),
          ),
          Row(
            children: [
              Expanded(
                child: DropdownMenu<String>(
                  width: MediaQuery.of(context).size.width - 45,
                  textStyle: AppStyle.cardSubtitle
                      .copyWith(fontWeight: FontWeight.w500),
                  initialSelection: speedType.first,
                  onSelected: (String? value) {
                    setState(() {
                      dropdownValue1 = value!;
                    });
                    widget.onSpeedSelected(value);
                  },
                  dropdownMenuEntries:
                  speedType.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
              ),
              const SizedBox(width: 10),
              Align(
                alignment: Alignment.topLeft,
                child: PopupMenuButton(
                    icon: const Icon(Icons.filter_alt),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        onTap: () {
                          _setDateRange(1); // Yesterday
                        },
                        child: const Text("Yesterday"),
                      ),
                      PopupMenuItem(
                        value: 2,
                        onTap: () {
                          _setDateRange(2); // 2 days ago
                        },
                        child: const Text("2 days ago"),
                      ),
                      PopupMenuItem(
                        value: 3,
                        onTap: () {
                          _setDateRange(3); // 3 days ago
                        },
                        child: const Text("3 days ago"),
                      ),
                    ]),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    final routeHistoryReqEntity = VehicleRouteHistoryReqEntity(
                        vehicle_vin: widget.vin!,
                        time_from:
                        fromDate.toString().split('.').first ?? "N/A",
                        time_to: toDate.toString().split('.').first ?? "N/A",
                        token: widget.token!);
                    BlocProvider.of<VehicleRouteHistoryBloc>(context)
                        .add(VehicleRouteHistoryEvent(routeHistoryReqEntity));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.send),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}






// class VehicleRouteHistory1 extends StatefulWidget {
//   final String brand, model, vin, latitude, longitude, token;
//   const VehicleRouteHistory1(this.brand, this.model, this.vin, this.latitude,
//       this.longitude, this.token,
//       {super.key});
//
//   @override
//   State<VehicleRouteHistory1> createState() => _VehicleRouteHistory1State();
// }
//
// class _VehicleRouteHistory1State extends State<VehicleRouteHistory1> {
//   bool _isDialogShown = false; // Flag to check if the dialog is already shown
//   @override
//   Widget build(BuildContext context) {
//     // Show dialog only if it hasn't been shown yet
//     return Scaffold(
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 20.0, right: 0.0, left: 10.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Flexible(
//                       child: Text(
//                         'Route History',
//                       ),
//                     ),
//                     IconButton(
//                         onPressed: () {
//                           setState(() {
//                             _isDialogShown = !_isDialogShown;
//                           });
//
//                         },
//                         icon: const Icon(CupertinoIcons.calendar))
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 0.0, right: 10.0, left: 10.0),
//                 child: Row(
//                   children: [
//                     Flexible(child: Text("${widget.brand} ${widget.model} (${widget.vin})")),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),
//               // _isDialogShown ? DateTimeRangePicker(
//               //     onSpeedSelected: (selectedSpeed) {
//               //       speed = selectedSpeed;
//               //     },
//               //     vin: widget.vin,
//               //     token: widget.token) : Container(),
//               //
//               // _isDialogShown ?  const Row(
//               //   mainAxisAlignment: MainAxisAlignment.start,
//               //   crossAxisAlignment: CrossAxisAlignment.start,
//               //   children: [
//               //     Flexible(child: BadgeWidget(label: "Yesterday")),
//               //     const SizedBox(width: 10),
//               //     Flexible(child: BadgeWidget(label: "2 days ago")),
//               //     const SizedBox(width: 10),
//               //     Flexible(child: BadgeWidget(label: "3 days ago"))
//               //   ],
//               // ) : Container(),
//
//               BlocConsumer<RouteHistoryBloc, MapState>(
//                   builder: (BuildContext context, state) {
//                 if (state is MapLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (state is GetRouteHistoryDone) {
//                   return Flexible(
//                     child: RouteHistoryMap(data: state.resp.data, speed: speed),
//                   );
//                 } else {
//                   return RouteLastLocation(double.parse(widget.latitude),
//                       double.parse(widget.longitude));
//                 }
//               }, listener: (context, state) {
//                 if (state is MapFailure) {
//                   if (state.message.contains("401")) {
//                     Navigator.pushNamed(context, "/login");
//                   }
//                   ScaffoldMessenger.of(context)
//                       .showSnackBar(SnackBar(content: Text(state.message)));
//                 }
//               }),
//
//             ],
//           ),
//           if (_isDialogShown)
//             Positioned(
//               top: 100, // Positioning for overlay - adjust as needed
//               left: 0,
//               right: 0,
//               child: Material(
//                 color: Colors.white.withOpacity(0.9), // Background with slight opacity
//                 borderRadius: BorderRadius.circular(10),
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                     children: [
//                       DateTimeRangePicker(
//                         onSpeedSelected: (selectedSpeed) {
//                           setState(() {
//                             speed = selectedSpeed;
//                           });
//                         },
//                         vin: widget.vin,
//                         token: widget.token,
//                       ),
//                       const SizedBox(height: 10),
//                       const Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           BadgeWidget(label: "Yesterday"),
//                           SizedBox(width: 10),
//                           BadgeWidget(label: "2 days ago"),
//                           SizedBox(width: 10),
//                           BadgeWidget(label: "3 days ago"),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

