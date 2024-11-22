import 'package:flutter/material.dart';

import '../../../../config/theme/app_style.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Privacy policy',
              style: AppStyle.pageTitle,
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text( style: AppStyle.cardfooter,  textAlign: TextAlign.justify,
                'Our Car tracking policy mobile app respects your privacy '
                    'and is committed to protecting your personal information. '
                    'We collect vehicle data, such as location, speed and fuel level, '
                    'to provide tracking services. This data is used solely for '
                    'improving your experience and helping you manage your vehicle(s). '
                    'We do not sell or share your personal data to third parties unlerss '
                    'required by law.'),
            SizedBox(height: 20,),
            Text(style: AppStyle.cardfooter, textAlign: TextAlign.justify,
                'Your information is stored securely, and and we take steps to safeguard it '
                    'from unauthorized access. By using the app, you consent to our data collection practices. '
                    'If you have any questions or concern, please contact us')
          ],
        ),
      ),
    );
  }
}
