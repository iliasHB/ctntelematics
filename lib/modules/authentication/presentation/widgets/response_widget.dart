import 'package:ctntelematics/config/theme/app_style.dart';
import 'package:ctntelematics/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ResponsePage extends StatelessWidget {
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
            Icon(Icons.check_circle_outlined, size: 100, color: Colors.green,),
            const SizedBox(height: 40),

            // Forgot Password Heading
            const Text(
              'Password Reset?',
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
              'You have successfully reset your password click continue to login',
              textAlign: TextAlign.center,
              style: AppStyle.cardfooter
            ),
            const SizedBox(height: 20),

            // Continue button
            CustomPrimaryButton(
                label:  'Continue',
                onPressed: () => Navigator.pushNamed(context, "/login"),)
          ],
        ),
      ),
    );
  }
}
