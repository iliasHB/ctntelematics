import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../config/theme/app_style.dart';


class TermOfUse extends StatelessWidget {
  const TermOfUse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Term of Use',
              style: AppStyle.pageTitle,
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text( style: AppStyle.cardfooter,  textAlign: TextAlign.justify,
                  'Welcome to our car tracking mobile app! By using our app,'
                      'you agree to the following terms of use. Please read these terms carefully '
                      'before using the service '),
              const SizedBox(height: 20,),
              const TermUseContainer(
                title: 'Acceptable of Terms',
                subtitle: 'By downloading, installing, or using the app, you agree to follow and be bound by these terms of use. '
                    'If you do not agree to these terms, please do not use the app'
              ),
              const SizedBox(height: 20,),
              const TermUseContainer(
                  title: 'Use of the App',
                  subtitle: 'The app is provided for tracking and managing your vehicle(s). '
                      'You agree to use the app responsibly and only for its intended purpose. '
                      'Misuse of the the app, including tempering with its features or using it for illegal'
                      'purpose is prohibited'
              ),
              const SizedBox(height: 20,),
              Container(
                padding: const EdgeInsets.all(10.0 ),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.green,
                        ),
                        const SizedBox(width: 10,),
                        Text('User Responsibilities', style: AppStyle.cardSubtitle,),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: CircleAvatar(
                                radius: 2,
                                backgroundColor: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 5,),
                            Flexible(
                              child: Text(
                                  style: AppStyle.cardfooter,
                                  textAlign: TextAlign.justify,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  maxLines: 3,
                                  'You are ensuring that you use of the app complies with all applicable laws'),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: CircleAvatar(
                                radius: 2,
                                backgroundColor: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 5,),
                            Flexible(
                              child: Text(
                                  style: AppStyle.cardfooter,
                                  textAlign: TextAlign.justify,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  maxLines: 3,
                                  'You are responsible for maintaining the confidentiality of '
                                      'your account credentials'),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: CircleAvatar(
                                radius: 2,
                                backgroundColor: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 5,),
                            Flexible(
                              child: Text(
                                  style: AppStyle.cardfooter,
                                  textAlign: TextAlign.justify,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  maxLines: 3,
                                  'You are responsible for all activity that occurs under your account'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20,),
              const TermUseContainer(
                  title: 'Data Collection',
                  subtitle: 'To provide tracking services, the app collects certain vehicle data '
                      'such as location, speed and fuel levels. By using the app, you '
                      'consent to the collection, use, and storage of these data in '
                      'accordance with our privacy policy'
              ),
              //
              // const SizedBox(height: 20,),
              // const TermUseContainer(
              //     title: 'Location Accuracy',
              //     subtitle: ''
              // ),
              // const SizedBox(height: 20,),
              // const TermUseContainer(
              //     title: 'Changes to the App',
              //     subtitle: ''
              // ),
              // const SizedBox(height: 20,),
              // const TermUseContainer(
              //     title: 'Termination',
              //     subtitle: ''
              // ),
              // const SizedBox(height: 20,),
              // const TermUseContainer(
              //     title: 'Limitation of Liability',
              //     subtitle: ''
              // ),
              //
              // const SizedBox(height: 20,),
              // const TermUseContainer(
              //     title: 'Third-party Service',
              //     subtitle: ''
              // ),
              //
              // const SizedBox(height: 20,),
              // const TermUseContainer(
              //     title: 'Changes of these terms',
              //     subtitle: ''
              // ),
              // const SizedBox(height: 20,),
              // const TermUseContainer(
              //     title: 'Contact Us',
              //     subtitle: ''
              // ),

            ],
          ),
        ),
      ),
    );
  }
}


class TermUseContainer extends StatelessWidget {
  final String title, subtitle;

  const TermUseContainer({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(10.0 ),
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 8,
                backgroundColor: Colors.green,
              ),
              const SizedBox(width: 10,),
              Text(title, style: AppStyle.cardSubtitle,),
            ],
          ),
          Text(style: AppStyle.cardfooter, textAlign: TextAlign.justify,
              subtitle),
        ],
      ),
    );
  }
}


