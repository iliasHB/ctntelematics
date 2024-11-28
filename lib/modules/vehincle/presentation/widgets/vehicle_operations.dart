import 'package:ctntelematics/modules/vehincle/presentation/pages/vehicle_analytics.dart';
import 'package:ctntelematics/modules/vehincle/presentation/pages/vehicle_dash.dart';
import 'package:ctntelematics/modules/vehincle/presentation/pages/vehicle_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../map/presentation/widgets/vehicle_analysis.dart';
import '../../../map/presentation/widgets/vehicle_info.dart';
import '../pages/vehicle_alert.dart';
import '../pages/vehicle_engine_lock.dart';
import '../pages/vehicle_quick_setting.dart';

class VehicleOperations extends StatefulWidget {
  final VoidCallback onClose;
  final String token, vin;
  final String voltage_level,
      speed,
      latitude,
      longitude,
      status,
      updated_at,
      number_plate,
      gsm_signal_strength,
      brand,
      model;
  final bool real_time_gps;

  const VehicleOperations(
      {super.key,
      required this.onClose,
      required this.token,
      required this.vin,
      required this.status,
      required this.updated_at,
      required this.longitude,
      required this.latitude,
      required this.speed,
      required this.number_plate,
      required this.voltage_level,
      required this.gsm_signal_strength,
      required this.real_time_gps,
      required this.brand,
      required this.model});

  @override
  State<VehicleOperations> createState() => _VehicleOperationsState();
}

class _VehicleOperationsState extends State<VehicleOperations> {
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.now();
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.27,
        ),
        width: double.infinity,
        margin: const EdgeInsets.only(top: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.cancel_outlined, color: Colors.black),
                ),
              ),
              Expanded(
                child: GridView.count(
                  padding: EdgeInsets.zero,
                  crossAxisCount: 3,
                  mainAxisSpacing: 10, // Adjust spacing between grid items
                  crossAxisSpacing: 5,
                  childAspectRatio: 1.5, //
                  // scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => VehicleDashboard(
                            token: widget.token,
                            vin: widget.vin,
                          ),
                        ));
                      },
                      child: VehicleOperationCard(
                          status: 'Dashboard',
                          icon: Icon(
                              CupertinoIcons
                                  .square_grid_2x2, //.gps_fixed_rounded,
                              color: Colors.green.shade300)),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => VehicleAnalytics(
                            token: widget.token,
                            vin: widget.vin,
                          ),
                        ));
                      }, //VehiclePlayBackToolTip.showTopModal(context),
                      child: VehicleOperationCard(
                          status: 'Analytics',
                          icon: Icon(
                            Icons.auto_graph,
                            // CupertinoIcons.play_circle,
                            color: Colors.green.shade300,
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => VehicleInfo(
                            voltage_level: widget.voltage_level,
                            speed: widget.speed,
                            latitude: widget.latitude,
                            longitude: widget.longitude,
                            real_time_gps: widget.real_time_gps,
                            status: widget.status,
                            gsm_signal_strength: widget.gsm_signal_strength,
                            updated_at: widget.updated_at,
                            number_plate: widget.number_plate,
                            brand: widget.brand,
                            model: widget.model
                          ),
                        ));
                      },
                      child: VehicleOperationCard(
                          status: 'Vehicle Info',
                          icon: Icon(CupertinoIcons.car_detailed,
                              color: Colors.green.shade300)),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const VehicleEngineLockPage(),
                        ));
                      },
                      child: VehicleOperationCard(
                        status: 'Engine lock',
                        icon: Icon(CupertinoIcons.lock_fill,
                            color: Colors.green.shade300),
                      ),
                    ),
                    InkWell(
                      onTap: () {


                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const VehicleAlertPage(),
                        ));
                      },
                      child: VehicleOperationCard(
                          status: 'Alert',
                          icon: Icon(Icons.warning,
                              color: Colors.green.shade300)),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const VehicleQuickSettingPage(),
                        ));
                      },
                      child: VehicleOperationCard(
                        status: 'Quick Setting',
                        icon: Icon(CupertinoIcons.gear,
                            color: Colors.green.shade300),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VehicleOperationCard extends StatelessWidget {
  final String status;
  final Icon icon;

  const VehicleOperationCard({required this.status, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            Text(status,
                style: const TextStyle(fontSize: 14, color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
