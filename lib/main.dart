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

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// Future<void> initNotifications() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//   AndroidInitializationSettings('@mipmap/ic_launcher');
//
//   final InitializationSettings initializationSettings =
//   InitializationSettings(android: initializationSettingsAndroid);
//
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
// }
///
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> initializeNotification() async {
const AndroidInitializationSettings initializationSettingsAndroid =
AndroidInitializationSettings('@mipmap/ic_launcher');

const DarwinInitializationSettings initializationSettingsIOS =
DarwinInitializationSettings(
  requestAlertPermission: true,
  requestBadgePermission: true,
  requestSoundPermission: true,
);

const InitializationSettings initializationSettings =
InitializationSettings(
  android: initializationSettingsAndroid,
  iOS: initializationSettingsIOS,
);

await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await initializeNotification();
  await checkAndRescheduleReminders(); // Reschedule on restart
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
        ChangeNotifierProvider(create: (_) => QuickLinkProvider()),
        ChangeNotifierProvider(create: (_) => OdometerProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> checkAndRescheduleReminders() async {
  final dbCart = DB_schedule();
  List<VehicleSchedule> schedules = await dbCart.fetchSchedule();

  for (var schedule in schedules) {
    if (schedule.byTimeReminder == null || schedule.byHourReminder == null) {
      print("Skipping schedule ${schedule.id} due to missing reminder fields.");
      continue; // Skip invalid entries
    }

    try {
      DateTime firstReminder = DateTime.now();
      Duration repeatInterval = parseReminderInterval(schedule.byTimeReminder!, schedule.byHourReminder!);

      scheduleRecurringNotification(
        id: schedule.id!,
        title: "Scheduled Service Reminder",
        body: "Reminder for ${schedule.service_task} on ${schedule.schedule_type}",
        firstScheduledDate: firstReminder,
        repeatInterval: repeatInterval,
      );
    } catch (e) {
      print("Error processing schedule ${schedule.id}: $e");
    }
  }
}


// Future<void> checkAndRescheduleReminders() async {
//   final dbCart = DB_schedule();
//   List<VehicleSchedule> schedules = await dbCart.fetchSchedule();
//
//   for (var schedule in schedules) {
//     DateTime reminderTime = DateTime.parse(schedule.byTimeReminder!);
//     int repeatHours = int.tryParse(schedule.byHourReminder!) ?? 24;
//
//     scheduleRecurringNotification(
//       id: schedule.id!,
//       title: "Scheduled Service Reminder",
//       body: "Reminder for ${schedule.service_task} on ${schedule.schedule_type}",
//       firstScheduledDate: reminderTime,
//       repeatIntervalInHours: repeatHours,
//     );
//   }
// }



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
        Provider<DashVehiclesBloc>(create: (_) => sl<DashVehiclesBloc>()),
        Provider<ProfileGenerateOtpBloc>(create: (_) => sl<ProfileGenerateOtpBloc>()),
        Provider<ProfileChangePwdBloc>(create: (_) => sl<ProfileChangePwdBloc>()),
        Provider<ProfileEmailVerifyBloc>(create: (_) => sl<ProfileEmailVerifyBloc>()),
        Provider<LogoutBloc>(create: (_) => sl<LogoutBloc>()),
        Provider<LastLocationBloc>(create: (_) => sl<LastLocationBloc>()),
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
        Provider<DeliveryLocationBloc>(create: (_) => sl<DeliveryLocationBloc>()),
        Provider<ConfirmPaymentBloc>(create: (_) => sl<ConfirmPaymentBloc>()),
        Provider<GetScheduleNoticeBloc>(create: (_) => sl<GetScheduleNoticeBloc>()),
        Provider<CompleteScheduleBloc>(create: (_) => sl<CompleteScheduleBloc>()),
        Provider<GetSingleScheduleNoticeBloc>(create: (_) => sl<GetSingleScheduleNoticeBloc>()),
        Provider<GetExpensesBloc>(create: (_) => sl<GetExpensesBloc>()),
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

