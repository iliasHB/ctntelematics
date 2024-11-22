import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/auth_req_entites/change_pwd_req_entity.dart';
import '../bloc/auth_bloc.dart';

class ResetPasswordPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final _pwdController = TextEditingController();
    final _retypePwdController = TextEditingController();
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
              'Set A New Password?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),

            // Instruction Text
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CircleAvatar(radius: 2, backgroundColor: Colors.black,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    '- New password must be different from the \nprevious password.',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CircleAvatar(radius: 2, backgroundColor: Colors.black,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    '- Password must include alphabet numeric & \ncharacter',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            // New password Field
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _pwdController,
                    decoration: InputDecoration(
                      labelText: 'New password',
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
                        return "password can not be empty";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),
                  // New password Field
                  TextFormField(
                    controller: _retypePwdController,
                    decoration: InputDecoration(
                      labelText: 'Confirm password',
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
                        return "password can not be empty";
                      } else if (value !=  _pwdController.text){
                        return "password is not the same";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            BlocConsumer<ChangePwdBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthDone) {
                  Navigator.pushNamed(context, "/response");
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
                return ElevatedButton(
                  onPressed: () {

                    if (_formKey.currentState?.validate() ?? false) {
                      final changePwdReqEntity = ChangePwdReqEntity(
                          email: args['email'],
                          otp: args['otp'],
                          password: _pwdController.text.trim(),
                          passwordConfirmation: _retypePwdController.text.trim()
                      );
                      context.read<EmailVerifyBloc>().add(ChangePwdEvent(changePwdReqEntity));
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
                      'Continue',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              },
            ),

            // // Submit Button
            // ElevatedButton(
            //   onPressed: () => Navigator.pushNamed(context, "/response"),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.green,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 16.0),
            //     child: Text(
            //       'Continue',
            //       style: TextStyle(fontSize: 18),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
