import 'dart:io';

import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/core/widgets/advert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';


class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {

  bool viewAdvert = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Live Support', style: AppStyle.pageTitle,)
          ],
        ),
      ),
      body: Column(
        children: [
          viewAdvert == false
              ? Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 5.0),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Check Latest Stock',
                                style: AppStyle.cardfooter
                                    .copyWith(fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          viewAdvert = true;
                        });
                      },
                      icon: const Icon(
                        CupertinoIcons.chevron_down,
                        size: 15,
                      ))
                ],
              ),
            ),
          )
              : Stack(children: [
            const Advert(),
            Positioned(
              right: 10,
              top: 0,
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      viewAdvert = false;
                    });
                  },
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                  )),
            )
          ]),
         const SizedBox(height: 20,),
         InkWell(
           onTap: () => handleSendEmail(),
           child: const SupportCard(
             icon: Icon(Icons.email),
             title: "Email",
             subTitle: 'Email us'
           ),
         ),
          InkWell(
            onTap: () async {
              // await FlutterPhoneDirectCaller.callNumber(hotline);
            },
            child: const SupportCard(
                icon: Icon(Icons.call),
                title: "Hotline",
                subTitle: 'Contact us'
            ),
          ),
          InkWell(
            onTap: () => handleWhatsAppCall(),
            child: const SupportCard(
                icon: Icon(Icons.chat),
                title: "Live Chat",
                subTitle: 'Message us'
            ),
          ),
        ],
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

class SupportCard extends StatelessWidget {
  final Icon icon;
  final String title;
  final String subTitle;
  const SupportCard({super.key,
    required this.icon,
    required this.title,
    required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.green.shade300,
              child: icon,
            ),
            const SizedBox(width: 10.0,),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyle.cardSubtitle.copyWith(fontSize: 14),),
                Text(subTitle, style: AppStyle.cardfooter,)
              ],
            )
          ],
        ),
      ),
    );
  }
}

