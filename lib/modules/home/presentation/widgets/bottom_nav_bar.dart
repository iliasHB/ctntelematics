import 'dart:developer';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:ctntelematics/modules/vehincle/presentation/pages/vehicle_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../dashcam/presentation/pages/dashcam_page.dart';
import '../../../eshop/presentation/pages/eshop_page.dart';
import '../../../map/presentation/pages/map_page.dart';


import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  // PageController to handle PageView navigation
  final PageController _pageController = PageController(initialPage: 2);

  int _currentIndex = 2; // Default page index (for example, Home page)

  final int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // List of pages for the BottomNavigationBar
    final List<Widget> bottomBarPages = [
      MapPage(),
      VehiclePage(),
      DashboardPage(),
      EshopPage(),
      DashCamPage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: bottomBarPages,
        ),
      ),
      extendBody: true,
      bottomNavigationBar: bottomBarPages.length <= maxCount
          ? BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(index);
        },
        type: BottomNavigationBarType.fixed,
        elevation: 5,
        backgroundColor: Colors.grey.shade200,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.placemark),
            activeIcon: Icon(CupertinoIcons.placemark_fill, color: Colors.green.shade900,),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping_outlined,),
            activeIcon: Icon(Icons.local_shipping, color: Colors.green.shade900,),
            label: 'Vehicle',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house),
            activeIcon: Icon(CupertinoIcons.house_alt_fill),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.shopping_cart),
            activeIcon: Icon(CupertinoIcons.cart_fill, color: Colors.green.shade900,),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.camera),
            activeIcon: Icon(CupertinoIcons.camera_fill, color: Colors.green.shade900,),
            label: 'Dashcam',
          ),
        ],
      )
          : null, // If bottomBarPages count exceeds maxCount, bottom nav won't show
    );
  }
}




// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({Key? key}) : super(key: key);
//
//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }
//
// class _BottomNavBarState extends State<BottomNavBar> {
//   /// Controller to handle PageView and also handles initial page
//   final _pageController = PageController(initialPage: 2);
//
//   /// Controller to handle bottom nav bar and also handles initial page
//   final NotchBottomBarController _controller = NotchBottomBarController(index: 2);
//
//   int maxCount = 5;
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     /// widget list
//     final List<Widget> bottomBarPages = [
//       MapPage(),
//     const VehiclePage(),
//       DashboardPage(),
//       const EshopPage(),
//     const DashCamPage()
//     ];
//     return Scaffold(
//       body: PageView(
//         controller: _pageController,
//         physics: const NeverScrollableScrollPhysics(),
//         children: List.generate(bottomBarPages.length, (index) => bottomBarPages[index]),
//       ),
//       extendBody: true,
//       bottomNavigationBar: (bottomBarPages.length <= maxCount)
//           ? AnimatedNotchBottomBar(
//         /// Provide NotchBottomBarController
//         notchBottomBarController: _controller,
//         color: Colors.grey.shade200,
//         showLabel: true,
//         textOverflow: TextOverflow.visible,
//         maxLine: 1,
//         shadowElevation: 5,
//         kBottomRadius: 28.0,
//         notchColor: Colors.green.shade100,
//
//         /// restart app if you change removeMargins
//         removeMargins: false,
//         bottomBarWidth: 500,
//         showShadow: false,
//         durationInMilliSeconds: 300,
//         itemLabelStyle: const TextStyle(fontSize: 10),
//
//         elevation: 1,
//         bottomBarItems: const [
//           BottomBarItem(
//             inActiveItem: Icon(
//               CupertinoIcons.placemark,
//               color: Colors.grey,
//             ),
//             activeItem: Icon(
//               CupertinoIcons.placemark_fill,
//               color: Colors.black
//             ),
//             itemLabel: 'Map',
//           ),
//           BottomBarItem(
//             inActiveItem: Icon(
//               Icons.local_shipping_outlined,
//               color: Colors.grey,
//             ),
//             activeItem: Icon(
//               Icons.local_shipping,
//               color: Colors.black,
//             ),
//             itemLabel: 'Vehicle',
//           ),
//           BottomBarItem(
//             inActiveItem: Icon(
//                 CupertinoIcons.house,
//                 color: Colors.grey),
//             activeItem: Icon(
//               CupertinoIcons.house_alt_fill,
//               color: Colors.black,
//             ),
//             itemLabel: 'Home',
//           ),
//           BottomBarItem(
//             inActiveItem: Icon(
//               CupertinoIcons.shopping_cart,
//               color: Colors.grey,
//             ),
//             activeItem: Icon(
//               CupertinoIcons.cart_fill,
//               color: Colors.black,
//             ),
//             itemLabel: 'Shop',
//           ),
//           BottomBarItem(
//             inActiveItem: Icon(
//               CupertinoIcons.camera,
//               color: Colors.grey,
//             ),
//             activeItem: Icon(
//               CupertinoIcons.camera_fill,
//               color: Colors.black,
//             ),
//             itemLabel: 'Dashcam',
//           ),
//
//         ],
//         onTap: (index) {
//           log('current selected index $index');
//           _pageController.jumpToPage(index);
//         },
//         kIconSize: 24.0,
//       )
//           : null,
//     );
//   }
// }

/// add controller to check weather index through change or not. in page 1
// class Page1 extends StatelessWidget {
//   final NotchBottomBarController? controller;
//
//   const Page1({Key? key, this.controller}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.yellow,
//       child: Center(
//         /// adding GestureDetector
//         child: GestureDetector(
//           behavior: HitTestBehavior.translucent,
//           onTap: () {
//             controller?.jumpTo(2);
//           },
//           child: const Text('Page 1'),
//         ),
//       ),
//     );
//   }
// }
//
// class Page2 extends StatelessWidget {
//   const Page2({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(color: Colors.green, child: const Center(child: Text('Page 2')));
//   }
// }
//
// class Page3 extends StatelessWidget {
//   const Page3({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(color: Colors.red, child: const Center(child: Text('Page 3')));
//   }
// }
//
// class Page4 extends StatelessWidget {
//   const Page4({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(color: Colors.blue, child: const Center(child: Text('Page 4')));
//   }
// }
//
// class Page5 extends StatelessWidget {
//   const Page5({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(color: Colors.lightGreenAccent, child: const Center(child: Text('Page 5')));
//   }
// }

///--------------------------------------------------------

// import 'package:flutter/material.dart';
//
// import '../../../dashboard/presentation/pages/dashboard_page.dart';
// import '../../../dashcam/presentation/pages/dashcam_page.dart';
// import '../../../eshop/presentation/pages/eshop_page.dart';
// import '../../../map/presentation/pages/map_page.dart';
//
//
// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({super.key});
//
//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }
//
// class _BottomNavBarState extends State<BottomNavBar> {
//
//   int _selectedIndex = 0;
//   static List<Widget> _widgetOptions = <Widget>[
//     DashboardPage(),
//     const MapPage(),
//     const EshopPage(),
//     const DashCamPage()
//   ];
//
//   void _onItemTapped(int index){
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _widgetOptions.elementAt(_selectedIndex),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//             label: 'Home'
//           ),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.map),
//               label: 'Map'
//           ),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_cart),
//               label: 'Shop'
//           ),
//           BottomNavigationBarItem(
//               icon: Icon(Icons. camera_alt_sharp),
//               label: 'Dashcam'
//           )
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.green,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
//
//




// import 'package:flutter/material.dart';
//
// import '../../../dashboard/presentation/pages/dashboard_page.dart';
// import '../../../dashcam/presentation/pages/dashcam_page.dart';
// import '../../../eshop/presentation/pages/eshop_page.dart';
// import '../../../map/presentation/pages/map_page.dart';
//
//
// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({super.key});
//
//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }
//
// class _BottomNavBarState extends State<BottomNavBar> {
//
//   int _selectedIndex = 0;
//   static List<Widget> _widgetOptions = <Widget>[
//     DashboardPage(),
//     const MapPage(),
//     const EshopPage(),
//     const DashCamPage()
//   ];
//
//   void _onItemTapped(int index){
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _widgetOptions.elementAt(_selectedIndex),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//             label: 'Home'
//           ),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.map),
//               label: 'Map'
//           ),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_cart),
//               label: 'Shop'
//           ),
//           BottomNavigationBarItem(
//               icon: Icon(Icons. camera_alt_sharp),
//               label: 'Dashcam'
//           )
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.green,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
//
//
