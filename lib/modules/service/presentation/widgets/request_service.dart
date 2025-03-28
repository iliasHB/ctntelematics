import 'package:ctntelematics/modules/service/presentation/bloc/service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_style.dart';
import '../../../../core/model/token_req_entity.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_input_decorator.dart';
import '../../../../service_locator.dart';
import '../pages/service_payment_method.dart';

class RequestService extends StatefulWidget {
  final String serviceId, name, fee, token;
  const RequestService(
      {super.key,
      required this.serviceId,
      required this.name,
      required this.fee,
      required this.token});

  @override
  State<RequestService> createState() => _RequestServiceState();
}

class _RequestServiceState extends State<RequestService> {
  TextEditingController _addressController = TextEditingController();

  TextEditingController _contactController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedLocation;
  String? _selectedLocalGovt;
  List<String> _localGovtList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Request Service",
            style: AppStyle.pageTitle,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Service',
                    style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                  ),
                  TextField(
                      // controller: ,
                      enabled: false,
                      decoration: customInputDecoration(
                        labelText: widget.name,
                        hintText: '',
                        prefixIcon: const Icon(Icons.home_repair_service,
                            color: Colors.green),
                      )),
                  // Username/Email Field
                  const SizedBox(height: 16),

                  Text(
                    'Phone number',
                    style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                  ),
                  TextFormField(
                    controller: _contactController,
                    keyboardType: TextInputType.phone,
                    decoration: customInputDecoration(
                      labelText: 'Phone number',
                      hintText: 'Enter your phone number',
                      prefixIcon: const Icon(Icons.call, color: Colors.green),
                    ),
                    validator: (value) {
                      if (_contactController.text.isEmpty ||
                          _contactController.text == "") {
                        return "Phone number that can not be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'State',
                    style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                  ),
                  BlocProvider(
                    create: (_) => sl<GetCountryStateBloc>()
                      ..add(GetCountryStateEvent(TokenReqEntity(
                        token: widget.token ?? "",
                        // contentType: 'application/json'
                      ))),
                    child: BlocConsumer<GetCountryStateBloc, ServiceState>(
                      builder: (context, state) {
                        if (state is ServiceLoading) {
                          return Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const CustomContainerLoadingButton());
                        } else if (state is GetCountryStateDone) {
                          // Check if vehicle data is null or empty
                          if (state.resp.locations == null ||
                              state.resp.locations!.isEmpty) {
                            return Center(
                              child: Text(
                                'No locations available',
                                style: AppStyle.cardfooter,
                              ),
                            );
                          }
                          return DropdownButtonFormField<String>(
                              value: _selectedLocation,
                              // ??= state.resp.locations.first.state ?? "Unknown VIN", // Default to the first VIN
                              items: state.resp.locations
                                  .map<DropdownMenuItem<String>>((v) {
                                return DropdownMenuItem<String>(
                                  value: v.state, // Pass the VIN to the API
                                  child: Text(
                                    "${v.state ?? "Unknown Brand"}", // Display the brand
                                    style: AppStyle.cardfooter
                                        .copyWith(fontSize: 12),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedLocation =
                                      value; // Update selected VIN
                                  _localGovtList = state.resp.locations
                                      .firstWhere(
                                          (element) => element.state == value)
                                      .localGovt;
                                  _selectedLocalGovt =
                                      null; // Reset local government when state changes
                                });
                              },
                              decoration: customInputDecoration(
                                labelText: 'Choose State',
                                hintText: 'Choose Local Government',
                                prefixIcon:
                                    const Icon(Icons.flag, color: Colors.green),
                              ));
                        } else {
                          return Center(
                              child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Unable to load locations',
                                        style: AppStyle.cardfooter
                                            .copyWith(fontSize: 12),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            BlocProvider.of<
                                                        GetCountryStateBloc>(
                                                    context)
                                                .add(GetCountryStateEvent(
                                                    TokenReqEntity(
                                                        token: widget.token ??
                                                            "")));
                                          },
                                          icon: const Icon(
                                            Icons.refresh,
                                            color: Colors.green,
                                          ))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ));
                        }
                      },
                      listener: (context, state) {
                        if (state is ServiceFailure) {
                          if (state.message.contains("Unauthenticated")) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, "/login", (route) => false);
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // **Local Government Dropdown**
                  Text(
                    'L.G.A',
                    style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                  ),
                  DropdownButtonFormField<String>(
                      value: _selectedLocalGovt,
                      items: _localGovtList.map<DropdownMenuItem<String>>((lg) {
                        return DropdownMenuItem<String>(
                          value: lg,
                          child: Text(
                            lg,
                            style: AppStyle.cardfooter.copyWith(fontSize: 12),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLocalGovt = value;
                        });
                      },
                      decoration: customInputDecoration(
                        labelText: 'L.G.A',
                        hintText: 'Choose Local Government',
                        prefixIcon:
                            const Icon(Icons.warehouse, color: Colors.green),
                      )),

                  const SizedBox(height: 16),
                  Text(
                    'Address',
                    style: AppStyle.cardSubtitle.copyWith(fontSize: 14),
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: customInputDecoration(
                      labelText: 'Address',
                      hintText: 'Enter your address',
                      prefixIcon:
                          const Icon(Icons.home_rounded, color: Colors.green),
                    ),
                    validator: (value) {
                      if (_addressController.text.isEmpty ||
                          _addressController.text == "") {
                        return "Address that can not be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Fee: ',
                        style: AppStyle.cardSubtitle,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/naira.png',
                            height: 20,
                            width: 20,
                          ),
                          Text(
                            widget.fee,
                            style: AppStyle.cardSubtitle
                                .copyWith(color: Colors.green),
                          ),
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 12),
                  CustomPrimaryButton(
                      label: 'Make payment',
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (_selectedLocalGovt == null ||
                              _selectedLocation == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'State and L.G.A must be selected')));
                            return;
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ServicePaymentGateway(
                                      fee: widget.fee,
                                      token: widget.token,
                                      serviceId: widget.serviceId,
                                      phone: _contactController.text.trim(),
                                      address: _addressController.text.trim(),
                                      lga: _selectedLocalGovt!,
                                      state: _selectedLocation!)));
                        }
                      })
                ],
              ),
            ),
          ),
        ));
  }
}
