import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VehicleLivePreview {
  String? brand, model, vin, token, latitude, longitude;
  static showTopModal(BuildContext context, String? brand, String? model,
      String? vin, String? token, String? latitude, String? longitude) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (context, anim1, anim2) {

        return VehicleLivePreviewWidget(brand, model, vin, token, latitude, longitude);

        //   Align(
        //   alignment: Alignment.topCenter,
        //   child: Material(
        //     child: Container(
        //         constraints: BoxConstraints(
        //             maxHeight: MediaQuery.of(context).size.height * 0.8), ///height: 380,
        //         width: double.infinity,
        //         margin: const EdgeInsets.only(top: 50),
        //         decoration: BoxDecoration(
        //           color: Colors.white,
        //           borderRadius: BorderRadius.circular(15),
        //         ),
        //         child: Padding(
        //           padding: const EdgeInsets.all(10.0),
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.start,
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               const Row(
        //                 children: [
        //                   IconButton(
        //                       onPressed: null,
        //                       icon:  Icon(CupertinoIcons.back, color: Colors.black,),),
        //
        //                   Text("Live Preview",
        //                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        //                   )
        //                 ],
        //               ),
        //               Container(
        //                 color: Colors.green.shade300,
        //                 height: 200,
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.symmetric(vertical: 10.0),
        //                 child: Row(
        //                   children: [
        //                     const Text(
        //                       "OBG Plug and play",
        //                       style:
        //                           TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        //                     ),
        //                     const Spacer(),
        //                     CircleAvatar(
        //                       backgroundColor: Colors.green.shade300,
        //                       radius: 15,
        //                       child: const Icon(CupertinoIcons.text_bubble_fill, color: Colors.white,size: 15,),
        //                     ),
        //                     const SizedBox(width: 10,),
        //                     CircleAvatar(
        //                       backgroundColor: Colors.green.shade300,
        //                       radius: 15,
        //                       child: const Icon(CupertinoIcons.phone_fill, color: Colors.white, size: 15,),
        //                     )
        //                   ],
        //                 ),
        //               ),
        //
        //               const Text("123 Madison Avenue, New York, NY 10016"),
        //               const Text("September 9, 2024 12:03:30"),
        //               const Text("50 mph E114'3'50p N 114'3'50p")
        //             ],
        //           ),
        //         )),
        //   ),
        // );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
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

class VehicleLivePreviewWidget extends StatelessWidget {
  final String? brand, model, vin, token, latitude, longitude;
  const VehicleLivePreviewWidget(this.brand, this.model, this.vin, this.token, this.latitude, this.longitude, {super.key});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.now();
    return Align(
      alignment: Alignment.topCenter,
      child: Material(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          width: double.infinity,
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text(
                      "Live Preview",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
        // const Spacer(),
        // IconButton(
        //   onPressed: widget.onClose,
        //   icon: const Icon(Icons.cancel_outlined, color: Colors.black),
        // ),
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: NetworkImage('https://via.placeholder.com/400'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Icon(
                      CupertinoIcons.play_circle,
                      color: Colors.white.withOpacity(0.7),
                      size: 50,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$brand $model",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "VIN: $vin",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          CupertinoIcons.text_bubble_fill,
                          color: Colors.green.shade600,
                        ),
                        onPressed: () {
        // Message functionality
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          CupertinoIcons.phone_fill,
                          color: Colors.green.shade600,
                        ),
                        onPressed: () {
        // Call functionality
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Last Location:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "$latitude, $longitude",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Last Updated:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Text(
                      "${dateTime.toLocal()}".split(' ')[0],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: Icon(Icons.map, color: Colors.green.shade900),
                  label: Text(
                    "View on Map",
                    style: TextStyle(color: Colors.green.shade900),
                  ),
                  onPressed: () {
        // Map functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade50,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
