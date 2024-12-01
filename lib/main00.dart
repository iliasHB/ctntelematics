// import 'package:ctntelematics/modules/map/presentation/bloc/map_bloc.dart';
// import 'package:ctntelematics/service_locator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'config/routes/app_routes.dart';
// import 'modules/authentication/presentation/bloc/auth_bloc.dart';
// import 'modules/dashboard/presentation/bloc/dashboard_bloc.dart';
// import 'modules/profile/presentation/bloc/profile_bloc.dart';
// import 'modules/vehincle/presentation/bloc/vehicle_bloc.dart';
// import 'modules/websocket/presentation/bloc/vehicle_location_bloc.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   initializeDependencies();
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//   ]);
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         Provider<LoginBloc>(create: (_) => sl<LoginBloc>()),
//         Provider<GenerateOtpBloc>(create: (_) => sl<GenerateOtpBloc>()),
//         Provider<ChangePwdBloc>(create: (_) => sl<ChangePwdBloc>()),
//         Provider<EmailVerifyBloc>(create: (_) => sl<EmailVerifyBloc>()),
//         Provider<DashVehiclesBloc>(create: (_) => sl<DashVehiclesBloc>()),
//         Provider<VehiclesBloc>(create: (_) => sl<VehiclesBloc>()),
//         Provider<ProfileGenerateOtpBloc>(create: (_) => sl<ProfileGenerateOtpBloc>()),
//         Provider<ProfileChangePwdBloc>(create: (_) => sl<ProfileChangePwdBloc>()),
//         Provider<ProfileEmailVerifyBloc>(create: (_) => sl<ProfileEmailVerifyBloc>()),
//         Provider<LogoutBloc>(create: (_) => sl<LogoutBloc>()),
//         Provider<LastLocationBloc>(create: (_) => sl<LastLocationBloc>()),
//         Provider<RouteHistoryBloc>(create: (_) => sl<RouteHistoryBloc>()),
//         Provider<VehicleLocationBloc>(create: (_) => sl<VehicleLocationBloc>()),
//       ],
//       child: MaterialApp(
//         title: 'CTN Telemetrics',
//         debugShowCheckedModeBanner: false,
//         initialRoute: '/',
//         routes: routes,
//       ),
//     );
//   }
// }
