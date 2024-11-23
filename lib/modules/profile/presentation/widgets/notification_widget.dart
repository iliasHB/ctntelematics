import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../config/theme/app_style.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Notification',
              style: AppStyle.pageTitle,
            )
          ],
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("No Notification available")
              // NotificationContainer(
              //     icon: Icon(CupertinoIcons.wrench, color: Colors.white,),
              //     title: "Maintenance Reminder",
              //     subTitle: "It's time for scheduled maintenance on vehicle XYZ90P. "
              //         "Please check your service schedule.",
              //   footer: '2:00pm 8 hours ago'
              // ),
              // NotificationContainer(
              //     icon: Icon(CupertinoIcons.speedometer, color: Colors.white,),
              //     title: "Speed Alert",
              //     subTitle: "Vehicle XYZ90P exceeded the speed limit of 80mph. "
              //         "Please review driving behavior.",
              //     footer: '2:00pm 8 hours ago'
              // ),
              // NotificationContainer(
              //     icon: Icon(Icons.person_off, color: Colors.white,),
              //     title: "Idling Alert",
              //     subTitle: "Vehicle XYZ90P has been idling for more than 10 minutes. "
              //         "Consider turning of the engine to save fuel.",
              //     footer: '2:00pm 8 hours ago'
              // ),
              // NotificationContainer(
              //     icon: Icon(Icons.warning, color: Colors.white,),
              //     title: "Low fuel Alert",
              //     subTitle: "Vehicle XYZ90P has level than 15% fuel remaining. "
              //         "Refuel soon to avoid disruptions.",
              //     footer: '2:00pm 8 hours ago'
              // ),
              // NotificationContainer(
              //     icon: Icon(CupertinoIcons.map_pin_ellipse, color: Colors.white,),
              //     title: "Low fuel Alert",
              //     subTitle: "Vehicle XYZ90P has left the designated area. "
              //         "Verify the trip and driver's activity",
              //     footer: '2:00pm 8 hours ago'
              // ),
              //
              // NotificationContainer(
              //     icon: Icon(Icons.person_pin, color: Colors.white,),
              //     title: "Unauthorized Movement",
              //     subTitle: "Vehicle XYZ90P has left the designated area. "
              //         "Verify the trip and driver's activity",
              //     footer: '2:00pm 8 hours ago'
              // ),
              //
              // NotificationContainer(
              //     icon: Icon(Icons.tire_repair, color: Colors.white,),
              //     title: "Tire Pressure Warning",
              //     subTitle: "Vehicle XYZ90P has left the designated area. "
              //         "Verify the trip and driver's activity",
              //     footer: '2:00pm 8 hours ago'
              // ),
              //
              // NotificationContainer(
              //     icon: Icon(Icons.battery_0_bar, color: Colors.white,),
              //     title: "Battery Health",
              //     subTitle: "Vehicle XYZ90P has left the designated area. "
              //         "Verify the trip and driver's activity",
              //     footer: '2:00pm 8 hours ago'
              // ),
              //
              // NotificationContainer(
              //     icon: Icon(Icons.tire_repair_outlined, color: Colors.white,),
              //     title: "Fuel Efficiency Drop",
              //     subTitle: "Vehicle XYZ90P has left the designated area. "
              //         "Verify the trip and driver's activity",
              //     footer: '2:00pm 8 hours ago'
              // ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}

class NotificationContainer extends StatelessWidget {
  final Icon icon;
  final String title;
  final String subTitle;
  final String footer;
  const NotificationContainer(
      {super.key,
      required this.icon,
      required this.title,
      required this.subTitle, required this.footer});

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
              CircleAvatar(
                backgroundColor: Colors.red,
                  child: icon),
              const SizedBox(width: 10,),
              Text(title, style: AppStyle.cardTitle,),
            ],
          ),
          const SizedBox(height: 10,),
          Text(subTitle, style: AppStyle.cardfooter,),
          const SizedBox(height: 10,),
          Text(footer, style: AppStyle.cardfooter.copyWith(color: Colors.green),)
        ],
      ),
    );
  }
}
