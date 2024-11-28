import 'package:ctntelematics/modules/authentication/presentation/bloc/auth_bloc.dart';
import 'package:ctntelematics/modules/eshop/presentation/bloc/eshop_bloc.dart';
import 'package:ctntelematics/modules/vehincle/presentation/bloc/vehicle_bloc.dart';
import 'package:ctntelematics/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'config/routes/app_routes.dart';
import 'core/usecase/databse_helper.dart';
import 'core/usecase/provider_usecase.dart';
import 'modules/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'modules/map/presentation/bloc/map_bloc.dart';
import 'modules/profile/presentation/bloc/profile_bloc.dart';
import 'modules/websocket/presentation/bloc/vehicle_location_bloc.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await DatabaseHelper().database; // Force database creation
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//   ]);
//
//   final dbHelper = DatabaseHelper();
//
//   // Print all tables in the database
//   await dbHelper.printTables();
//   // Initialize the database
//   // await _initializeDatabase();
//   // Database db = await _initDatabase();
//   initializeDependencies();
//   await checkDatabaseFile();
//   // Initialize the database and check the tables
//
//   // await printTables(db);
//
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => GeofenceProvider()),
//         ChangeNotifierProvider(create: (_) => ShopNowProvider()),
//         ChangeNotifierProvider(create: (_) => MaintenanceReminderProvider()),
//         ChangeNotifierProvider(create: (_) => VehicleTripProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force database creation and initialize tables
  final dbHelper = DatabaseHelper();
  await dbHelper.database; // Ensure database is initialized

  // Print all tables in the database for debugging
  await dbHelper.printTables();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize dependencies if any (e.g., Dependency Injection)
  initializeDependencies();

  // Run the app with state management
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GeofenceProvider()),
        ChangeNotifierProvider(create: (_) => ShopNowProvider()),
        ChangeNotifierProvider(create: (_) => MaintenanceReminderProvider()),
        ChangeNotifierProvider(create: (_) => VehicleTripProvider()),
      ],
      child: const MyApp(),
    ),
  );
}


Future<void> checkDatabaseFile() async {
  String databasePath = await getDatabasesPath();
  String path = join(databasePath, 'notifications.db');

  print('Database path: $path'); // This will print the path in the debug console
}

Future<void> printTables(Database db) async {
  // Query the sqlite_master table to get all table names
  List<Map<String, dynamic>> tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table';"
  );

  print('Tables in the database:');
  for (var table in tables) {
    print('- ${table['name']}');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LoginBloc>(create: (_) => sl<LoginBloc>()),
        Provider<GenerateOtpBloc>(create: (_) => sl<GenerateOtpBloc>()),
        Provider<ChangePwdBloc>(create: (_) => sl<ChangePwdBloc>()),
        Provider<EmailVerifyBloc>(create: (_) => sl<EmailVerifyBloc>()),
        Provider<DashVehiclesBloc>(create: (_) => sl<DashVehiclesBloc>()),
        Provider<VehiclesBloc>(create: (_) => sl<VehiclesBloc>()),
        Provider<ProfileGenerateOtpBloc>(create: (_) => sl<ProfileGenerateOtpBloc>()),
        Provider<ProfileChangePwdBloc>(create: (_) => sl<ProfileChangePwdBloc>()),
        Provider<ProfileEmailVerifyBloc>(create: (_) => sl<ProfileEmailVerifyBloc>()),
        Provider<LogoutBloc>(create: (_) => sl<LogoutBloc>()),
        Provider<LastLocationBloc>(create: (_) => sl<LastLocationBloc>()),
        Provider<RouteHistoryBloc>(create: (_) => sl<RouteHistoryBloc>()),
        Provider<VehicleLocationBloc>(create: (_) => sl<VehicleLocationBloc>()),
        Provider<VehicleRouteHistoryBloc>(create: (_) => sl<VehicleRouteHistoryBloc>()),
        Provider<GetScheduleBloc>(create: (_) => sl<GetScheduleBloc>()),
        Provider<CreateScheduleBloc>(create: (_) => sl<CreateScheduleBloc>()),
        Provider<ProfileVehiclesBloc>(create: (_) => sl<ProfileVehiclesBloc>()),
        Provider<SendLocationBloc>(create: (_) => sl<SendLocationBloc>()),
        Provider<EshopGetAllProductBloc>(create: (_) => sl<EshopGetAllProductBloc>()),
        Provider<EshopGetCategoryBloc>(create: (_) => sl<EshopGetCategoryBloc>()),
        Provider<EshopGetProductBloc>(create: (_) => sl<EshopGetProductBloc>()),
        Provider<VehicleTripBloc>(create: (_) => sl<VehicleTripBloc>()),
        Provider<InitiatePaymentBloc>(create: (_) => sl<InitiatePaymentBloc>()),
      ],
      child: MaterialApp(
        title: 'CTN Telematics',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: routes,
      ),
    );
  }
}
