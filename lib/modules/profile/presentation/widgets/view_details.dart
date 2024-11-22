import 'package:flutter/material.dart';

import '../../../../config/theme/app_style.dart';


class ViewDetails extends StatelessWidget {
  const ViewDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('View Details', style: AppStyle.pageTitle,)
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reminder Details:', style: AppStyle.cardSubtitle,),
                    Text('Routing Service', style: AppStyle.cardSubtitle.copyWith(color: Colors.green.shade800, fontSize: 14),),
                  ],
                ),
                Spacer(),
                CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.redAccent,
                ),
                SizedBox(width: 5,),
                Text('Overdue', style: AppStyle.cardfooter,)
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'XYX90P',
              style: AppStyle.cardSubtitle
                  .copyWith(color: Colors.green, fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Service Tasks:',
              style: AppStyle.cardSubtitle,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.green.shade50),
                  child: Text(
                    'Task; Oil change',
                    style: AppStyle.cardfooter.copyWith(color: Colors.green[900]),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.green.shade200),
                  child: Text(
                    'Task; Oil replacement',
                    style: AppStyle.cardfooter.copyWith(color: Colors.green[900]),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Reminder',
              style: AppStyle.cardSubtitle,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.green.shade50),
              child: Text(
                'July 1st, 2024',
                style: AppStyle.cardfooter.copyWith(color: Colors.green[900]),
              ),
            ),

            Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                      onPressed: (){},
                      child: Text('Mark as completed', style: AppStyle.cardSubtitle.copyWith(fontSize: 14),)),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),

          ],),
      ),
    );
  }
}
