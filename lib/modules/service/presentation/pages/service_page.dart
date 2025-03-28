import 'package:ctntelematics/config/theme/app_style.dart';
import 'package:ctntelematics/core/widgets/custom_button.dart';
import 'package:ctntelematics/modules/service/presentation/bloc/service_bloc.dart';
import 'package:ctntelematics/modules/service/presentation/widgets/request_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/model/token_req_entity.dart';
import '../../../../core/utils/pref_util.dart';
import '../../../../core/widgets/appBar.dart';
import '../../../../service_locator.dart';

class ServicePage extends StatefulWidget {
  ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {

  PrefUtils prefUtils = PrefUtils();
  String? token;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  _initializeData() async {
    List<String>? authUser = await prefUtils.getStringList('auth_user');
    setState(() {
      if (authUser != null && authUser.isNotEmpty) {
        token = authUser[4].isEmpty ? null : authUser[4];
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokenReq = TokenReqEntity(
      token: token ?? '',
      // contentType: 'application/json',
    );
    return Scaffold(
      appBar: AnimatedAppBar(
        firstname: "",
        pageRoute: "Service",
      ),
      body: isLoading
          ? const Center(child: CustomContainerLoadingButton())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TextField(
                    //   decoration: InputDecoration(
                    //     hintText: 'Search',
                    //     prefixIcon: const Icon(Icons.search),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 20),
                    const Text('Services',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    BlocProvider(
                        create: (_) => sl<GetServicesBloc>()
                          ..add(GetServicesEvent(tokenReq)),
                        child: BlocConsumer<GetServicesBloc, ServiceState>(
                            builder: (context, state) {
                          if (state is ServiceLoading) {
                            return const CustomContainerLoadingButton();
                          } else if (state is GetServicesDone) {
                            if (state.resp == [] || state.resp.isEmpty) {
                              return Center(
                                  child: Text("No Service found",
                                      style: AppStyle.cardfooter));
                            }
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: state.resp.length,
                              itemBuilder: (context, index) {
                                var car = state.resp[index];
                                return InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => RequestService(
                                              serviceId: state.resp[index].id
                                                  .toString(),
                                              name: state.resp[index].name,
                                              fee: state.resp[index].charge.fee,
                                              token: token!))),
                                  child: ServiceTile(
                                    icon: getServiceIcon(car.name.toString()),
                                    title: state.resp[index].name,
                                  ),

                                );
                              },
                            );
                          }
                          return Center(
                              child: Text("No record found",
                                  style: AppStyle.cardfooter));
                        }, listener: (context, state) {
                          if (state is ServiceFailure) {
                            if (state.message.contains("Unauthenticated")) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/login", (route) => false);
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          }
                        })),

                    const SizedBox(height: 20),
                    // Text('Nearby Services', style: AppStyle.cardSubtitle),
                    // NearbyServiceCard(),
                  ],
                ),
              ),
            ),
    );
  }

  Map<String, String> serviceIcons = {
    "mechanic": "🚘",
    "wash": "🧼",
    "rent": "🚗",
    "diagnostic": "🛠",
    "inspection": "🔍",
    "towing": "🚛",
    "key": "🔑",
    "driving": "🚦",
    "panel": "🔧",
    "AC": "❄️",
    "tire": "🛞",
  };

  String getServiceIcon(String serviceName) {
    for (var entry in serviceIcons.entries) {
      if (serviceName.toLowerCase().contains(entry.key)) {
        return entry.value;
      }
    }
    return "🚘"; // Default icon
  }

}

class ServiceTile extends StatelessWidget {
  final String icon;
  final String title;

  const ServiceTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 5),
          Text(title,
              style: AppStyle.cardfooter.copyWith(fontSize: 12),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// class NearbyServiceCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Row(
//           children: [
//             // ClipRRect(
//             //   borderRadius: BorderRadius.circular(10),
//             //   child: Image.network(
//             //     'https://via.placeholder.com/100',
//             //     width: 100,
//             //     height: 100,
//             //     fit: BoxFit.cover,
//             //   ),
//             // ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Daniel Johnson', style: TextStyle(fontWeight: FontWeight.bold)),
//                   const Text('AC Technician / Wiring'),
//                   const Row(
//                     children: [
//                       Icon(Icons.location_on, size: 16, color: Colors.grey),
//                       SizedBox(width: 5),
//                       Text('Oregun, Ikeja, Lagos'),
//                     ],
//                   ),
//                   const Text('12km away - 18mins', style: TextStyle(color: Colors.grey)),
//                   Row(
//                     children: [
//                       const Icon(Icons.star, color: Colors.amber, size: 16),
//                       const SizedBox(width: 5),
//                       const Text('4.8'),
//                       const Spacer(),
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 18,
//                             backgroundColor: Colors.green[100],
//                             child: const Icon(Icons.email, size: 20,),
//                           ),
//                           SizedBox(width: 5,),
//                           CircleAvatar(
//                             radius: 18,
//                             backgroundColor: Colors.green[100],
//                             child: const Icon(Icons.call, size: 20,),
//                           ),
//                           SizedBox(width: 5,),
//                           CircleAvatar(
//                             radius: 18,
//                             backgroundColor: Colors.green[100],
//                             child: const Icon(Icons.chat_outlined, size: 20,),
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
