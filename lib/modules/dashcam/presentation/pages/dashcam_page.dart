import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/widgets/appBar.dart';

class DashCamPage extends StatefulWidget {
  const DashCamPage({super.key});

  @override
  State<DashCamPage> createState() => _DashCamPageState();
}

class _DashCamPageState extends State<DashCamPage> {
  PrefUtils prefUtils = PrefUtils();
  String? first_name;
  String? last_name;
  String? middle_name;
  String? email;
  String? token;
  @override
  void initState() {
    super.initState();
    _getAuthUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getAuthUser() async {
    List<String>? authUser = await prefUtils.getStringList('auth_user');
    setState(() {
      first_name = authUser![0] == "" ? null : authUser[0];
      last_name = authUser[1] == "" ? null : authUser[1];
      middle_name = authUser[2] == "" ? null : authUser[2];
      email = authUser[3] == "" ? null : authUser[3];
      token = authUser[4] == "" ? null : authUser[4];
    });
  }
  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return Scaffold(
        appBar: AnimatedAppBar(firstname: first_name ?? "",),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Image.asset("assets/images/cam.png")),
              const Text(
                "Garmin Dash Cam 67W",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Single-Channel  (Front-Facing)",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const Text(
                "1440p resolution 180-degree field of view",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20,),
              const Text(
                "Choose Method for connection",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
              ),
              const SizedBox(height: 30,),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(50.0)),
                          child: const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Icon(CupertinoIcons.bluetooth, size: 50, color: Colors.blue,),
                          ),
                        ),
                        const Text("Connect to Bluetooth", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),

                      ],
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(50.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Icon(CupertinoIcons.wifi, size: 50, color: Colors.green.shade300,),
                          ),
                        ),
                        const Text("Connect to Wifi", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30,),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.green.shade200,
                    borderRadius: BorderRadius.circular(100)),
                child: const Icon(Icons.add, size: 40,),
              ),
              const SizedBox(height: 10,),
              const Text("Add a Dashcam", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
              const SizedBox(height: 30,),
            ],
          ),
        ));
  }
}
