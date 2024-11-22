import 'package:ctntelematics/core/widgets/advert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VehicleAlert extends StatelessWidget {
  const VehicleAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [Text("Alert")],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Icon(Icons.filter_alt),
            )
          ],
        ),
        body: Column(
          children: [
            Advert(),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(Icons.warning, size: 40, color: Colors.green.shade300,),
                    SizedBox(width: 10,),
                    Flexible(
                        child: Text("Sometimes you may not get alert due to GPD coverage network errors, battery voltage issue and unsupported vehicle",
                          softWrap: true,  // This ensures the text wraps to the next line if needed.
                          //overflow: TextOverflow.ellipsis,  // You can change this to TextOverflow.clip if preferred.
                          //maxLines: 5,
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
