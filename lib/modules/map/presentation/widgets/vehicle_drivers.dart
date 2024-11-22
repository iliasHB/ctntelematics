
import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VehicleDriverDialog {
  static showDriverDialog(BuildContext context, String? name, String? phone, email, country, licence_number, String? vin, String? address, String number_plate) {
    return showGeneralDialog(
      context: context,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierDismissible: false,
      // transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Material(
            // Added Material widget here
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              height: 400,
              width: double.infinity,
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Driver',
                          style: AppStyle.cardSubtitle,
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () =>Navigator.pop(context),
                            icon: const Icon(Icons.cancel_outlined)
                        )
                      ],
                    ),
                    const SizedBox(height: 0),
                    Text('Name', style: AppStyle.cardSubtitle,),
                    Text(name!, style: AppStyle.cardfooter,),
                    SizedBox(height: 10,),
                    Text('Phone', style: AppStyle.cardSubtitle,),
                    Text(phone!, style: AppStyle.cardfooter,),
                    SizedBox(height: 10,),
                    Text('Email', style: AppStyle.cardSubtitle,),
                    Text(email!, style: AppStyle.cardfooter,),
                    SizedBox(height: 10,),
                    Text('Number Plate', style: AppStyle.cardSubtitle,),
                    Text(number_plate, style: AppStyle.cardfooter,),
                    SizedBox(height: 10,),
                    Text('VIN', style: AppStyle.cardSubtitle,),
                    Text(vin!, style: AppStyle.cardfooter,),
                    SizedBox(height: 10,),
                    Text('Address', style: AppStyle.cardSubtitle,),
                    Text(address!, style: AppStyle.cardfooter,),



                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: anim1,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

}

