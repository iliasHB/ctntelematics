import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/core/widgets/custom_button.dart';
import 'package:ctntelematics/modules/authentication/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/custom_input_decorator.dart';
import '../../domain/entities/auth_req_entites/gen_otp_req_entity.dart';

class ForgotPasswordPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  ForgotPasswordPage({super.key});
  @override
  Widget build(BuildContext context) {
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
                'Unlock your account with a simple password reset. Please enter your username or email',
                textAlign: TextAlign.center,
                style: AppStyle.cardfooter
                    .copyWith(fontSize: 12, color: Colors.grey[600])),
            const SizedBox(height: 20),

            Form(
              key: _formKey,
              child: TextFormField(
                controller: _emailController,
                cursorColor: Colors.green,
                decoration: customInputDecoration(
                  labelText: 'Enter your email',
                  hintText: 'abc@gmail.com',
                  prefixIcon:
                      const Icon(Icons.email_outlined, color: Colors.green),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "email can not be empty";
                  }
                  return null;
                },
              ),
            ),
            // Email Field

            const SizedBox(height: 20),

            BlocConsumer<GenerateOtpBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthDone) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/verifyEmail", (route) => false,
                      arguments: {'email': _emailController.text.trim()});
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
                  label: 'Submit mail',
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final genOtpReqEntity =
                          GenOtpReqEntity(email: _emailController.text.trim());
                      context
                          .read<GenerateOtpBloc>()
                          .add(GenerateOtpEvent(genOtpReqEntity));
                    }
                  },
                );
                //   ElevatedButton(
                //   onPressed: () {
                //     if (_formKey.currentState?.validate() ?? false) {
                //       final genOtpReqEntity = GenOtpReqEntity(
                //           email: _emailController.text.trim());
                //       context
                //           .read<GenerateOtpBloc>()
                //           .add(GenerateOtpEvent(genOtpReqEntity));
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
                //       'Submit mail',
                //       style: TextStyle(fontSize: 18),
                //     ),
                //   ),
                // );
              },
            ),
            // Submit Button

            const SizedBox(height: 20),

            // Back to Login Button
            CustomSecondaryButton(
              label: 'Back to login',
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
