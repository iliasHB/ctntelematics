import 'package:ctntelematics/config/theme/app_style.dart';
import 'package:ctntelematics/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ResponseProfilePage extends StatelessWidget {
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
            // Image.asset(
            //   "assets/images/tematics_name.jpeg",
            //   height: 100,
            // ),
            // const SizedBox(height: 40),
            const Icon(Icons.check_circle_outlined, size: 100, color: Colors.green,),
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
              'You have successfully change your password',
              textAlign: TextAlign.center,
              style: AppStyle.cardfooter
            ),
            const SizedBox(height: 20),

            // Continue button

            CustomPrimaryButton(
                label: 'Continue',
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, "/logout", (route) => false),
            )
            // ElevatedButton(
            //   onPressed: () => Navigator.pushNamed(context, "/setting"),
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
            // ),
          ],
        ),
      ),
    );
  }
}
