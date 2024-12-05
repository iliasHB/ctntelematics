import 'package:ctntelematics/config/theme/app_style.dart';
import 'package:flutter/material.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Vehicle Services & Servicing', style: AppStyle.cardfooter),
                Text('Coming soon!', style: AppStyle.cardfooter.copyWith(fontSize: 18)),
              ],
            )),
      ),
    );
  }
}
