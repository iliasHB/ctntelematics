import 'dart:async';

import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../domain/entities/auth_req_entites/verify_email_req_entity.dart';
import '../bloc/auth_bloc.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController pinOne = TextEditingController();

  final TextEditingController pinTwo = TextEditingController();

  final TextEditingController pinThree = TextEditingController();

  final TextEditingController pinFour = TextEditingController();

  // final TextEditingController pinFive = TextEditingController();
  //
  // final TextEditingController pinSix = TextEditingController();

  String? _otp;
  bool isVerifyOtp = false;
  String currentText = "";
  bool hasError = false;
  late Timer _timer;
  int _start = 300;
  bool isLoading = false;
  // SignUpRespModel? feedback;
  bool isSignupPage = true;
  // OtpResModel? otp;
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo and title
            Image.asset(
              "assets/images/tematics_name.jpeg",
              height: 100,
            ),
            const SizedBox(height: 40),

            // Forgot Password Heading
            Text('Forgot password?',
                textAlign: TextAlign.center,
                style: AppStyle.cardTitle.copyWith(color: Colors.green[700])),
            const SizedBox(height: 8),

            // Instruction Text
            Text(
              'We already sent a password reset link to your email ${args['email']}',
                textAlign: TextAlign.center,
                style: AppStyle.cardfooter
                    .copyWith(fontSize: 12, color: Colors.grey[600])),
            const SizedBox(height: 20),
            Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OtpInput(pinOne),
                    OtpInput(pinTwo),
                    OtpInput(pinThree),
                    OtpInput(pinFour),
                    // OtpInput(pinFive),
                    // OtpInput(pinSix),
                  ],
                )),
            const SizedBox(height: 20),

            BlocConsumer<EmailVerifyBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthDone) {
                  // Navigator.pushNamed(context, "/resetPassword");
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/resetPassword", (route) => false,
                      arguments: {
                        'email': args['email'],
                        'otp': _otp,
                      });
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.resp.message)));
                } else if (state is AuthFailure) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const CircularProgressIndicator(
                    strokeWidth: 2,
                    strokeAlign: -10.0,
                  );
                }
                return CustomPrimaryButton(
                  label:  'Continue',
                  onPressed: () {
                    setState(() {
                      _otp = pinOne.text +
                          pinTwo.text +
                          pinThree.text +
                          pinFour.text;
                      // pinFive.text +
                      // pinSix.text;
                    });
                    print(_otp);

                    if (_formKey.currentState?.validate() ?? false) {
                      final verifyEmailReqEntity = VerifyEmailReqEntity(
                          email: args['email'], otp: _otp.toString());
                      context
                          .read<EmailVerifyBloc>()
                          .add(VerifyEmailEvent(verifyEmailReqEntity));
                    }
                  },
                );

                //   ElevatedButton(
                //   onPressed: () {
                //     setState(() {
                //       _otp = pinOne.text +
                //           pinTwo.text +
                //           pinThree.text +
                //           pinFour.text;
                //       // pinFive.text +
                //       // pinSix.text;
                //     });
                //     print(_otp);
                //
                //     if (_formKey.currentState?.validate() ?? false) {
                //       final verifyEmailReqEntity = VerifyEmailReqEntity(
                //           email: args['email'], otp: _otp.toString());
                //       context
                //           .read<EmailVerifyBloc>()
                //           .add(VerifyEmailEvent(verifyEmailReqEntity));
                //     }
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.green,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //   ),
                //   child: const Padding(
                //     padding: EdgeInsets.symmetric(vertical: 16.0),
                //     child: Text(
                //       'Continue',
                //       style: TextStyle(fontSize: 18),
                //     ),
                //   ),
                // );
              },
            ),
            const SizedBox(height: 20),

            // Back to Login Button

            CustomSecondaryButton(
                label:  'Back to login',
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/login", (route) => false);
              },
            ),

            // TextButton.icon(
            //   onPressed: () {
            //     Navigator.pushNamedAndRemoveUntil(
            //         context, "/login", (route) => false);
            //   },
            //   icon: const Icon(Icons.arrow_back, color: Colors.black),
            //   label: const Text(
            //     'Back to login',
            //     style: TextStyle(color: Colors.black),
            //   ),
            //   style: TextButton.styleFrom(
            //     padding: const EdgeInsets.symmetric(vertical: 16.0),
            //     shape: RoundedRectangleBorder(
            //       side: const BorderSide(color: Colors.black),
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 20),
            Center(
              child: RichText(
                text: TextSpan(
                  text: "Didn\'t receive the email ",
                  // textAlign: TextAlign.center,
                  style: AppStyle.cardfooter.copyWith(fontSize: 12, color: Colors.grey[700]),
                  children: const <TextSpan>[
                    TextSpan(
                      text: 'Click to resend',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  OtpInput(TextEditingController controller) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextFormField(
          //autofocus: autoFocus,
          textAlign: TextAlign.center,
          cursorHeight: 20,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.black, fontSize: 20.0),
          controller: controller,
          maxLength: 1,
          // cursorColor: Colors.white,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green, width: 2.0),
              ),
              // enabledBorder: UnderlineInputBorder(
              //   borderSide: BorderSide(color: Colors.white, width: 2.0),
              // ),
              counterText: '',
              hintStyle: TextStyle(color: Colors.white, fontSize: 30.0)),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "";
            }
            return null;
          },
          onChanged: (value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            }
            if (value.isEmpty) {
              FocusScope.of(context).previousFocus();
            }
          }),
    );
  }
}
