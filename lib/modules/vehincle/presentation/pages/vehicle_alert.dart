import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/core/widgets/advert.dart';
import 'package:ctntelematics/core/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/databse_helper.dart';
import '../../../../core/widgets/format_data.dart';
import '../../../websocket/domain/entitties/resp_entities/vehicle_entity.dart';
import '../../../websocket/presentation/bloc/vehicle_location_bloc.dart';

class VehicleAlertPage extends StatefulWidget {
  const VehicleAlertPage({super.key});

  @override
  State<VehicleAlertPage> createState() => _VehicleAlertPageState();
}

class _VehicleAlertPageState extends State<VehicleAlertPage> {
  bool viewAdvert = false;
  DB_notification db_notification = DB_notification();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Alert",
              style: AppStyle.cardSubtitle,
            )
          ],
        ),
      ),
      body: Column(
        children: [
          viewAdvert == false
              ? Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Check Latest Stock',
                                      style: AppStyle.cardfooter
                                          .copyWith(fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                viewAdvert = true;
                              });
                            },
                            icon: const Icon(
                              CupertinoIcons.chevron_down,
                              size: 15,
                            ))
                      ],
                    ),
                  ),
                )
              : Stack(children: [
                  const Advert(),
                  Positioned(
                    right: 10,
                    top: 0,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            viewAdvert = false;
                          });
                        },
                        icon: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.white,
                        )),
                  )
                ]),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Icon(
                    Icons.warning,
                    size: 40,
                    color: Colors.green.shade300,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Flexible(
                      child: Text(
                    "Sometimes you may not get alert due to GPD coverage network errors, battery voltage issue and unsupported vehicle",
                    softWrap:
                        true, // This ensures the text wraps to the next line if needed.
                    //overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
                    //maxLines: 5,
                  ))
                ],
              ),
            ),
          ),

          BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
            builder: (context, vehicles) {
              if (vehicles.isEmpty) {
                // Use FutureBuilder to fetch and display notifications
                return FutureBuilder<List<NotificationItem>>(
                  future: db_notification.fetchCombinedNotifications(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CustomContainerLoadingButton();// Show loading indicator while fetching data
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}'); // Handle errors
                    } else if (snapshot.hasData) {
                      return AlertWidget(notifications: snapshot.data!); // Display notifications
                    } else {
                      return Text('No notifications found');
                    }
                  },
                );
              }

              // Filter vehicles with geofence violations or exceeding speed limits
              final geofenceNotifications = vehicles.where((v) {
                return !(v.locationInfo.withinGeofence?.isInGeofence ?? true);
              }).toList();

              final speedLimitNotifications = vehicles.where((v) {
                final speedLimit =
                    double.tryParse(v.locationInfo.speedLimit?.toString() ?? '0') ?? 0;
                final vehicleSpeed =
                    double.tryParse(v.locationInfo.tracker?.position?.speed?.toString() ?? '0') ?? 0;
                return vehicleSpeed > speedLimit;
              }).toList();

              db_notification.saveNotifications(geofenceNotifications, speedLimitNotifications);

              return InkWell(
                onTap: () async {
                  final savedNotifications = await db_notification.fetchCombinedNotifications();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AlertWidget(notifications: savedNotifications)));
                },
              );
            },
          ),
        ],
      ),
    );
  }
}




class AlertWidget extends StatefulWidget {
  final List<NotificationItem> notifications;

  const AlertWidget({super.key, required this.notifications});

  @override
  State<AlertWidget> createState() => _AlertWidgetState();
}

class _AlertWidgetState extends State<AlertWidget> {
  late List<NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = widget.notifications;
  }


  Future<void> _deleteNotification(int index, String notificationId, NotificationItem notification) async {
    // Call the DatabaseHelper to delete the notification from the database
    DatabaseHelper dbHelper = DatabaseHelper();
    bool isDeleted = false;

    if (notification is SpeedLimitNotificationItem) {
      isDeleted = await dbHelper.deleteSpeedLimitNotification(int.parse(notificationId)) > 0;
    } else if (notification is GeofenceNotificationItem) {
      isDeleted = await dbHelper.deleteNotification(int.parse(notificationId)) > 0;
    }

    if (isDeleted) {
      // If deletion was successful, remove the notification from the list
      setState(() {
        _notifications.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Notification deleted successfully!', style: AppStyle.cardfooter,),
            backgroundColor: Colors.black,
          ));
    } else {
      SnackBar(
        content: Text(
          'Notification failed delete!', style: AppStyle.cardfooter,),
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return  _notifications.isEmpty
          ? Center(child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('No alert', style: AppStyle.cardfooter,),
          ))
          : Expanded(
            child: ListView.builder(
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
            final notification = _notifications[index];
            if (notification is SpeedLimitNotificationItem) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: NotificationContainer(
                  icon: const Icon(
                    CupertinoIcons.speedometer,
                    color: Colors.white,
                  ),
                  title: "Speed Alert",
                  subTitle:
                  "Vehicle ${notification.brand} ${notification.model} (${notification.numberPlate}) exceeded the speed limit. "
                      "Please review driving behavior.",
                  footer: FormatData.formatTimeAgo(notification.createdAt!),
                  onDelete: () => _deleteNotification(index, notification.id.toString(), notification),
                ),
              );

              // _buildGeofenceNotification(notification);
            } else if (notification is GeofenceNotificationItem) {
              return NotificationContainer(
                icon: const Icon(
                  CupertinoIcons.placemark,
                  color: Colors.white,
                ),
                title: "Geofence Alert",
                subTitle:
                "Vehicle ${notification.brand} ${notification.model} (${notification.numberPlate}) exceeded the boundary set with the geofence. "
                    "Please review driving behavior.",
                footer: FormatData.formatTimeAgo(notification.createdAt!),
                onDelete: () => _deleteNotification(index, notification.id.toString(), notification),
              );
            } else {
              return const ListTile(
                title: Text("Unknown Notification"),
                subtitle: Text("Unsupported notification type."),
              );
            }
                    },
                  ),
          );
 
  }
}

class NotificationContainer extends StatefulWidget {
  final Icon icon;
  final String title;
  final String subTitle;
  final String footer;
  final Future<void> Function() onDelete;

  const NotificationContainer({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.footer, required this.onDelete,
  });

  @override
  State<NotificationContainer> createState() => _NotificationContainerState();
}

class _NotificationContainerState extends State<NotificationContainer> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.grey.shade200,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: Colors.red, child: widget.icon),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.title,
                style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.subTitle,
            style: AppStyle.cardfooter.copyWith(fontSize: 12),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.footer,
                style: AppStyle.cardfooter.copyWith(fontSize: 12,color: Colors.green[700]),
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.delete, size: 15, color: Colors.red),
                onPressed: widget.onDelete,
              ),
            ],
          )
        ],
      ),
    );
  }
}


