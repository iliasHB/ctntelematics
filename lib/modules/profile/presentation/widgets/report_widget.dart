import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../config/theme/app_style.dart';
import '../../../../core/utils/math_util.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    const List<String> businessType = <String>[
      'Select Business type',
      'Energy',
    ];
    const List<String> company = <String>[
      'Select type of Company Registration',
      'Company',
      'Business',
    ];
    String dropdownValue1 = businessType.first;
    String dropdownValue2 = company.first;
    final _businessNameController = TextEditingController();
    final _businessTypeController = TextEditingController();
    final _businessEmailController = TextEditingController();
    final _businessContactController = TextEditingController();
    final _businessRegistrationController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Reports", style: AppStyle.pageTitle,),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [

            Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Report Type",
                        style: AppStyle.cardTitle,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: DropdownMenu<String>(
                              width: MediaQuery.of(context).size.width - 20,
                              textStyle: AppStyle.cardSubtitle
                                  .copyWith(fontWeight: FontWeight.w500),
                              initialSelection: businessType.first,
                              onSelected: (String? value) {
                                setState(() {
                                  dropdownValue1 = value!;
                                });
                              },
                              dropdownMenuEntries: businessType
                                  .map<DropdownMenuEntry<String>>(
                                      (String value) {
                                    return DropdownMenuEntry<String>(
                                        value: value,
                                        label: value);
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getHorizontalSize(10),
                      ),
                      Text(
                        "Devices",
                        style: AppStyle.cardTitle,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownMenu<String>(
                              width: MediaQuery.of(context).size.width - 20,
                              textStyle: AppStyle.cardSubtitle
                                  .copyWith(fontWeight: FontWeight.w500),
                              initialSelection: businessType.first,
                              onSelected: (String? value) {
                                setState(() {
                                  dropdownValue1 = value!;
                                });
                              },
                              dropdownMenuEntries: businessType
                                  .map<DropdownMenuEntry<String>>(
                                      (String value) {
                                    return DropdownMenuEntry<String>(
                                        value: value,
                                        label: value);
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getVerticalSize(10),
                      ),
                      Text(
                        "Stops",
                        style: AppStyle.cardTitle,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownMenu<String>(
                              width: MediaQuery.of(context).size.width - 20,
                              textStyle: AppStyle.cardSubtitle
                                  .copyWith(fontWeight: FontWeight.w500),
                              initialSelection: businessType.first,
                              onSelected: (String? value) {
                                setState(() {
                                  dropdownValue1 = value!;
                                });
                              },
                              dropdownMenuEntries: businessType
                                  .map<DropdownMenuEntry<String>>(
                                      (String value) {
                                    return DropdownMenuEntry<String>(
                                        leadingIcon: const Icon(CupertinoIcons.add),
                                        value: value,
                                        label: value);
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getVerticalSize(10),
                      ),
                      Text(
                        "Filter",
                        style: AppStyle.cardTitle),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownMenu<String>(
                              width: MediaQuery.of(context).size.width - 20,
                              textStyle: AppStyle.cardSubtitle
                                  .copyWith(fontWeight: FontWeight.w500),
                              initialSelection: businessType.first,
                              onSelected: (String? value) {
                                setState(() {
                                  dropdownValue1 = value!;
                                });
                              },
                              dropdownMenuEntries: businessType
                                  .map<DropdownMenuEntry<String>>(
                                      (String value) {
                                    return DropdownMenuEntry<String>(
                                        leadingIcon: const Icon(CupertinoIcons.add),
                                        value: value,
                                        label: value);
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getVerticalSize(10),
                      ),
                      Text(
                        "From",
                        style: AppStyle.cardTitle,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownMenu<String>(
                              width: MediaQuery.of(context).size.width - 20,
                              textStyle: AppStyle.cardSubtitle
                                  .copyWith(fontWeight: FontWeight.w500),
                              initialSelection: businessType.first,
                              onSelected: (String? value) {
                                setState(() {
                                  dropdownValue1 = value!;
                                });
                              },
                              dropdownMenuEntries: businessType
                                  .map<DropdownMenuEntry<String>>(
                                      (String value) {
                                    return DropdownMenuEntry<String>(
                                        leadingIcon: const Icon(CupertinoIcons.add),
                                        value: value,
                                        label: value);
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getVerticalSize(10),
                      ),
                      Text(
                        "To",
                        style: AppStyle.cardTitle,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownMenu<String>(
                              width: MediaQuery.of(context).size.width - 20,
                              textStyle: AppStyle.cardSubtitle
                                  .copyWith(fontWeight: FontWeight.w500),
                              initialSelection: businessType.first,
                              onSelected: (String? value) {
                                setState(() {
                                  dropdownValue1 = value!;
                                });
                              },
                              dropdownMenuEntries: businessType
                                  .map<DropdownMenuEntry<String>>(
                                      (String value) {
                                    return DropdownMenuEntry<String>(
                                        value: value,
                                        label: value);
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getVerticalSize(10),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
