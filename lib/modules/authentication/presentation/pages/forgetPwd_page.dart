import 'package:ctntelematics/modules/authentication/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.local_shipping, color: Colors.green, size: 40),
                const SizedBox(width: 8),
                Text(
                  'CTN',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green.withOpacity(0.4), fontSize: 28),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Telematics',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Forgot Password Heading
            const Text(
              'Forgot password?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),

            // Instruction Text
            Text(
              'Unlock your account with a simple password reset. Please enter your username or email',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),

            Form(
              key: _formKey,
                child:  TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Enter your email',
                    hintText: 'francisjoe@gmail.com',
                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.green),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value){
                    if(value!.isEmpty){
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
                    context,
                    "/verifyEmail",
                        (route) => false,
                    arguments: {
                      'email': _emailController.text.trim()
                    }
                  );
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
                return  ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final genOtpReqEntity = GenOtpReqEntity(
                          email: _emailController.text.trim());
                      context
                          .read<GenerateOtpBloc>()
                          .add(GenerateOtpEvent(genOtpReqEntity));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Submit mail',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              },
            ),
            // Submit Button

            const SizedBox(height: 20),

            // Back to Login Button
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              label: const Text(
                'Back to login',
                style: TextStyle(color: Colors.black),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
