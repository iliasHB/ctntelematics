import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/advert.dart';


class VehicleQuickSettingPage extends StatelessWidget {
  const VehicleQuickSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              "Quick Setting",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Advert(),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green.shade200,
                    radius: 30,
                    child: Image.asset("assets/images/car.png",),
                  ),
                  SizedBox(width: 10,),
                  Text("Update Icon", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),)
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green.shade200,
                    radius: 30,
                    child: Icon(Icons.personal_injury, size: 30, color: Colors.white,)
                  ),
                  SizedBox(width: 10,),
                  Text("Update Engine", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),)
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green.shade200,
                    radius: 30,
                    child: Icon(CupertinoIcons.news_solid, size: 30, color: Colors.white,)
                  ),
                  SizedBox(width: 10,),
                  Text("Cost Per Liter", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),)
                ],
              ),
            ),
          ),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  CircleAvatar(
                      backgroundColor: Colors.green.shade200,
                      radius: 30,
                      child: Icon(CupertinoIcons.timelapse, size: 30, color: Colors.white,)
                  ),
                  SizedBox(width: 10,),
                  Text("Update Time & Date", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),)
                ],
              ),
            ),
          ),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  CircleAvatar(
                      backgroundColor: Colors.green.shade200,
                      radius: 30,
                      child: Icon(CupertinoIcons.chart_pie, size: 30, color: Colors.white,)
                  ),
                  SizedBox(width: 10,),
                  Text("Mileage per km", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
