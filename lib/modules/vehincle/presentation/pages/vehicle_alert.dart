import 'package:ctntelematics/core/widgets/advert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VehicleAlertPage extends StatelessWidget {
  const VehicleAlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [Text("Alert")],
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(Icons.filter_alt),
          )
        ],
      ),
      body: Column(
        children: [
          const Advert(),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Icon(Icons.warning, size: 40, color: Colors.green.shade300,),
                  const SizedBox(width: 10,),
                  const Flexible(
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
    );
  }
}
