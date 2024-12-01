import 'package:ctntelematics/core/widgets/custom_button.dart';
import 'package:ctntelematics/core/widgets/custom_input_decorator.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/change_pwd_req_entity.dart';
import 'package:ctntelematics/modules/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_style.dart';

class ChangePwd extends StatefulWidget {
  final String? otp;
  final String email;
  const ChangePwd({super.key, this.otp, required this.email});

  @override
  State<ChangePwd> createState() => _ChangePwdState();
}

class _ChangePwdState extends State<ChangePwd> {
  bool isPasswordVisible = true;
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _retypePwdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _pwdController.dispose();
    _retypePwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Change Password',
              style: AppStyle.cardSubtitle,
            ),
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
              style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 10),
            Text(
              'Password must contain at least one letter, one symbol, and one number. '
                  'Minimum length is 8 characters',
              style: AppStyle.cardfooter.copyWith(color: Colors.red, fontSize: 12),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter password",
                    style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _pwdController,
                    obscureText: isPasswordVisible,
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: '*********',
                      hintStyle: AppStyle.cardfooter
                          .copyWith(fontSize: 12, color: Colors.grey[600]),
                      labelStyle: AppStyle.cardfooter
                          .copyWith(fontSize: 12, color: Colors.green[800]),
                      filled: true,
                      fillColor: Colors.grey[200],
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password cannot be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Confirm password",
                    style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _retypePwdController,
                    obscureText: isPasswordVisible,
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                      labelText: 'Retype Password',
                      hintText: '*********',
                      hintStyle: AppStyle.cardfooter
                          .copyWith(fontSize: 12, color: Colors.grey[600]),
                      labelStyle: AppStyle.cardfooter
                          .copyWith(fontSize: 12, color: Colors.green[800]),
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
                      suffix: InkWell(
                        onTap: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        child: Icon(
                          isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.green,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Retype password cannot be empty";
                      } else if (value != _pwdController.text) {
                        return "Passwords do not match";
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
                  if (state.message.contains("Unauthenticated")) {
                    Navigator.pushNamed(context, '/login');
                  }
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2.0),
                  );
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: CustomSecondaryButton(
                          label: 'Save',
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              final changePwdReqEntity = ChangePwdReqEntity(
                                email: widget.email,
                                password: _pwdController.text.trim(),
                                otp: widget.otp ?? '',
                                passwordConfirmation:
                                _retypePwdController.text.trim(),
                              );
                              context.read<ProfileChangePwdBloc>().add(
                                ProfileChangePwdEvent(changePwdReqEntity),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


// class _ChangePwdState extends State<ChangePwd> {
//   bool isPasswordVisible = true;
//   @override
//   Widget build(BuildContext context) {
//     final _formKey = GlobalKey<FormState>();
//     final TextEditingController _pwdController = TextEditingController();
//     final TextEditingController _retypePwdController = TextEditingController();
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Text(
//               'Change Password',
//               style: AppStyle.cardSubtitle,
//             )
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Change Password',
//               style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Password must contain at least one letter, one symbol and one number. '
//               'Minimum length is 8 character',
//               style: AppStyle.cardfooter.copyWith(color: Colors.red, fontSize: 12),
//             ),
//             const SizedBox(height: 20),
//             Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Enter password",
//                     style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//
//                   TextFormField(
//                     controller: _pwdController,
//                     // obscureText: isPasswordVisible,
//                     cursorColor: Colors.green,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       hintText: '*********',
//                       hintStyle: AppStyle.cardfooter
//                           .copyWith(fontSize: 12, color: Colors.grey[600]),
//                       labelStyle: AppStyle.cardfooter
//                           .copyWith(fontSize: 12, color: Colors.green[800]),
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return "Password can not be empty";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 15),
//                   Text(
//                     "Confirm password",
//                     style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//
//                   TextFormField(
//                     controller: _retypePwdController,
//                     obscureText: isPasswordVisible,
//                     cursorColor: Colors.green,
//                     decoration:
//
//                     InputDecoration(
//                       labelText: 'retype-password',
//                       hintText: '*********',
//                       hintStyle: AppStyle.cardfooter
//                           .copyWith(fontSize: 12, color: Colors.grey[600]),
//                       labelStyle: AppStyle.cardfooter
//                           .copyWith(fontSize: 12, color: Colors.green[800]),
//                       prefixIcon:
//                       const Icon(Icons.lock_outline, color: Colors.green),
//                       suffix: InkWell(
//                           onTap: () {
//                             setState(() {
//                               isPasswordVisible
//                                   ? isPasswordVisible = false
//                                   : isPasswordVisible = true;
//                             });
//                           },
//                           child: isPasswordVisible
//                               ? const Icon(
//                             Icons.remove_red_eye,
//                             color: Colors.green,
//                           )
//                               : const Icon(
//                             Icons.remove_red_eye_outlined,
//                             color: Colors.green,
//                           )),
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return "Retype password can not be empty";
//                         } else if (value != _pwdController.text) {
//                           return "Password is not the same";
//                         }
//                         return null;
//                       },
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             BlocConsumer<ProfileChangePwdBloc, ProfileState>(
//               listener: (context, state) {
//                 if (state is ProfileDone) {
//                   Navigator.pushNamedAndRemoveUntil(
//                       context, '/responseProfile', (route) => false);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(state.resp.message)));
//                 } else if (state is ProfileFailure) {
//                   if (state.message
//                       .toString()
//                       .contains("Unauthenticated")) {
//                     Navigator.pushNamed(context, '/login');
//                   }
//                   ScaffoldMessenger.of(context)
//                       .showSnackBar(SnackBar(content: Text(state.message)));
//                 }
//               },
//               builder: (BuildContext context, ProfileState state) {
//                 if (state is ProfileLoading) {
//                   return const Center(
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2.0,
//                     ),
//                   );
//                 }
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: SizedBox(
//                           height: 50,
//                           child: CustomSecondaryButton(
//                               label: 'Save',
//                               onPressed: () {
//                                 if (_formKey.currentState?.validate() ??
//                                     false) {
//                                   final changePwdReqEntity =
//                                       ChangePwdReqEntity(
//                                           email: widget.email,
//                                           password:
//                                               _pwdController.text.trim(),
//                                           otp: widget.otp.toString(),
//                                           passwordConfirmation:
//                                               _retypePwdController.text
//                                                   .trim());
//                                   context.read<ProfileChangePwdBloc>().add(
//                                       ProfileChangePwdEvent(
//                                           changePwdReqEntity));
//                                 }
//                               })
//
//                           ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
