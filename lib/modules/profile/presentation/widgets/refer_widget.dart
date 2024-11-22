import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../config/theme/app_style.dart';
import '../../../../core/utils/app_export_util.dart';

class Refer extends StatelessWidget {
  const Refer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Refer a friend',
              style: AppStyle.pageTitle,
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/refer.jpeg",
                // height: 200,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Together we're going further",
                  textAlign: TextAlign.center,
                  style: AppStyle.cardTitle
                      .copyWith(color: Colors.green, fontSize: 30),
                ),
              ),
              Text(
                'Refer and introduce us to your friends, and family!',
                textAlign: TextAlign.center,
                style: AppStyle.pageTitle.copyWith(),
              ),

              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text('https://cartracker/v2/track-a-day/0f87hmkjhnbf?',
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 3,
                          style: AppStyle.cardfooter,
                        ),
                      ),
                      const SizedBox(width: 30,),
                      const Icon(Icons.copy, color: Colors.green,),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text('Share your link', style: AppStyle.cardTitle,),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      child: Image.asset('assets/images/linkedIn.png', height: 30, width: 30,)),
                  const SizedBox(width: 10,),
                  InkWell(
                      onTap: () => handleWhatsAppCall(),
                      child: Image.asset('assets/images/whatsapp.jpeg', height: 30, width: 30,)),
                  const SizedBox(width: 10,),
                  InkWell(
                      child: Image.asset('assets/images/facebook.jpeg', height: 30, width: 30,)),
                  const SizedBox(width: 10,),
                  InkWell(child: Image.asset('assets/images/xapp.jpeg', height: 30, width: 30,)),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  void handleWhatsAppCall() async {
    Uri whatsAppURL = Uri.parse("whatsapp://send?phone=$whatsAppNum");
    if (Platform.isIOS) {
      // for iOS phone only
      await launchUrl(whatsAppURL);
    } else {
      // android , web
      await launchUrl(whatsAppURL);
    }
  }

  void handleSendEmail() async {
    final emailTo = emailAddress;
    final subject = '';
    final message = '';
    Uri url = Uri.parse(
        'mailto:$emailTo?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(message)}');
    await launchUrl(url);
  }
}
