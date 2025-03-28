import 'dart:io';

import 'package:ctntelematics/config/theme/app_style.dart';
import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/core/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../usecase/databse_helper.dart';
import '../usecase/provider_usecase.dart';

class AnimatedAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String firstname;
  final String pageRoute;
  final Function(bool?)? onVehiclePerformanceSelected,
      onMileageSelected,
      onOdometerSelected,
      onMaintenanceReminderSelected,
      onFaultCodesSelected,
      onShopNowSelected,
      onQuickLinkSelected;

  const AnimatedAppBar(
      {super.key, required this.firstname,
      this.onVehiclePerformanceSelected,
      this.onMileageSelected,
      this.onOdometerSelected,
      this.onMaintenanceReminderSelected,
      this.onFaultCodesSelected,
      this.onShopNowSelected,
      this.onQuickLinkSelected,
      required this.pageRoute});

  @override
  _AnimatedAppBarState createState() => _AnimatedAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AnimatedAppBarState extends State<AnimatedAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  PrefUtils prefUtils = PrefUtils();
  bool vehiclePerformance = false;
  bool mileage = false;
  bool odometer = false;
  bool maintenanceReminder = false;
  bool faultCodes = false;
  bool shopNow = false;
  bool quickLink = false;
  File? _image;
  String? token;
  String? userId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getAuthUser();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Start off-screen to the right
      end: Offset.zero, // End at the original position
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
    // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _getAuthUser() async {
    List<String>? authUser = await prefUtils.getStringList('auth_user');
    setState(() {
      // first_name = authUser![0] == "" ? null : authUser[0];
      // last_name = authUser[1] == "" ? null : authUser[1];
      // middle_name = authUser[2] == "" ? null : authUser[2];
      // email = authUser[3] == "" ? null : authUser[3];
      token = authUser?[4] == "" ? null : authUser?[4];
      userId = authUser?[8] == "" ? null : authUser?[8];
      isLoading = false;
    });
  }

  Future<void> pickAndSaveProfilePicture(int userId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final filePath = pickedFile.path;
      final uploadedAt =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      // Save to the database
      final dbHelper = DatabaseHelper();
      await dbHelper.insertProfilePicture({
        'userId': userId,
        'filePath': filePath,
        'uploadedAt': uploadedAt,
      });
      
      // Update the state
      setState(() {
        _image = File(filePath); // Update the in-memory image file
      });
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No image selected."),
          // duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        );
      // );
      print('No image selected.');
    }
  }

  Future<void> pickAndUpdateProfilePicture(int userId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final filePath = pickedFile.path;
      final uploadedAt =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      // Save to the database
      final dbHelper = DatabaseHelper();

      // Update the profile picture for the given userId
      await dbHelper.updateProfilePicture(userId, {
        'filePath': filePath,
        'uploadedAt': uploadedAt,
      });
      // Update the UI
      setState(() {
        _image = File(filePath);
      });
    } else {
      const SnackBar(
        content: Text("No image selected."),
        // duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      );
      print('No image selected.');
    }
  }

  Future<String?> fetchUserProfilePicture(int userId) async {
    final dbHelper = DatabaseHelper();
    final picture = await dbHelper.fetchLatestProfilePicture(
        userId); // Fetch the latest picture as a single map

    if (picture != null) {
      return picture['filePath']
          as String?; // Return the file path if available
    }

    return null; // Return null if no picture is found
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        // centerTitle: false,
        title:  Center(child: Text(widget.pageRoute)),
        actions: [
          widget.pageRoute == 'Dashboard' || widget.pageRoute == 'Vehicle'
              ? Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: InkWell(
                    onTap: () {
                      widget.pageRoute == 'Vehicle Tracking'
                          ? IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.green,
                              ))
                          : Navigator.pushNamed(context, '/map');
                    },
                    child: Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              // color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Image.asset(
                              "assets/images/map_icon.png",
                              height: 40,
                              width: 40,
                            )),
                        const Center(child: Text("")),
                      ],
                    ),
                  ),
                )
              : Container(),
              // widget.pageRoute == 'map'
              //         ? Padding(
              //             padding: const EdgeInsets.only(left: 50.0),
              //             child: Text(
              //               'Vehicle tracking',
              //               style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
              //             ),
              //           )
              //         :
          ///
              Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Center(
                    child: Text(
                      widget.pageRoute,
                      style: AppStyle.cardSubtitle.copyWith(fontSize: 16),
                    ),
                  ),
                ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/setting');
              },
              child: CircleAvatar(
                backgroundColor: Colors.green.shade100,
                child: const Icon(
                  Icons.settings_outlined,
                  size: 20,
                ),
              ),
            ),
          ),

          widget.pageRoute != 'Dashboard'
              ? Container()
              : Align(
                  alignment: Alignment.topLeft,
                  child: PopupMenuButton(
                      //icon: const Icon(CupertinoIcons.rectangle_grid_2x2, size: 20,),
                      position: PopupMenuPosition.under,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                        child: CircleAvatar(
                            backgroundColor: Colors.green.shade100,
                            child: const Icon(
                              CupertinoIcons.rectangle_grid_2x2_fill,
                              size: 20,
                            )),
                      ),
                      itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Customize your dashboard',
                                      style: AppStyle.cardSubtitle
                                          .copyWith(fontSize: 14)),
                                  Text(
                                    'Select the information you want to display on your dashboard',
                                    style: AppStyle.cardfooter
                                        .copyWith(fontSize: 12),
                                    // softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 1,
                              onTap: () {
                                // _setDateRange(3); // 3 days ago
                              },
                              child:
                                  StatefulBuilder(builder: (context, setState) {
                                return Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.cart,
                                      size: 20,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text("Shop Now"),
                                    const Spacer(),
                                    Consumer<ShopNowProvider>(
                                      builder:
                                          (context, shopNowProvider, child) {
                                        return Checkbox(
                                            activeColor: Colors.green,
                                            checkColor: Colors.white,
                                            value: shopNowProvider.isShopNow,
                                            onChanged: (value) {
                                              shopNowProvider
                                                  .toggleShopNow(value!);
                                              // widget.onMaintenanceReminderSelected!(value);
                                              // });
                                            });
                                      },
                                    )
                                  ],
                                );
                              }),
                            ),
                            PopupMenuItem(
                              value: 2,
                              onTap: () {
                                // _setDateRange(3); // 3 days ago
                              },
                              child:
                                  StatefulBuilder(builder: (context, setState) {
                                return Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.rocket,
                                      size: 20,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text("Maintenance Reminder"),
                                    const Spacer(),
                                    Consumer<MaintenanceReminderProvider>(
                                      builder: (context,
                                          maintenanceReminderProvider, child) {
                                        return Checkbox(
                                            activeColor: Colors.green,
                                            checkColor: Colors.white,
                                            value: maintenanceReminderProvider
                                                .isMaintenanceReminder,
                                            onChanged: (value) {
                                              maintenanceReminderProvider
                                                  .toggleMaintenanceReminder(
                                                      value!);
                                            });
                                      },
                                    )
                                  ],
                                );
                              }),
                            ),
                            PopupMenuItem(
                              value: 3,
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  return Row(
                                    children: [
                                      const Icon(
                                        Icons.roundabout_right_outlined,
                                        size: 20,
                                        color: Colors.green,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text("Vehicle Trip"),
                                      const Spacer(),
                                      Consumer<VehicleTripProvider>(
                                        builder: (context, vehicleTripProvider,
                                            child) {
                                          return Checkbox(
                                              activeColor: Colors.green,
                                              checkColor: Colors.white,
                                              value: vehicleTripProvider
                                                  .isVehicleTrip,
                                              onChanged: (value) {
                                                vehicleTripProvider
                                                    .toggleVehicleTrip(value!);
                                              });
                                        },
                                      )

                                    ],
                                  );
                                },
                              ),
                            ),

                            PopupMenuItem(
                              value: 5,
                              onTap: () {
                                // _setDateRange(3); // 3 days ago
                              },
                              child:
                                  StatefulBuilder(builder: (context, setState) {
                                return Row(
                                  children: [
                                    const Icon(
                                      Icons.assistant_direction_outlined,
                                      size: 20,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text("Odometer"),
                                    const Spacer(),
                                    Consumer<OdometerProvider>(builder:
                                        (context, odometerProvider, child) {
                                      return Checkbox(
                                          activeColor: Colors.green,
                                          checkColor: Colors.white,
                                          value: odometerProvider.isOdometer,
                                          onChanged: (value) {
                                            odometerProvider
                                                .toggleOdometer(value!);
                                          });
                                    })
                                  ],
                                );
                              }),
                            ),
                          ]),
                ),
        ],
      ),
    );
  }
}

class DashboardDialogUtility {
  static showVehicleSearchDialog(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierDismissible: true,
      // transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            // Added Material widget here
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.only(top: 100),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height *
                      0.6), // Dynamic height
              width: 380,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Customize your dashboard',
                                  style: AppStyle.cardSubtitle,
                                ),
                                const Spacer(),
                                IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.cancel_outlined))
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    'Select the information you want to display on your dashboard',
                                    style: AppStyle.cardfooter,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: anim1,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

//
// AppBar appBar(context, {required firstname}){
//   return AppBar(
//       elevation: 0,
//       backgroundColor: Colors.white,
//       // title: const Text(
//       //   'Dashboard',
//       //   style: TextStyle(color: Colors.black),
//       // ),
//       centerTitle: true,
//       actions: [
//         Padding(
//           padding: const EdgeInsets.only(right: 8.0),
//           child: InkWell(
//             onTap: (){
//               //Navigator.pushNamed(context, '/service');
//             },
//             child: CircleAvatar(
//               backgroundColor: Colors.green.shade100,
//               child: const Icon(Icons.home_repair_service),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(right: 8.0),
//           child: InkWell(
//             onTap: (){
//               Navigator.pushNamed(context, '/setting');
//             },
//             child: CircleAvatar(
//               backgroundColor: Colors.green.shade100,
//               child: const Icon(Icons.settings_outlined),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(right: 8.0),
//           child: InkWell(
//             onTap: (){
//                 // Navigator.pushNamed(context, "/service");
//                 showModalBottomSheet(
//                     context: context,
//                     isDismissible: false,
//                     isScrollControlled: true,
//                     //useSafeArea: true,
//                     shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(20),
//                           topRight: Radius.circular(20)),
//                     ),
//                     builder: (BuildContext context) {
//                       return const NotificationWidget();
//                     });
//             },
//             child: CircleAvatar(
//               backgroundColor: Colors.green.shade100,
//               child: const Icon(CupertinoIcons.bell_fill),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(right: 16.0),
//           child: InkWell(
//             onTap: (){}, //Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage(firstname))),
//             child: Container(
//               padding: const EdgeInsets.all(5.0),
//               decoration: BoxDecoration(
//                   color: Colors.grey.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(50.0)),
//               child: Row(
//                 children: [
//                   const CircleAvatar(
//                     //backgroundImage: AssetImage('assets/images/avatar.png'), // Replace with actual user avatar image
//                   ),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   Text("Welcome, ${firstname}")
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//
// }
