import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../config/theme/app_style.dart';

class DriverInfo extends StatefulWidget {
  final String name, phone, vin, email, number_plate;
  final VoidCallback onClose;
  const DriverInfo(
      {super.key,
      required this.vin,
      required this.name,
      required this.phone,
      required this.email,
      required this.number_plate,
      required this.onClose});

  @override
  State<DriverInfo> createState() => _DriverInfoState();
}

class _DriverInfoState extends State<DriverInfo> {
  @override
  Widget build(BuildContext context) {
    // Show dialog only if it hasn't been shown yet
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.55,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ), // Dynamic height
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            mainAxisSize:
            MainAxisSize.min, // Adjust height dynamically based on content
            crossAxisAlignment: CrossAxisAlignment
                .start, //Adjust height dynamically based on content
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment
                    .start, //Adjust height dynamically based on content
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Driver',
                        style: AppStyle.cardSubtitle,
                      ),
                      // const Spacer(),
                      IconButton(
                          onPressed: () => widget.onClose(),
                          icon: const Icon(Icons.cancel_outlined))
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 0),
              Text('Name', style: AppStyle.cardSubtitle,),
              Text(widget.name, style: AppStyle.cardfooter,),
              SizedBox(height: 10,),
              Text('Phone', style: AppStyle.cardSubtitle,),
              Text(widget.phone, style: AppStyle.cardfooter,),
              SizedBox(height: 10,),
              Text('Email', style: AppStyle.cardSubtitle,),
              Text(widget.email, style: AppStyle.cardfooter,),
              SizedBox(height: 10,),
              Text('Number Plate', style: AppStyle.cardSubtitle,),
              Text(widget.number_plate, style: AppStyle.cardfooter,),
              SizedBox(height: 10,),
              Text('VIN', style: AppStyle.cardSubtitle,),
              Text(widget.vin, style: AppStyle.cardfooter,),
              SizedBox(height: 10,),
              // Text('Address', style: AppStyle.cardSubtitle,),
              // Text(widget.address!, style: AppStyle.cardfooter,),
            ],
          ),
        ),
      ),
    );
  }
}
