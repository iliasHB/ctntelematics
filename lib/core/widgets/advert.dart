
import 'dart:async';

import 'package:flutter/material.dart';



class Advert extends StatefulWidget {
  const Advert({Key? key}) : super(key: key);

  @override
  _AdvertState createState() => _AdvertState();
}

class _AdvertState extends State<Advert> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Automatically slide every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.toInt() + 1;
        _pageController.animateToPage(
          nextPage % 3, // Assume 3 slides; change based on your number of slides
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150, // Adjust the height as needed
          child: PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              _buildAdvertSlide(
                color: Colors.blue,
                title: "Discover Amazing Deals",
                description: "Shop the latest products at unbeatable prices!",
                icon: Icons.shopping_cart,
              ),
              _buildAdvertSlide(
                color: Colors.green,
                title: "Track Your Vehicles",
                description: "Keep an eye on your vehicle's status in real-time.",
                icon: Icons.directions_car,
              ),
              _buildAdvertSlide(
                color: Colors.orange,
                title: "Get Exclusive Offers",
                description: "Sign up for early access to our exclusive offers.",
                icon: Icons.local_offer,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3, // Number of slides
                (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: _currentPage == index ? 16 : 8,
              decoration: BoxDecoration(
                color: _currentPage == index ? Colors.black : Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdvertSlide({
    required Color color,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

// class Advert extends StatelessWidget {
//   const Advert({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.grey.shade100,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             // Image.asset('assets/toolkit.png', height: 60), // Replace with your toolkit image
//             const SizedBox(width: 0),
//             Container(
//               height: 150,
//               width: 150,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Multi-Tool Kit',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'Everything you need for on-the-go repairs and equipment.',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                     softWrap: true,
//                   ),
//                   ElevatedButton(
//                     onPressed: () {},
//                     child: const Text(
//                       'Explore Now',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green.shade200,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Spacer(),
//             Container(
//               height: 150,
//               width: 150,
//               color: Colors.green.shade100,
//               child: Image.asset("assets/images/advert.png"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
