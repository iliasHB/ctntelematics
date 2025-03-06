import 'dart:io';

import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/gen_otp_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/token_req_entity.dart';
import 'package:ctntelematics/modules/profile/presentation/bloc/profile_bloc.dart';
import 'package:ctntelematics/modules/profile/presentation/widgets/maintenance.dart';
import 'package:ctntelematics/modules/profile/presentation/widgets/privacy_policy_widget.dart';
import 'package:ctntelematics/modules/profile/presentation/widgets/report_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/model/token_req_entity.dart';
import '../../../../core/usecase/databse_helper.dart';
import '../../../../core/usecase/provider_usecase.dart';
import '../../../../core/utils/app_export_util.dart';
import '../../../../core/utils/pref_util.dart';
import '../../../../service_locator.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../map/presentation/bloc/map_bloc.dart';
import '../../../websocket/domain/entitties/resp_entities/vehicle_entity.dart';
import '../../../websocket/presentation/bloc/vehicle_location_bloc.dart';
import '../widgets/change_dialog.dart';
import '../widgets/change_pwd_widget.dart';
import '../widgets/expenses_widget.dart';
import '../widgets/notification_widget.dart';
import '../widgets/support_widget.dart';
import '../widgets/term_use_widget.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  PrefUtils prefUtils = PrefUtils();
  String? first_name;
  String? last_name;
  String? middle_name;
  String? email;
  String? token;
  String? userId;
  bool isGeofence = false;
  DB_notification db_notification = DB_notification();
  File? _image;
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
      first_name = authUser?[0] == "" ? null : authUser?[0];
      last_name = authUser?[1] == "" ? null : authUser?[1];
      middle_name = authUser?[2] == "" ? null : authUser?[2];
      email = authUser?[3] == "" ? null : authUser?[3];
      token = authUser?[4] == "" ? null : authUser?[4];
      userId = authUser?[8] == "" ? null : authUser?[8];
    });
  }

  Future<void> pickAndSaveProfilePicture(int userId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final filePath = pickedFile.path;
      final uploadedAt =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      print('userId: $userId');

      // Save to the database
      final dbHelper = DatabaseHelper();
      await dbHelper.insertProfilePicture({
        'userId': userId,
        'filePath': filePath,
        'uploadedAt': uploadedAt,
      });

      print('Profile picture saved: $filePath');
      // Update the state
      setState(() {
        _image = File(filePath); // Update the in-memory image file
      });
    } else {
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

      print('UserId: $userId');

      // Save to the database
      final dbHelper = DatabaseHelper();

      // Update the profile picture for the given userId
      await dbHelper.updateProfilePicture(userId, {
        'filePath': filePath,
        'uploadedAt': uploadedAt,
      });

      print('Profile picture updated: $filePath');

      // Update the UI
      setState(() {
        _image = File(filePath);
      });
    } else {
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Settings", style: AppStyle.cardTitle.copyWith(fontSize: 16)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Card(
                shadowColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      FutureBuilder<String?>(
                        future:
                            fetchUserProfilePicture(int.parse(userId ?? '0')),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.0,
                              ),
                            ); // Loading indicator
                          } else if (snapshot.hasError) {
                            return const Icon(Icons.error,
                                color: Colors.red); // Error state
                          } else if (!snapshot.hasData ||
                              snapshot.data == null) {
                            return InkWell(
                              onTap: () {
                                pickAndSaveProfilePicture(int.parse(userId!));
                              },
                              child: const CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(
                                    "assets/images/avatar.jpeg"), // Default avatar
                              ),
                            );
                          } else {
                            return InkWell(
                              onTap: () {
                                pickAndUpdateProfilePicture(int.parse(userId!));
                              },
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: FileImage(
                                    File(snapshot.data!)), // Fetched image
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("$first_name $last_name",
                              style: AppStyle.cardSubtitle),
                          Text(email.toString(),
                              style: AppStyle.cardfooter.copyWith(fontSize: 12))
                        ],
                      ),
                      const Spacer(),
                      BlocBuilder<VehicleLocationBloc, List<VehicleEntity>>(
                        builder: (context, vehicles) {
                          if (vehicles.isEmpty) {
                            return InkWell(
                              onTap: () async {
                                final savedNotifications = await db_notification
                                    .fetchCombinedNotifications();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => NotificationWidget(
                                            notifications:
                                                savedNotifications)));
                              },
                              child: const CircleAvatar(
                                child: Icon(CupertinoIcons.bell_fill),
                              ),
                            );
                          }

                          // Filter vehicles with geofence violations or exceeding speed limits
                          final geofenceNotifications = vehicles.where((v) {
                            return !(v.locationInfo.withinGeofence
                                    ?.isInGeofence ??
                                true);
                          }).toList();

                          final speedLimitNotifications = vehicles.where((v) {
                            final speedLimit = double.tryParse(
                                    v.locationInfo.speedLimit?.toString() ?? '0') ?? 0;
                            final vehicleSpeed = double.tryParse(v
                                        .locationInfo.tracker?.position?.speed
                                        ?.toString() ??
                                    '0') ??
                                0;
                            return vehicleSpeed > speedLimit;
                          }).toList();

                          db_notification.saveNotifications(
                              geofenceNotifications, speedLimitNotifications);

                          return InkWell(
                            onTap: () async {
                              final savedNotifications = await db_notification
                                  .fetchCombinedNotifications();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => NotificationWidget(
                                          notifications: savedNotifications)));
                            },
                            child: const Stack(
                              children: [
                                CircleAvatar(
                                  child: Icon(CupertinoIcons.bell_fill),
                                ),
                                Positioned(
                                    top: 0,
                                    right: 1,
                                    child: Badge(
                                      smallSize: 10.0,
                                    ))
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                shadowColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.map_pin_ellipse,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text("Geofencing setting",
                              style: AppStyle.cardfooter),
                          const Spacer(),
                          Consumer<GeofenceProvider>(
                            builder: (context, geofenceProvider, child) {
                              return Checkbox(
                                value: geofenceProvider.isGeofence,
                                onChanged: (value) {
                                  geofenceProvider.toggleGeofence(value ??
                                      false); // Ensure value isn't null
                                },
                              );
                            },
                          ),
                          // Switch(
                          //     value: isGeofence,
                          //     onChanged: (value){
                          //       setState(() {
                          //         isGeofence = value;
                          //       });
                          //     })
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Report(token: token)));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              const Icon(
                                CupertinoIcons.square_arrow_left,
                                color: Colors.green,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text("Report", style: AppStyle.cardfooter),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios_sharp,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Maintenance(token: token)));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.ac_unit_sharp,
                                color: Colors.green,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text("Maintenance", style: AppStyle.cardfooter),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios_sharp,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Support()));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.support_agent,
                                color: Colors.green,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text("Support", style: AppStyle.cardfooter),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios_sharp,
                                size: 15,
                              )
                            ],
                          ),
                        ),
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => const Refer()));
                      //   },
                      //   child: Container(
                      //     padding: const EdgeInsets.symmetric(vertical: 10),
                      //     child: Row(
                      //       children: [
                      //         const Icon(
                      //           Icons.wine_bar_outlined,
                      //           color: Colors.green,
                      //           size: 20,
                      //         ),
                      //         const SizedBox(
                      //           width: 10,
                      //         ),
                      //         Text("Refer a friend", style: AppStyle.cardfooter),
                      //         const Spacer(),
                      //         Icon(
                      //           Icons.arrow_forward_ios_sharp,
                      //           size: 15,
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              Card(
                shadowColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: Column(
                    children: [
                      BlocConsumer<ProfileGenerateOtpBloc, ProfileState>(
                        listener: (context, state) {
                          if (state is ProfileDone) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ChangePwd(email: email!)));
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (_) => VerifyEmailSettingsPage(
                            //             email: email!)));
                            // ChangePwdDialog.showChangePwdDialog(context, email);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.resp.message)));
                          } else if (state is ProfileFailure) {
                            if (state.message.contains("Unauthenticated")) {
                              Navigator.pushNamed(context, '/login');
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)));
                          }
                        },
                        builder: (context, state) {
                          if (state is ProfileLoading) {
                            return Row(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.lock_outline,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text("Change Password",
                                          style: AppStyle.cardfooter),
                                      // const Spacer(),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  strokeAlign: -10.0,
                                ),
                              ],
                            );
                          }
                          return InkWell(
                            onTap: () {
                              final genOtpReqEntity = GenOtpReqEntity(
                                  email: email.toString());
                              context.read<ProfileGenerateOtpBloc>().add(
                                  ProfileGenOtpEvent(genOtpReqEntity));
                              // ChangePwdDialog.showChangePwdDialog(context, email);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.lock_outline,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text("Change Password",
                                      style: AppStyle.cardfooter),
                                  const Spacer(),
                                  // InkWell(
                                  //   onTap: () {
                                  //     final genOtpReqEntity = GenOtpReqEntity(
                                  //         email: email.toString());
                                  //     context.read<ProfileGenerateOtpBloc>().add(
                                  //         ProfileGenOtpEvent(genOtpReqEntity));
                                  //     // ChangePwdDialog.showChangePwdDialog(context, email);
                                  //   },
                                  //   child:
                                    const Icon(
                                      Icons.arrow_forward_ios_sharp,
                                      size: 15,
                                    ),
                                  // )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) =>
                      //                 NotificationWidget()));
                      //   },
                      //   child: Container(
                      //     padding: const EdgeInsets.symmetric(vertical: 10),
                      //     child: Row(
                      //       children: [
                      //         const Icon(
                      //           CupertinoIcons.bell,
                      //           color: Colors.green,
                      //           size: 20,
                      //         ),
                      //         const SizedBox(
                      //           width: 10,
                      //         ),
                      //         Text("Notification", style: AppStyle.cardfooter),
                      //         const Spacer(),
                      //         const Icon(
                      //           Icons.arrow_forward_ios_sharp,
                      //           size: 15,
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TermOfUse()));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.bedroom_baby_outlined,
                                color: Colors.green,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text("Terms of Use", style: AppStyle.cardfooter),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios_sharp,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         (MaterialPageRoute(
                      //             builder: (context) => PayNowWidget())));
                      //   },
                      //   child: Container(
                      //     padding: const EdgeInsets.symmetric(vertical: 10),
                      //     child: Row(
                      //       children: [
                      //         const Icon(
                      //           Icons.credit_card,
                      //           color: Colors.green,
                      //           size: 20,
                      //         ),
                      //         const SizedBox(
                      //           width: 10,
                      //         ),
                      //         Text("Pay Now", style: AppStyle.cardfooter),
                      //         const Spacer(),
                      //         Icon(
                      //           Icons.arrow_forward_ios_sharp,
                      //           size: 15,
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              (MaterialPageRoute(
                                  builder: (context) =>
                                      VehicleExpensesWidget())));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.credit_card,
                                color: Colors.green,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text("Expenses", style: AppStyle.cardfooter),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_sharp,
                                size: 15,
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              (MaterialPageRoute(
                                  builder: (context) =>
                                      const PrivacyPolicy())));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.privacy_tip_outlined,
                                color: Colors.green,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text("Privacy Policy",
                                  style: AppStyle.cardfooter),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios_sharp,
                                size: 15,
                              )
                            ],
                          ),
                        ),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(vertical: 10),
                      //   child: Row(
                      //     children: [
                      //       const Icon(
                      //         CupertinoIcons.square_arrow_right,
                      //         color: Colors.green,
                      //         size: 20,
                      //       ),
                      //       const SizedBox(
                      //         width: 10,
                      //       ),
                      //       Text("Logout", style: AppStyle.cardfooter),
                      //       const Spacer(),
                      //       BlocConsumer<LogoutBloc, ProfileState>(
                      //         listener: (context, state) {
                      //           if (state is ProfileDone) {
                      //             Navigator.pushNamedAndRemoveUntil(
                      //               context,
                      //               '/login',
                      //               (route) => false,
                      //             );
                      //             ScaffoldMessenger.of(context).showSnackBar(
                      //                 SnackBar(
                      //                     content: Text(state.resp.message)));
                      //           } else if (state is ProfileFailure) {
                      //             ScaffoldMessenger.of(context).showSnackBar(
                      //                 SnackBar(content: Text(state.message)));
                      //           }
                      //         },
                      //         builder: (context, state) {
                      //           if (state is ProfileLoading) {
                      //             return const CircularProgressIndicator(
                      //               strokeWidth: 2.0,
                      //               strokeAlign: -10.0,
                      //             );
                      //           }
                      //           return IconButton(
                      //               onPressed: () {
                      //                 final tokenReqEntity =
                      //                     TokenReqEntity(token: token.toString());
                      //                 context
                      //                     .read<LogoutBloc>()
                      //                     .add(LogoutEvent(tokenReqEntity));
                      //               },
                      //               icon: const Icon(
                      //                 Icons.arrow_forward_ios_sharp,
                      //                 size: 15,
                      //               ));
                      //         },
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      BlocConsumer<LogoutBloc, ProfileState>(
                        listener: (context, state) async {
                          if (state is ProfileDone) {
                            await prefUtils.clearPreferencesData();
                            resetApp();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) => false,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.resp.message)));
                          } else if (state is ProfileFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)));
                          }
                        },
                        builder: (context, state) {
                          if (state is ProfileLoading) {
                            return Row(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        CupertinoIcons.square_arrow_right,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text("Logout",
                                          style: AppStyle.cardfooter),
                                      // const Spacer(),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                const SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0, color: Colors.green,
                                  ),
                                ),
                              ],
                            );
                          }
                          return InkWell(
                            onTap: () {
                              final tokenReqEntity =
                              TokenReqEntity(token: token.toString());
                              context
                                  .read<LogoutBloc>()
                                  .add(LogoutEvent(tokenReqEntity));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.logout,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text("Logout", style: AppStyle.cardfooter),
                                  const Spacer(),
                                  // InkWell(
                                  //   onTap: () {
                                  //     final tokenReqEntity =
                                  //         TokenReqEntity(token: token.toString());
                                  //     context
                                  //         .read<LogoutBloc>()
                                  //         .add(LogoutEvent(tokenReqEntity));
                                  //   },
                                  //   child:
                                    const Icon(
                                      Icons.arrow_forward_ios_sharp,
                                      size: 15,
                                    // ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// final ImagePicker _picker = ImagePicker();
//
// // Function to pick an image from the gallery
// Future<void> _pickImage() async {
//   // Pick an image from the gallery
//   final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//
//   // Check if an image was selected
//   if (pickedFile != null) {
//     setState(() {
//       _image = File(pickedFile.path); // Store the selected image
//     });
//   }
// }
