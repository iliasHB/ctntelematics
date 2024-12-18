import 'dart:async';
import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  bool _isContentVisible = false; // Track visibility of content
  late AnimationController _animationController; // Controller for animation
  late Animation<Offset> _bounceAnimation; // Bounce animation for slide effect

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _delayedContentDisplay();
  }

  // Set up bounce animations
  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // Animation duration
    );

    // Bounce animation with "bounceOut" effect
    _bounceAnimation = Tween<Offset>(
      begin: const Offset(0.0, 2.0), // Start far below the screen
      end: Offset.zero, // End at its original position
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceOut, // Bounce-out effect
    ));
  }

  // Delay the content display
  _delayedContentDisplay() async {
    await Future.delayed(const Duration(seconds: 2)); // Wait for 2 seconds
    if (mounted) {
      setState(() {
        _isContentVisible = true; // Show the content
      });
      _animationController.forward(); // Trigger the bounce animation
    }
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose controller to avoid memory leaks
    super.dispose();
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

          // Content with Bounce Animation
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20), // Adjust padding
            child: _isContentVisible
                ? SlideTransition(
                    position: _bounceAnimation, // Bounce animation
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(), // Push content downward

                        // "Track your car" text
                      Text('Track your car',
                          style: AppStyle.cardTitle
                              .copyWith(color: Colors.white)),
                      const SizedBox(height: 40),

                        // "Sign up" Button
                        Row(
                          children: [
                            Expanded(
                                child: CustomPrimaryButton(
                              label: "Login",
                              onPressed: () =>
                                  Navigator.pushNamed(context, "/login"),
                            )),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // "Log in" Button
                        Row(
                          children: [
                            Expanded(
                                child: CustomSecondaryButton(
                              label: 'Sign up',
                              signup: 1,
                              onPressed: () =>
                                  Navigator.pushNamed(context, "/signup"),
                            )),
                          ],
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  )
                : Center(
                    child: Image.asset(
                      "assets/images/tematics_name.jpeg",
                      height: 100,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// class OnboardingPage extends StatefulWidget {
//   @override
//   State<OnboardingPage> createState() => _OnboardingPageState();
// }
//
// class _OnboardingPageState extends State<OnboardingPage> {
//   bool _isContentVisible = false; // Track the visibility of the content
//
//   @override
//   void initState() {
//     super.initState();
//     _delayedContentDisplay();
//   }
//
//   // Delay the content display
//   _delayedContentDisplay() async {
//     await Future.delayed(const Duration(seconds: 5));
//     if (mounted) {
//       setState(() {
//         _isContentVisible = true; // Show the content after 1 second
//       });
//     }
//   }
//
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
//                     'assets/images/background.jpeg'), // Replace with your image path
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//
//           // Content (only shown after delay)
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20), // Adjust as needed
//             child: _isContentVisible // Check if content should be visible
//                 ? Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const Spacer(), // Pushes content downwards
//
//                       // "Track your car" text
//                       Text('Track your car',
//                           style: AppStyle.cardSubtitle
//                               .copyWith(color: Colors.white)),
//                       const SizedBox(height: 40),
//
//                       // "Sign up" Button
//                       Row(
//                         children: [
//                           Expanded(
//                               child: CustomPrimaryButton(
//                             label: "Login",
//                             onPressed: () =>
//                                 Navigator.pushNamed(context, "/signup"),
//                           )),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//
//                       // "Log in" Button
//                       Row(
//                         children: [
//                           Expanded(
//                               child: CustomSecondaryButton(
//                             label: 'Sign up',
//                             signup: 1,
//                             onPressed: () =>
//                                 Navigator.pushNamed(context, "/signup"),
//                           )),
//                         ],
//                       ),
//                       const SizedBox(height: 40),
//                     ],
//                   )
//                 : Center(
//                     child: Image.asset(
//                       "assets/images/tematics_name.jpeg",
//                       height: 100,
//                     ),
//                   ), // Show loading indicator while waiting
//           ),
//         ],
//       ),
//     );
//   }
// }
