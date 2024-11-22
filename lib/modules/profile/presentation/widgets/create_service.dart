import 'package:ctntelematics/core/utils/app_export_util.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class CreateService extends StatefulWidget {
  @override
  _CreateServiceState createState() => _CreateServiceState();
}

class _CreateServiceState extends State<CreateService> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _serviceTitleController = TextEditingController();
  final TextEditingController _odometerReadingController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedVehicle;
  String? _selectedVendor;
  String? _selectedDay;
  PlatformFile? _selectedFile;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Service Record",
          style: AppStyle.pageTitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Title',
                style: AppStyle.cardSubtitle.copyWith(fontSize: 14),),
              TextField(
                controller: _serviceTitleController,
                decoration: InputDecoration(
                  // labelText: 'Service Title',
                  hintText: 'Enter vehicle here',
                  hintStyle: AppStyle.cardfooter,
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16.0),
              Text('Choose Vehicle',
                style: AppStyle.cardSubtitle.copyWith(fontSize: 14),),
              DropdownButtonFormField<String>(
                value: _selectedVehicle,
                items: ['Vehicle 1', 'Vehicle 2', 'Vehicle 3']
                    .map((String vehicle) {
                  return DropdownMenuItem<String>(
                    value: vehicle,
                    child: Text(vehicle),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedVehicle = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Choose Vehicle',
                  hintStyle: AppStyle.cardfooter,
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16.0),
              Text('Service Details',
                style: AppStyle.cardSubtitle.copyWith(fontSize: 14),),
              DropdownButtonFormField<String>(
                value: _selectedVendor,
                items:
                    ['Vendor 1', 'Vendor 2', 'Vendor 3'].map((String vendor) {
                  return DropdownMenuItem<String>(
                    value: vendor,
                    child: Text(vendor),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedVendor = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Service Details',
                  hintStyle: AppStyle.cardfooter,
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Select Date',
                          style: AppStyle.cardSubtitle.copyWith(fontSize: 14),),
                        TextFormField(
                          readOnly: true,
                          onTap: () => _pickDate(context),
                          decoration: InputDecoration(
                            hintStyle: AppStyle.cardfooter,
                            hintText: _selectedDate == null
                                ? 'Select Date'
                                : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Odometer (km)',
                          style: AppStyle.cardSubtitle.copyWith(fontSize: 14),),
                        TextFormField(
                          controller: _odometerReadingController,
                          decoration: InputDecoration(
                            hintText: 'Odometer Reading (km)',
                            hintStyle: AppStyle.cardfooter,
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text('Select Days',
                style: AppStyle.cardSubtitle.copyWith(fontSize: 14),),

              DropdownButtonFormField<String>(
                value: _selectedDay,
                items: ['1', '2', '3'].map((String day) {
                  return DropdownMenuItem<String>(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDay = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Days',
                  hintStyle: AppStyle.cardfooter,
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: _selectedFile == null
                            ? const Icon(Icons.insert_drive_file,
                                size: 40, color: Colors.green)
                            : Text(_selectedFile!.name),
                      ),
                      Center(
                        child: Text(
                          'Select file to upload',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text('Description',
                style: AppStyle.cardSubtitle.copyWith(fontSize: 14),),

              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: AppStyle.cardfooter,
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle form submission
                  }
                },
                child: const Text('Save Record'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
