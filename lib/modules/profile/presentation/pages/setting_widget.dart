import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/gen_otp_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/token_req_entity.dart';
import 'package:ctntelematics/modules/profile/presentation/bloc/profile_bloc.dart';
import 'package:ctntelematics/modules/profile/presentation/widgets/maintenance.dart';
import 'package:ctntelematics/modules/profile/presentation/widgets/privacy_policy_widget.dart';
import 'package:ctntelematics/modules/profile/presentation/widgets/report_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../core/usecase/provider_usecase.dart';
import '../../../../core/utils/app_export_util.dart';
import '../../../../core/utils/pref_util.dart';
import '../widgets/change_dialog.dart';
import '../widgets/expenses_widget.dart';
import '../widgets/geofence_setting.dart';
import '../widgets/notification_widget.dart';
import '../widgets/pay_now_widget.dart';
import '../widgets/refer_widget.dart';
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
  bool isGeofence = false;
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Settings", style: AppStyle.cardTitle),
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
                      const CircleAvatar(
                        radius: 25,
                        child: Icon(Icons.person_outline),
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
                      const CircleAvatar(
                        child: Icon(CupertinoIcons.bell_fill),
                      )
                    ],
                  ),
                ),
              ),
              Card(
                shadowColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
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
                                return Switch(
                                  value: geofenceProvider.isGeofence,
                                  onChanged: (value) {
                                    geofenceProvider.toggleGeofence(value);
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
                              Icon(
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
                                  builder: (context) => Maintenance(token: token)));
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
                              Icon(
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
                              Icon(
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
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      BlocConsumer<ProfileGenerateOtpBloc, ProfileState>(
                        listener: (context, state) {
                          if (state is ProfileDone) {
                            ChangePwdDialog.showChangePwdDialog(context, email);
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
                          return Container(
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
                                InkWell(
                                  onTap: () {
                                    final genOtpReqEntity = GenOtpReqEntity(
                                        email: email.toString());
                                    context.read<ProfileGenerateOtpBloc>().add(
                                        ProfileGenOtpEvent(genOtpReqEntity));
                                    // ChangePwdDialog.showChangePwdDialog(context, email);
                                  },
                                  child: const Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationWidget()));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              const Icon(
                                CupertinoIcons.bell,
                                color: Colors.green,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text("Notification", style: AppStyle.cardfooter),
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
                              Icon(
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
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         (MaterialPageRoute(
                      //             builder: (context) =>
                      //                 VehicleExpensesWidget())));
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
                      //         Text("Expenses", style: AppStyle.cardfooter),
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
                                  builder: (context) => const PrivacyPolicy())));
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
                              Text("Privacy Policy", style: AppStyle.cardfooter),
                              const Spacer(),
                              Icon(
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
                        listener: (context, state) {
                          if (state is ProfileDone) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                                  (route) => false,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(state.resp.message)));
                          } else if (state is ProfileFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)));
                          }
                        },
                        builder: (context, state) {
                          if (state is ProfileLoading) {
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
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
                                      Text("Logout", style: AppStyle.cardfooter),
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
                          return Container(
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
                                Text("Logout",
                                    style: AppStyle.cardfooter),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    final tokenReqEntity =
                                    TokenReqEntity(token: token.toString());
                                    context
                                        .read<LogoutBloc>()
                                        .add(LogoutEvent(tokenReqEntity));
                                  },
                                  child: const Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    size: 15,
                                  ),
                                )
                              ],
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
