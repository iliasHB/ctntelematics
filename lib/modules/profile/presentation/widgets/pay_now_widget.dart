import 'package:flutter/material.dart';

import '../../../../core/utils/app_export_util.dart';

class PayNowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pay Now',
          style: AppStyle.pageTitle,
        ),
        // backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.green),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Maintenance',
                      style: AppStyle.cardSubtitle
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'OBD Plug and Play',
                      style: AppStyle.cardfooter
                    ),
                  ],
                ),
                Text(
                  '2024-10-8',
                    style: AppStyle.cardfooter
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Quantity and Buyer Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantity:',
                      style: AppStyle.cardfooter
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '1',
                        style: AppStyle.cardfooter.copyWith(fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Supplier',
                        style: AppStyle.cardfooter
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Auto Mechanic\nCompany',
                        style: AppStyle.cardfooter.copyWith(fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Buyer Information
            Row(
              children: [
                Text(
                  'Buyer:',
                    style: AppStyle.cardfooter
                ),
                const SizedBox(width: 8),
                Text(
                  'XYZ',
                    style: AppStyle.cardfooter.copyWith(fontWeight: FontWeight.bold)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
