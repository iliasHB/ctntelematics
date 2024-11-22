import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
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
            const SizedBox(height: 10),

            // Username/Email Field
            TextField(
              decoration: InputDecoration(
                labelText: 'firstname',
                hintText: 'francisjoe@gmail.com',
                prefixIcon: const Icon(Icons.person, color: Colors.green),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'middlename',
                hintText: 'francisjoe@gmail.com',
                prefixIcon: const Icon(Icons.person, color: Colors.green),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'lastname',
                hintText: 'francisjoe@gmail.com',
                prefixIcon: const Icon(Icons.person, color: Colors.green),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'phone number',
                hintText: 'francisjoe@gmail.com',
                prefixIcon: const Icon(Icons.call, color: Colors.green),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'email',
                hintText: 'francisjoe@gmail.com',
                prefixIcon: const Icon(Icons.email_outlined, color: Colors.green),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Password Field
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Francisjoe@123',
                prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
                suffixIcon: const Icon(Icons.visibility, color: Colors.green),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),

            TextField(
              decoration: InputDecoration(
                labelText: 'confirm password',
                hintText: 'francisjoe@gmail.com',
                prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Remember me and Forgotten Password
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Row(
            //       children: [
            //         Checkbox(
            //           value: true,
            //           onChanged: (bool? value) {},
            //           activeColor: Colors.green,
            //         ),
            //         const Text('Remember me'),
            //       ],
            //     ),
            //     TextButton(
            //       onPressed: () => Navigator.pushNamed(context, "/forgetPassword"),
            //       child: const Text(
            //         'Forgotten Password?',
            //         style: TextStyle(color: Colors.red),
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 20),

            // Login Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Back to Login Button
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, "/login");
              },
              icon: Icon(Icons.arrow_back, color: Colors.black),
              label: Text(
                'Back to login',
                style: TextStyle(color: Colors.black),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            // Terms & Conditions
            // const Text(
            //   'By successful login you are agreeing with our Terms & Conditions and Privacy Policy.',
            //   textAlign: TextAlign.center,
            //   style: TextStyle(color: Colors.grey, fontSize: 12),
            // ),
          ],
        ),
      ),
    );
  }
}
