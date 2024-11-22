import 'package:flutter/material.dart';

import '../../../../config/theme/app_style.dart';

class GeofenceSetting extends StatelessWidget {
  const GeofenceSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Geofencing Setting', style: AppStyle.pageTitle,)
          ],
        ),
      ),
      body: Column(
        children: [

        ],),
    );
  }
}
