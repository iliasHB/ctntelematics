import 'dart:async';

import 'package:ctntelematics/config/theme/app_style.dart';
import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/core/widgets/custom_button.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/verify_email_req_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/profile_bloc.dart';
import 'change_pwd_widget.dart';

// class VerifyEmailSettingsPage extends StatefulWidget {
//   final String email;
//   const VerifyEmailSettingsPage({super.key, required this.email});
//
//   @override
//   State<VerifyEmailSettingsPage> createState() =>
//       _VerifyEmailSettingsPageState();
// }
//
// class _VerifyEmailSettingsPageState extends State<VerifyEmailSettingsPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   final TextEditingController pinOne = TextEditingController();
//
//   final TextEditingController pinTwo = TextEditingController();
//
//   final TextEditingController pinThree = TextEditingController();
//
//   final TextEditingController pinFour = TextEditingController();
//
//   // final TextEditingController pinFive = TextEditingController();
//   //
//   // final TextEditingController pinSix = TextEditingController();
//
//   String? _otp;
//   bool isVerifyOtp = false;
//   String currentText = "";
//   bool hasError = false;
//   late Timer _timer;
//   int _start = 300;
//   bool isLoading = false;
//   // SignUpRespModel? feedback;
//   bool isSignupPage = true;
//   // OtpResModel? otp;
//   void startTimer() {
//     const oneSec = Duration(seconds: 1);
//     _timer = Timer.periodic(
//       oneSec,
//       (Timer timer) {
//         if (_start == 0) {
//           setState(() {
//             timer.cancel();
//           });
//         } else {
//           setState(() {
//             _start--;
//           });
//         }
//       },
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _timer.cancel();
//     // pinOne.dispose();
//     // pinTwo.dispose();
//     // pinThree.dispose();
//     // pinFour.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // final args =
//     // ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Logo and title
//             Image.asset(
//               "assets/images/tematics_name.jpeg",
//               height: 100,
//             ),
//             const SizedBox(height: 40),
//
//             // Forgot Password Heading
//             Text('Change Password',
//                 textAlign: TextAlign.center,
//                 style: AppStyle.cardTitle.copyWith(color: Colors.green[700])),
//             const SizedBox(height: 8),
//
//             // Instruction Text
//             Text('We already sent a otp code to your email ${widget.email}',
//                 textAlign: TextAlign.center,
//                 style: AppStyle.cardfooter
//                     .copyWith(fontSize: 12, color: Colors.grey[600])),
//             const SizedBox(height: 20),
//             Form(
//                 key: _formKey,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     OtpInput(pinOne),
//                     OtpInput(pinTwo),
//                     OtpInput(pinThree),
//                     OtpInput(pinFour),
//                     // OtpInput(pinFive),
//                     // OtpInput(pinSix),
//                   ],
//                 )),
//             const SizedBox(height: 20),
//
//             BlocConsumer<ProfileEmailVerifyBloc, ProfileState>(
//               listener: (context, state) {
//                 if (state is ProfileDone) {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) =>
//                               ChangePwd(otp: _otp, email: widget.email)));
//                   // showModalBottomSheet(
//                   //     context: context,
//                   //     isDismissible: false,
//                   //     isScrollControlled: true,
//                   //     //useSafeArea: true,
//                   //     shape: const RoundedRectangleBorder(
//                   //       borderRadius: BorderRadius.only(
//                   //           topLeft: Radius.circular(20),
//                   //           topRight: Radius.circular(20)),
//                   //     ),
//                   //     builder: (BuildContext context) {
//                   //       return ChangePwd(
//                   //           otp: _otp,
//                   //           email: widget.email
//                   //       );
//                   //     });
//
//                   ///--------
//                   // Navigator.pushNamed(
//                   //     context,
//                   //     "/changePwd",
//                   //     arguments: {
//                   //       'otp': _otp,
//                   //       'email': widget.email
//                   //     }
//                   // );
//                   // ChangePwdDialog.showChangePwdDialog(
//                   //     context, widget.email);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(state.resp.message)));
//                 } else if (state is ProfileFailure) {
//                   if (state.message.contains("Unauthenticated")) {
//                     Navigator.pushNamed(context, '/login');
//                   }
//                   ScaffoldMessenger.of(context)
//                       .showSnackBar(SnackBar(content: Text(state.message)));
//                 }
//               },
//               builder: (context, state) {
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
//                             label: 'Continue',
//                             onPressed: () {
//                               setState(() {
//                                 _otp = pinOne.text +
//                                     pinTwo.text +
//                                     pinThree.text +
//                                     pinFour.text;
//                               });
//                               print("oootttppp:  ${_otp}");
//                               print("email:  ${widget.email}");
//                               final verifyEmailReqEntity = VerifyEmailReqEntity(
//                                   email: widget.email, otp: _otp.toString());
//                               context.read<ProfileEmailVerifyBloc>().add(
//                                   ProfileVerifyEmailEvent(
//                                       verifyEmailReqEntity));
//                               // Navigator.pop(context);
//                             },
//                           )),
//                     ),
//                   ],
//                 );
//               },
//             ),
//             const SizedBox(height: 20),
//             CustomPrimaryButton(
//                 label: "Back to setting",
//                 onPressed: () => Navigator.pushNamedAndRemoveUntil(
//                       context,
//                       '/setting',
//                       (route) => false,
//                     )),
//             const SizedBox(height: 20),
//             Center(
//               child: RichText(
//                 text: TextSpan(
//                   text: "Didn\'t receive the email ",
//                   // textAlign: TextAlign.center,
//                   style: AppStyle.cardfooter
//                       .copyWith(fontSize: 12, color: Colors.grey[700]),
//                   children: const <TextSpan>[
//                     TextSpan(
//                       text: 'Click to resend',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   OtpInput(TextEditingController controller) {
//     return SizedBox(
//       width: 50,
//       height: 50,
//       child: TextFormField(
//           //autofocus: autoFocus,
//           textAlign: TextAlign.center,
//           cursorHeight: 20,
//           keyboardType: TextInputType.number,
//           style: const TextStyle(color: Colors.black, fontSize: 20.0),
//           controller: controller,
//           maxLength: 1,
//           // cursorColor: Colors.white,
//           decoration: const InputDecoration(
//               border: OutlineInputBorder(),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.green, width: 2.0),
//               ),
//               // enabledBorder: UnderlineInputBorder(
//               //   borderSide: BorderSide(color: Colors.white, width: 2.0),
//               // ),
//               counterText: '',
//               hintStyle: TextStyle(color: Colors.white, fontSize: 30.0)),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return "";
//             }
//             return null;
//           },
//           onChanged: (value) {
//             if (value.length == 1) {
//               FocusScope.of(context).nextFocus();
//             }
//             if (value.isEmpty) {
//               FocusScope.of(context).previousFocus();
//             }
//           }),
//     );
//   }
// }

///
// class ChangePwdDialog {
//   static showChangePwdDialog(BuildContext context, String? email) {
//     return showGeneralDialog(
//       context: context,
//       barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
//       barrierDismissible: false,
//       pageBuilder: (_, __, ___) {
//         return Align(
//           alignment: Alignment.center,
//           child: Material(
//             // Added Material widget here
//             color: Colors.transparent,
//             child: VerifyOtp(email!)
//           ),
//         );
//       },
//     );
//   }
// }
//
//
// class VerifyOtp extends StatefulWidget {
//   final String email;
//   const VerifyOtp(this.email, {super.key});
//
//   @override
//   State<VerifyOtp> createState() => _VerifyOtpState();
// }
//
// class _VerifyOtpState extends State<VerifyOtp> {
//   final _formKey = GlobalKey<FormState>();
//
//   final TextEditingController pinOne = TextEditingController();
//
//   final TextEditingController pinTwo = TextEditingController();
//
//   final TextEditingController pinThree = TextEditingController();
//
//   final TextEditingController pinFour = TextEditingController();
//
//
//   String? _otp;
//   bool isVerifyOtp = false;
//   String currentText = "";
//   bool hasError = false;
//   late Timer _timer;
//   int _start = 300;
//   bool isLoading = false;
//   // SignUpRespModel? feedback;
//   bool isSignupPage = true;
//   // OtpResModel? otp;
//   void startTimer() {
//     const oneSec = Duration(seconds: 1);
//     _timer = Timer.periodic(
//       oneSec,
//           (Timer timer) {
//         if (_start == 0) {
//           setState(() {
//             timer.cancel();
//           });
//         } else {
//           setState(() {
//             _start--;
//           });
//         }
//       },
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _timer.cancel();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       height: 280,
//       width: 360,
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   'Change Password',
//                   style: AppStyle.cardTitle,
//                 ),
//                 const Spacer(),
//                 IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: const Icon(Icons.cancel_outlined))
//               ],
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'We already sent a password reset link to your email ${widget.email}',
//               //'To Change enter your current password',
//               style: AppStyle.cardfooter,
//             ),
//             const SizedBox(height: 20),
//             Form(
//                 key: _formKey,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     OtpInput(pinOne, context),
//                     OtpInput(pinTwo, context),
//                     OtpInput(pinThree, context),
//                     OtpInput(pinFour, context),
//                   ],
//                 )
//               // TextFormField(
//               //   decoration: InputDecoration(
//               //     labelText: 'Enter password',
//               //     labelStyle: AppStyle.cardfooter,
//               //     hintText: '********',
//               //     hintStyle: AppStyle.cardfooter,
//               //     suffixIcon: Icon(Icons.remove_red_eye),
//               //     filled: true,
//               //     fillColor: Colors.grey[200],
//               //     border: OutlineInputBorder(
//               //       borderRadius: BorderRadius.circular(10),
//               //       borderSide: BorderSide.none,
//               //     ),
//               //     contentPadding: const EdgeInsets.symmetric(horizontal: 10),
//               //   ),
//               // ),
//             ),
//             const SizedBox(height: 20),
//
//             BlocConsumer<ProfileEmailVerifyBloc, ProfileState>(
//               listener: (context, state) {
//                 if (state is ProfileDone) {
//                   Navigator.pop(context);
//                   showModalBottomSheet(
//                       context: context,
//                       isDismissible: false,
//                       isScrollControlled: true,
//                       //useSafeArea: true,
//                       shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(20),
//                             topRight: Radius.circular(20)),
//                       ),
//                       builder: (BuildContext context) {
//                         return ChangePwd(
//                             otp: _otp,
//                             email: widget.email
//                         );
//                       });
//
//                   // Navigator.pushNamed(
//                   //     context,
//                   //     "/changePwd",
//                   //     arguments: {
//                   //       'otp': _otp,
//                   //       'email': widget.email
//                   //     }
//                   // );
//                   // ChangePwdDialog.showChangePwdDialog(
//                   //     context, widget.email);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(state.resp.message)));
//                 } else if (state is ProfileFailure) {
//                   if(state.message.toString().contains("Unauthenticated")){
//                     Navigator.pushNamed(context, '/login');
//                   }
//                   ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(state.message)));
//                 }
//               },
//               builder: (context, state) {
//                 if (state is ProfileLoading) {
//                   return const CircularProgressIndicator(
//                     strokeWidth: 2,
//                     strokeAlign: -10.0,
//                   );
//                 }
//                 return  Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: SizedBox(
//                         height: 50,
//                         child: CustomSecondaryButton(
//                             label: 'Continue',
//                           onPressed: () {
//                             setState(() {
//                               _otp = pinOne.text +
//                                   pinTwo.text +
//                                   pinThree.text +
//                                   pinFour.text;
//                             });
//                             print("oootttppp:  ${_otp}");
//                             print("email:  ${widget.email}");
//                             final verifyEmailReqEntity =
//                             VerifyEmailReqEntity(
//                                 email: widget.email,
//                                 otp: _otp.toString());
//                             context
//                                 .read<ProfileEmailVerifyBloc>()
//                                 .add(ProfileVerifyEmailEvent(verifyEmailReqEntity));
//                             // Navigator.pop(context);
//                           },
//                         )
//
//                         // OutlinedButton(
//                         //     onPressed: () {
//                         //         setState(() {
//                         //           _otp = pinOne.text +
//                         //               pinTwo.text +
//                         //               pinThree.text +
//                         //               pinFour.text;
//                         //         });
//                         //         print("oootttppp:  ${_otp}");
//                         //       print("email:  ${widget.email}");
//                         //         final verifyEmailReqEntity =
//                         //         VerifyEmailReqEntity(
//                         //             email: widget.email,
//                         //             otp: _otp.toString());
//                         //         context
//                         //             .read<ProfileEmailVerifyBloc>()
//                         //             .add(ProfileVerifyEmailEvent(verifyEmailReqEntity));
//                         //       // Navigator.pop(context);
//                         //     },
//                         //     child: Text(
//                         //       'Continue',
//                         //       style: AppStyle.cardSubtitle,
//                         //     )),
//                       ),
//                     ),
//                   ],
//                 );
//                   // IconButton(
//                   //     onPressed: () {
//                   //       setState(() {
//                   //         _otp = pinOne.text +
//                   //             pinTwo.text +
//                   //             pinThree.text +
//                   //             pinFour.text;
//                   //         // pinFive.text +
//                   //         // pinSix.text;
//                   //       });
//                   //       print(_otp);
//                   //       final verifyEmailReqEntity =
//                   //       VerifyEmailReqEntity(
//                   //           email: widget.email,
//                   //           otp: _otp.toString());
//                   //       context
//                   //           .read<ProfileGenerateOtpBloc>()
//                   //           .add(ProfileVerifyEmailEvent(verifyEmailReqEntity));
//                   //       // ChangePwdDialog.showChangePwdDialog(context, email);
//                   //     },
//                   //     icon:  const Icon(
//                   //       Icons.arrow_forward_ios_sharp,
//                   //       size: 15,
//                   //     ));
//               },
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
//
// OtpInput(TextEditingController controller, BuildContext context) {
//     return SizedBox(
//       width: 50,
//       height: 50,
//       child: TextFormField(
//         //autofocus: autoFocus,
//           textAlign: TextAlign.center,
//           cursorHeight: 20,
//           keyboardType: TextInputType.number,
//           style: const TextStyle(color: Colors.black, fontSize: 20.0),
//           controller: controller,
//           maxLength: 1,
//           // cursorColor: Colors.white,
//           decoration: const InputDecoration(
//               border: OutlineInputBorder(),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.green, width: 2.0),
//               ),
//               // enabledBorder: UnderlineInputBorder(
//               //   borderSide: BorderSide(color: Colors.white, width: 2.0),
//               // ),
//               counterText: '',
//               hintStyle: TextStyle(color: Colors.white, fontSize: 30.0)),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return "Empty";
//             }
//             return null;
//           },
//           onChanged: (value) {
//             if (value.length == 1) {
//               FocusScope.of(context).nextFocus();
//             }
//             if (value.isEmpty) {
//               FocusScope.of(context).previousFocus();
//             }
//           }),
//     );
//   }
// }
