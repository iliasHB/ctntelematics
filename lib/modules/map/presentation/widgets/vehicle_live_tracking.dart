import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VehicleLiveTracking extends StatelessWidget {
  const VehicleLiveTracking({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.green.shade200,
                            radius: 5,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            "Vehicle B",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      // Spacer(),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.green.shade300,
                            radius: 15,
                            child: const Icon(
                              Icons.comment,
                              size: 15,
                            ),
                          ),
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.green.shade200,
                            child: const Icon(
                              Icons.call,
                              size: 15,
                            ),
                          ),
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.green.shade200,
                            child: const Icon(
                              Icons.close,
                              size: 15,
                            ),
                          )
                        ],
                      )
                      // Spacer(),

                    ],
                  ),
                  const Text("123 Madison Avenue, New York, NY 10016", softWrap: true)
                ],
              ),
            ],
          ),
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Container(
                      height: 80,
                      decoration: const BoxDecoration(),
                      child: const SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: VehicleLiveTrackingStatus1(),
                      )
                      // ListView.builder(
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: listData.length,
                      //     itemBuilder: (BuildContext context, int index) {
                      //       return Card(
                      //         child: Row(
                      //           children: listData[index],
                      //         )//
                      //       );
                      //     }),
                      ))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Container(
                      height: 120,
                      decoration: const BoxDecoration(),
                      child: const SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: VehicleLiveTrackingStatus2(),
                      )
                      // ListView.builder(
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: listData.length,
                      //     itemBuilder: (BuildContext context, int index) {
                      //       return Card(
                      //         child: Row(
                      //           children: listData[index],
                      //         )//
                      //       );
                      //     }),
                      ))
            ],
          ),
        ],
      ),
    );
  }
}

class VehicleLiveTrackingStatus1 extends StatelessWidget {
  const VehicleLiveTrackingStatus1({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Card(
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.speedometer,
                  size: 50,
                  color: Colors.green.shade300,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Odometer",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      "32650 km",
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Card(
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Icon(
                  Icons.heat_pump_outlined,
                  size: 50,
                  color: Colors.green.shade300,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Engine hours",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      "100h 42m 49s",
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Card(
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Icon(
                  Icons.route,
                  size: 50,
                  color: Colors.green.shade300,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Route Length",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      "100.64 km",
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Card(
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Icon(
                  Icons.shutter_speed,
                  size: 50,
                  color: Colors.green.shade300,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Move Duration",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      "10h 2m 4s",
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Card(
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Icon(
                  Icons.shutter_speed,
                  size: 50,
                  color: Colors.red.shade300,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Stop Duration",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      "10h 2m 4s",
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Card(
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Icon(
                  Icons.speed,
                  size: 50,
                  color: Colors.green.shade300,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Average Speed",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      "10km",
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Card(
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Icon(
                  Icons.speed_rounded,
                  size: 50,
                  color: Colors.green.shade300,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Top Speed",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      "10km",
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Card(
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.today,
                  size: 50,
                  color: Colors.green.shade300,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Avg Fuel Consumption",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      "10km",
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Card(
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.today_fill,
                  size: 50,
                  color: Colors.green.shade300,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Fuel Consumption",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      "50km",
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Card(
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.today,
                  size: 50,
                  color: Colors.green.shade300,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Fuel Cost",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      "50km",
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Card(
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Icon(
                  Icons.radio,
                  size: 50,
                  color: Colors.green.shade300,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Engine Work",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      "3s",
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Card(
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Icon(
                  Icons.hide_image_outlined,
                  size: 50,
                  color: Colors.green.shade300,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Engine Idle",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      "50km",
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class VehicleLiveTrackingStatus2 extends StatelessWidget {
  const VehicleLiveTrackingStatus2({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Container(width: 30, child: const Text("\n\nGPS")),
            CircleAvatar(
              backgroundColor: Colors.grey.shade500,
              child: const Icon(
                CupertinoIcons.location_solid,
                color: Colors.white,
              ),
            ),
            const Text("OFF"),
          ],
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          children: [
            const Text("\n\nGSM"),
            CircleAvatar(
              backgroundColor: Colors.grey.shade500,
              child: const Icon(
                CupertinoIcons.wifi,
                color: Colors.white,
              ),
            ),
            const Text("OFF"),
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          children: [
            Container(width: 50, child: const Text("\n\nIgnition")),
            CircleAvatar(
              backgroundColor: Colors.grey.shade500,
              child: const Icon(
                Icons.key,
                color: Colors.white,
              ),
            ),
            const Text("OFF"),
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                child: const Text(
              "\nFuel\nLevel",
              textAlign: TextAlign.center,
            )),
            CircleAvatar(
              backgroundColor: Colors.grey.shade500,
              child: const Icon(
                Icons.launch,
                color: Colors.white,
              ),
            ),
            const Text("OFF"),
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          children: [
            const Text(
              "\nEngine\nLoad",
              textAlign: TextAlign.center,
            ),
            CircleAvatar(
              backgroundColor: Colors.grey.shade500,
              child: const Icon(
                Icons.lan,
                color: Colors.white,
              ),
            ),
            const Text("OFF"),
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          children: [
            const Text("\n\nRPM"),
            CircleAvatar(
              backgroundColor: Colors.grey.shade500,
              child: const Icon(
                CupertinoIcons.dot_radiowaves_left_right,
                color: Colors.white,
              ),
            ),
            const Text("100r/m"),
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          children: [
            const Text(
              "\nVoltage\nControl",
              textAlign: TextAlign.center,
            ),
            CircleAvatar(
              backgroundColor: Colors.grey.shade500,
              child: const Icon(
                Icons.warning,
                color: Colors.white,
              ),
            ),
            const Text("3v"),
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          children: [
            const Text(
              "\nBarometer\nPressure",
              textAlign: TextAlign.center,
            ),
            CircleAvatar(
              backgroundColor: Colors.grey.shade500,
              child: const Icon(
                CupertinoIcons.drop_triangle,
                color: Colors.white,
              ),
            ),
            const Text("OFF"),
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          children: [
            const Text(
              "\nTemperature\nAmbient Air",
              textAlign: TextAlign.center,
            ),
            CircleAvatar(
              backgroundColor: Colors.grey.shade500,
              child: const Icon(
                CupertinoIcons.thermometer,
                color: Colors.white,
              ),
            ),
            const Text("OFF"),
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          children: [
            const Text("\n\nGPS"),
            CircleAvatar(
              backgroundColor: Colors.grey.shade500,
              child: const Icon(
                CupertinoIcons.location_solid,
                color: Colors.white,
              ),
            ),
            const Text("OFF"),
          ],
        ),
      ],
    );
  }
}
