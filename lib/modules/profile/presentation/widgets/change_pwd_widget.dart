import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/change_pwd_req_entity.dart';
import 'package:ctntelematics/modules/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_style.dart';

class ChangePwd extends StatelessWidget {
  final String? otp;
  final String email;
  const ChangePwd({super.key, this.otp, required this.email});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _pwdController = TextEditingController();
    final TextEditingController _retypePwdController = TextEditingController();
    return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Text(
                  'Change Password',
                  style: AppStyle.pageTitle,
                )
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Change Password',
                  style: AppStyle.cardTitle,
                ),
                const SizedBox(height: 10),
                Text(
                  'Password must contain at least one letter, one symbol and one number. '
                  'Minimum length is 8 character',
                  style: AppStyle.cardfooter.copyWith(color: Colors.red),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enter password",
                        style: AppStyle.cardSubtitle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: _pwdController,
                        decoration: InputDecoration(
                          // labelText: 'Enter password',
                          // labelStyle: AppStyle.cardfooter,
                          hintText: '********',
                          hintStyle: AppStyle.cardfooter,
                          suffixIcon: const Icon(Icons.remove_red_eye),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password can not be empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Confirm password",
                        style: AppStyle.cardSubtitle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: _retypePwdController,
                        decoration: InputDecoration(
                          // labelText: 'Confirm password',
                          // labelStyle: AppStyle.cardfooter,
                          hintText: '********',
                          hintStyle: AppStyle.cardfooter,
                          suffixIcon: const Icon(Icons.remove_red_eye),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Retype password can not be empty";
                          } else if (value != _pwdController.text) {
                            return "Password is not the same";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                BlocConsumer<ProfileChangePwdBloc, ProfileState>(
                  listener: (context, state) {
                    if (state is ProfileDone) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/responseProfile', (route) => false);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.resp.message)));
                    } else if (state is ProfileFailure) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (BuildContext context, ProfileState state) {
                    if (state is ProfileLoading) {
                      return const CircularProgressIndicator(
                        strokeWidth: 2.0,
                        strokeAlign: -10.0,
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: OutlinedButton(
                                onPressed: () {
                                  final changePwdReqEntity = ChangePwdReqEntity(
                                      email: email,
                                      password: _pwdController.text.trim(),
                                      otp: otp.toString(),
                                      passwordConfirmation:
                                          _retypePwdController.text.trim());
                                  context.read<ProfileChangePwdBloc>().add(
                                      ProfileChangePwdEvent(
                                          changePwdReqEntity));
                                },
                                child: Text(
                                  'Save',
                                  style: AppStyle.cardSubtitle,
                                )),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Expanded(
                //       child: SizedBox(
                //         height: 50,
                //         child: OutlinedButton(
                //             onPressed: (){
                //               Navigator.pop(context);
                //               showModalBottomSheet(
                //                   context: context,
                //                   isDismissible: false,
                //                   isScrollControlled: true,
                //                   //useSafeArea: true,
                //                   shape: const RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.only(
                //                         topLeft: Radius.circular(20),
                //                         topRight: Radius.circular(20)),
                //                   ),
                //                   builder: (BuildContext context) {
                //                     return const ChangePwd();
                //                   });
                //             },
                //             child: Text('Save', style: AppStyle.cardSubtitle,)),
                //       ),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ));
  }
}
