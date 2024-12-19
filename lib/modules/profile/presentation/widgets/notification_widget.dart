import 'package:ctntelematics/core/usecase/databse_helper.dart';
import 'package:ctntelematics/core/widgets/format_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../config/theme/app_style.dart';

class NotificationWidget extends StatefulWidget {
  final List<NotificationItem> notifications;

  const NotificationWidget({super.key, required this.notifications});

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  late List<NotificationItem> _notifications;
  DB_notification db_notification = DB_notification();

  @override
  void initState() {
    super.initState();
    _notifications = widget.notifications;
  }

  Future<void> _deleteNotification(int index, String notificationId,
      NotificationItem notification) async {
    // Call the DatabaseHelper to delete the notification from the database
    DatabaseHelper dbHelper = DatabaseHelper();
    bool isDeleted = false;

    if (notification is SpeedLimitNotificationItem) {
      isDeleted = await dbHelper
          .deleteSpeedLimitNotification(int.parse(notificationId)) >
          0;
    } else if (notification is GeofenceNotificationItem) {
      isDeleted =
          await dbHelper.deleteNotification(int.parse(notificationId)) > 0;
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
      // Handle deletion failure (show a message, etc.)
      SnackBar(
        content: Text(
          'Notification failed delete!', style: AppStyle.cardfooter,),
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Notification',
              style: AppStyle.cardSubtitle.copyWith(fontSize: 16),
            )
          ],
        ),
      ),
      body: _notifications.isEmpty
          ? const Center(child: Text('No notifications'))
          : ListView.builder(
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
                      onDelete: () => _deleteNotification(
                          index, notification.id.toString(), notification),
                    ),
                  );

                  // _buildGeofenceNotification(notification);
                } else if (notification is GeofenceNotificationItem) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: NotificationContainer(
                      icon: const Icon(
                        CupertinoIcons.placemark,
                        color: Colors.white,
                      ),
                      title: "Geofence Alert",
                      subTitle:
                          "Vehicle ${notification.brand} ${notification.model} (${notification.numberPlate}) exceeded the boundary set with the geofence. "
                          "Please review driving behavior.",
                      footer: FormatData.formatTimeAgo(notification.createdAt!),
                      onDelete: () => _deleteNotification(
                          index, notification.id.toString(), notification),
                    ),
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
    required this.footer,
    required this.onDelete,
  });

  @override
  State<NotificationContainer> createState() => _NotificationContainerState();
}

class _NotificationContainerState extends State<NotificationContainer> {
  bool _isDeleting = false;
  @override
  Widget build(BuildContext context) {
    return _isDeleting
        ? AnimatedOpacity(
      opacity: 0.0,
      duration: Duration(milliseconds: 300),
      child: Container(), // Empty container to smooth fade-out
    )
        :Container(
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
                style: AppStyle.cardTitle.copyWith(fontSize: 14),
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
                style:
                    AppStyle.cardfooter.copyWith(color: Colors.green.shade800),
              ),
              IconButton(
                icon: const Icon(
                  CupertinoIcons.delete,
                  color: Colors.red,
                  size: 15,
                ),
                onPressed: widget.onDelete,
              ),
            ],
          )
        ],
      ),
    );
  }
}

// const SingleChildScrollView(
//   child: Padding(
//     padding: EdgeInsets.all(10.0),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("No Notification available")
//         NotificationContainer(
//             icon: Icon(CupertinoIcons.wrench, color: Colors.white,),
//             title: "Maintenance Reminder",
//             subTitle: "It's time for scheduled maintenance on vehicle XYZ90P. "
//                 "Please check your service schedule.",
//           footer: '2:00pm 8 hours ago'
//         ),
//         NotificationContainer(
//             icon: Icon(CupertinoIcons.speedometer, color: Colors.white,),
//             title: "Speed Alert",
//             subTitle: "Vehicle XYZ90P exceeded the speed limit of 80mph. "
//                 "Please review driving behavior.",
//             footer: '2:00pm 8 hours ago'
//         ),
//         NotificationContainer(
//             icon: Icon(Icons.person_off, color: Colors.white,),
//             title: "Idling Alert",
//             subTitle: "Vehicle XYZ90P has been idling for more than 10 minutes. "
//                 "Consider turning of the engine to save fuel.",
//             footer: '2:00pm 8 hours ago'
//         ),
//         NotificationContainer(
//             icon: Icon(Icons.warning, color: Colors.white,),
//             title: "Low fuel Alert",
//             subTitle: "Vehicle XYZ90P has level than 15% fuel remaining. "
//                 "Refuel soon to avoid disruptions.",
//             footer: '2:00pm 8 hours ago'
//         ),
//         NotificationContainer(
//             icon: Icon(CupertinoIcons.map_pin_ellipse, color: Colors.white,),
//             title: "Low fuel Alert",
//             subTitle: "Vehicle XYZ90P has left the designated area. "
//                 "Verify the trip and driver's activity",
//             footer: '2:00pm 8 hours ago'
//         ),
//
//         NotificationContainer(
//             icon: Icon(Icons.person_pin, color: Colors.white,),
//             title: "Unauthorized Movement",
//             subTitle: "Vehicle XYZ90P has left the designated area. "
//                 "Verify the trip and driver's activity",
//             footer: '2:00pm 8 hours ago'
//         ),
//
//         NotificationContainer(
//             icon: Icon(Icons.tire_repair, color: Colors.white,),
//             title: "Tire Pressure Warning",
//             subTitle: "Vehicle XYZ90P has left the designated area. "
//                 "Verify the trip and driver's activity",
//             footer: '2:00pm 8 hours ago'
//         ),
//
//         NotificationContainer(
//             icon: Icon(Icons.battery_0_bar, color: Colors.white,),
//             title: "Battery Health",
//             subTitle: "Vehicle XYZ90P has left the designated area. "
//                 "Verify the trip and driver's activity",
//             footer: '2:00pm 8 hours ago'
//         ),
//
//         NotificationContainer(
//             icon: Icon(Icons.tire_repair_outlined, color: Colors.white,),
//             title: "Fuel Efficiency Drop",
//             subTitle: "Vehicle XYZ90P has left the designated area. "
//                 "Verify the trip and driver's activity",
//             footer: '2:00pm 8 hours ago'
//         ),
//       ],
//     ),
//   ),
// ),
