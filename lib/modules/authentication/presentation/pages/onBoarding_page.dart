import 'dart:async';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool _isContentVisible = false; // Track the visibility of the content

  @override
  void initState() {
    super.initState();
    _delayedContentDisplay();
  }

  // Delay the content display
  _delayedContentDisplay() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isContentVisible = true; // Show the content after 1 second
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/background.jpeg'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content (only shown after delay)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20), // Adjust as needed
            child: _isContentVisible // Check if content should be visible
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(), // Pushes content downwards

                // "Track your car" text
                const Text(
                  'Track your car',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),

                // "Sign up" Button
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, "/signup"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.green,
                          backgroundColor: Colors.white, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 50.0),
                          child: Text(
                            'Sign up',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // "Log in" Button
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, "/login"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 50.0),
                          child: Text(
                            'Log in',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            )
                : Center(child: CircularProgressIndicator()), // Show loading indicator while waiting
          ),
        ],
      ),
    );
  }
}



// import 'dart:async';
//
// import 'package:ctntelematics/core/utils/app_export_util.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
//
// class OnboardingPage extends StatefulWidget {
//   @override
//   State<OnboardingPage> createState() => _OnboardingPageState();
// }
//
//
// class _OnboardingPageState extends State<OnboardingPage> {
//
//   @override
//   void initState() {
//     super.initState();
//     handlePageRoute();
//   }
//
//   // Handle page navigation with a delay
//   handlePageRoute() async {
//     Timer(const Duration(seconds: 1), () {
//       if (mounted) { // Ensure the widget is still in the widget tree
//         Navigator.pushNamed(context, '/onboarding_1_screen');
//       }
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background Image
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage(
//                     'assets/images/background.jpeg'), // Replace with the actual path of your image
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//
//           // Content
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: getHorizontalSize(20)),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const Spacer(), // Pushes content downwards
//
//                 // "Track your car" text
//                 const Text(
//                   'Track your car',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//
//                 // "Sign up" Button
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () =>
//                             Navigator.pushNamed(context, "/signup"),
//                         style: ElevatedButton.styleFrom(
//                           foregroundColor: Colors.green,
//                           backgroundColor: Colors.white, // Text color
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: const Padding(
//                           padding: EdgeInsets.symmetric(
//                               vertical: 16.0, horizontal: 50.0),
//                           child: Text(
//                             'Sign up',
//                             style: TextStyle(fontSize: 18),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//
//                 // "Log in" Button
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () => Navigator.pushNamed(context, "/login"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green, // Background color
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: const Padding(
//                           padding: EdgeInsets.symmetric(
//                               vertical: 16.0, horizontal: 50.0),
//                           child: Text(
//                             'Log in',
//                             style: TextStyle(fontSize: 18),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
