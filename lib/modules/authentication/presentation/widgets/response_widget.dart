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
              style: TextStyle(color: Colors.grey[900]),
            ),
            const SizedBox(height: 20),

            // Continue button
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/login"),
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
            ),
          ],
        ),
      ),
    );
  }
}
