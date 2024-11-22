import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:ctntelematics/modules/map/domain/entitties/req_entities/send_location_resp_entity.dart';
import 'package:ctntelematics/modules/map/presentation/bloc/map_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleShare {
  static showVehicleShareDialog(
      BuildContext context,
      String? brand,
      String? model,
      String? vin,
      String? token,
      String? latitude,
      String? longitude) {
    DateTime dateTime = DateTime.now();

    return showGeneralDialog(
      context: context,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierDismissible: true,
      // transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Material(
            // Added Material widget here
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height *
                      0.6), // Dynamic height
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize
                      .min, // Adjust height dynamically based on content
                  children: [
                    Row(
                      children: [
                        Text(
                          'Share Location',
                          style: AppStyle.cardSubtitle,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.cancel_outlined))
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$brand $model ($vin)',
                      style: AppStyle.cardSubtitle.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Share location expiry date',
                      style:
                          AppStyle.cardfooter.copyWith(color: Colors.grey[800]),
                    ),
                    Text(
                      dateTime.toString(),
                      style: AppStyle.cardSubtitle
                          .copyWith(fontSize: 12, color: Colors.grey[700]),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              "https//ctn-frontend.vercel.app/viewCar/?token=$token&lat=$latitude&lon=$longitude",
                              style: AppStyle.cardfooter,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                // Copy text to clipboard
                                Clipboard.setData(ClipboardData(
                                  text:
                                      "https://ctn-frontend.vercel.app/viewCar/?token=$token&lat=$longitude&lon=$longitude",
                                ));

                                // Show confirmation SnackBar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Link copied to clipboard'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.file_copy_rounded,
                                color: Colors.green,
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Enter Email Address ',
                          style: AppStyle.cardSubtitle.copyWith(fontSize: 12),
                        ),
                        Badge(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          backgroundColor: Colors.green[800],
                          label: Text(
                            'OPTIONAL',
                            style: AppStyle.cardfooter.copyWith(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    EmailWidget(
                      token: token,
                      latitude: latitude,
                      longitude: longitude,
                      url:
                          "https//ctn-frontend.vercel.app/viewCar/?token=$token&lat=$latitude&lon=$longitude",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
            begin: const Offset(-1, 0),
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

class EmailWidget extends StatefulWidget {
  final String? token, latitude, longitude, url;
  const EmailWidget(
      {super.key,
      this.token,
      this.latitude,
      this.longitude,
      required this.url});
  @override
  _EmailWidgetState createState() => _EmailWidgetState();
}

class _EmailWidgetState extends State<EmailWidget> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _displayedTexts = [];

  void _removeEmail(String email) {
    setState(() {
      _displayedTexts.remove(email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Form(
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'you@gmail.com',
                    hintStyle: AppStyle.cardfooter,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.grey.shade100,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    _displayedTexts.add(_controller.text); // Add new email
                    _controller.clear(); // Clear the text field
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              icon: const Icon(Icons.add),
              label: Text(
                "Add",
                style: AppStyle.cardSubtitle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Display the first email entered and a counter for total emails
        if (_displayedTexts.isNotEmpty)
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.green.shade50,
                  ),
                  child: Text(
                    _displayedTexts.first, // Display only the first email
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isDismissible: true,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return ViewEmailWidget(
                        emails:
                            _displayedTexts, // Pass all emails to the widget
                        onDelete: _removeEmail, // Pass the delete function
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green.shade100,
                  ),
                  child: Text(
                    "+${_displayedTexts.length - 1}",
                    style: AppStyle.cardfooter,
                  ),
                ),
              ),
            ],
          ),
        BlocConsumer<SendLocationBloc, MapState>(
          listener: (context, state) {
            if (state is SendLocationDone) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.resp.message.toString())));
            } else if (state is MapFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is MapLoading) {
              return const Center(
                child: SizedBox(
                  height: 30, // Adjust the height
                  width: 30, // Adjust the width
                  child: CircularProgressIndicator(
                    strokeWidth: 3, // Adjust the thickness
                    color: Colors
                        .green, // Optional: Change the color to match your theme
                  ),
                ),
              );
            }

            return Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    for (var email in _displayedTexts) {
                      final sendLocationReqEntity = SendLocationReqEntity(
                        email: email,
                        url: widget.url!,
                        token: widget.token!,
                      );
                      context
                          .read<SendLocationBloc>()
                          .add(SendLocationEvent(sendLocationReqEntity));
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Sending link to ${_displayedTexts.length} email(s)')),
                    );

                    // if (_formKey.currentState?.validate() ?? false) {
                    // final sendLocationReqEntity = SendLocationReqEntity(
                    //   email: _displayedTexts.first,
                    //   url: "https//ctn-frontend.vercel.app/viewCar/?token=${widget.token}&lat=${widget.latitude}&lon=${widget.longitude}",
                    //   token: widget.token!,
                    // );
                    // context.read<SendLocationBloc>().add(SendLocationEvent(sendLocationReqEntity));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green, // Set the background color to green
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8), // Reduce the radius as needed
                    ),
                  ),
                  child: Text(
                    'Send Link',
                    style: AppStyle.cardSubtitle.copyWith(color: Colors.white),
                  ),
                ));
          },
        ),
      ],
    );
  }
}

class ViewEmailWidget extends StatefulWidget {
  final List<String> emails;
  final void Function(String) onDelete;

  const ViewEmailWidget({
    Key? key,
    required this.emails,
    required this.onDelete,
  }) : super(key: key);

  @override
  _ViewEmailWidgetState createState() => _ViewEmailWidgetState();
}

class _ViewEmailWidgetState extends State<ViewEmailWidget> {
  late List<String> displayedEmails;

  @override
  void initState() {
    super.initState();
    displayedEmails =
        List.from(widget.emails); // Create a local copy of the emails list
  }

  void _removeEmail(String email) {
    setState(() {
      displayedEmails.remove(email);
    });
    widget.onDelete(email); // Call the callback to update the parent list
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: 5,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Email - List of all emails",
                style: AppStyle.cardTitle,
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.cancel_outlined),
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: displayedEmails
                .map((email) => Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              email,
                              style: const TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _removeEmail(
                                    email); // Remove email from local list and parent
                              },
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
