import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notifications.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create the general notifications table
        await db.execute('''
          CREATE TABLE notifications (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            vin TEXT,
            brand TEXT,
            model TEXT,
            numberPlate TEXT,
            createdAt TEXT,
            updatedAt TEXT
          )
        ''');

        // Create the speed limit notifications table
        await db.execute('''
          CREATE TABLE speed_limit_notifications (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            vin TEXT,
            brand TEXT,
            model TEXT,
            numberPlate TEXT,
            speedLimit TEXT,
            createdAt TEXT,
            updatedAt TEXT
          )
        ''');
      },
    );
  }

  // Insert into general notifications table
  Future<int> insertGeofenceNotification(Map<String, dynamic> notification) async {
    final db = await database;
    return db.insert('notifications', notification);
  }

  // Insert into speed limit notifications table
  Future<int> insertSpeedLimitNotification(Map<String, dynamic> notification) async {
    final db = await database;
    return db.insert('speed_limit_notifications', notification);
  }

  // Fetch notifications from the general table
  Future<List<Map<String, dynamic>>> fetchGeofenceNotifications() async {
    final db = await database;
    return await db.query('notifications', orderBy: 'createdAt DESC');
  }


  // Fetch notifications from the speed limit table
  Future<List<Map<String, dynamic>>> fetchSpeedLimitNotifications() async {
    final db = await database;
    return db.query('speed_limit_notifications', orderBy: 'createdAt DESC');
  }

  // Delete notification by ID from the general table
  Future<int> deleteNotification(int id) async {
    final db = await database;
    return db.delete('notifications', where: 'id = ?', whereArgs: [id]);
  }

  // Delete notification by ID from the speed limit table
  Future<int> deleteSpeedLimitNotification(int id) async {
    final db = await database;
    return db.delete('speed_limit_notifications', where: 'id = ?', whereArgs: [id]);
  }

  // Clear all general notifications
  Future<void> clearAllNotifications() async {
    final db = await database;
    await db.delete('notifications');
  }

  // Clear all speed limit notifications
  Future<void> clearAllSpeedLimitNotifications() async {
    final db = await database;
    await db.delete('speed_limit_notifications');
  }
}


// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();
//
//   factory DatabaseHelper() => _instance;
//
//   DatabaseHelper._internal();
//
//   static Database? _database;
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }
//
//   Future<Database> _initDatabase() async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, 'notifications.db');
//
//     return openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) {
//         return db.execute('''
//           CREATE TABLE notifications (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             vin TEXT,
//             brand TEXT,
//             model TEXT,
//             numberPlate TEXT,
//             speedLimit TEXT,
//             createdAt TEXT,
//             updatedAt TEXT,
//           )
//         ''');
//
//
//       },
//     );
//   }
//
//   Future<int> insertNotification(Map<String, dynamic> notification) async {
//     final db = await database;
//     return await db.insert('notifications', notification);
//   }
//
//   Future<List<Map<String, dynamic>>> fetchNotifications() async {
//     final db = await database;
//     return await db.query('notifications');
//   }
//
//   Future<int> deleteAllNotifications() async {
//     final db = await database;
//     return await db.delete('notifications');
//   }
//
//   Future<int> deleteNotification(int id) async {
//     final db = await database;
//     return await db.delete('notifications', where: 'id = ?', whereArgs: [id],);
//   }
//
// }


abstract class NotificationItem {
  String? get vin;
  String? get brand;
  String? get model;
  String? get numberPlate;
  String? get createdAt;
  String? get updatedAt;
}

class GeofenceNotificationItem implements NotificationItem {
  final int? id;
  final String? vin;
  final String? brand;
  final String? model;
  final String? numberPlate;
  final String? createdAt;
  final String? updatedAt;

  GeofenceNotificationItem({
    this.id,
    this.vin,
    this.brand,
    this.model,
    this.numberPlate,
    this.createdAt,
    this.updatedAt,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'vin': vin,
      'brand': brand,
      'model': model,
      'numberPlate': numberPlate,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }

  factory GeofenceNotificationItem.fromJson(Map<String, dynamic> map) {
    return GeofenceNotificationItem(
      id: map['id'],
      vin: map['vin'],
      brand: map['brand'],
      model: map['model'],
      numberPlate: map['numberPlate'],
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
    );
  }
}



class SpeedLimitNotificationItem implements NotificationItem {
  final int? id;
  final String? vin;
  final String? brand;
  final String? model;
  final String? numberPlate;
  final String? speedLimit;
  final String? createdAt;
  final String? updatedAt;

  SpeedLimitNotificationItem({
    this.id,
    this.vin,
    this.brand,
    this.model,
    this.numberPlate,
    this.speedLimit,
    this.createdAt,
    this.updatedAt,
  });

  @override
  Map<String, dynamic> fromJson() {
    return {
      'vin': vin,
      'brand': brand,
      'model': model,
      'numberPlate': numberPlate,
      'speedLimit': speedLimit,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }

  factory SpeedLimitNotificationItem.fromJson(Map<String, dynamic> map) {
    return SpeedLimitNotificationItem(
      id: map['id'],
      vin: map['vin'],
      brand: map['brand'],
      model: map['model'],
      numberPlate: map['numberPlate'],
      speedLimit: map['speedLimit'],
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
    );
  }
}


// //
// class NotificationItem {
//   final GeofenceNotificationItem geofenceNotificationItem;
//   final SpeedLimitNotificationItem speedLimitNotificationItem;
//
//
//   NotificationItem({required this.geofenceNotificationItem, required this.speedLimitNotificationItem});
//
//   factory NotificationItem.fromMap(Map<String, dynamic> json) {
//     return NotificationItem(
//       geofenceNotificationItem: json['geofenceNotificationItem'],
//       speedLimitNotificationItem: json['speedLimitNotificationItem']
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'geofenceNotificationItem': geofenceNotificationItem,
//       'speedLimitNotificationItem': speedLimitNotificationItem,
//     };
//   }
//
// }

////
// //
// class NotificationItem {
//   final List<GeofenceNotificationItem> geofenceNotificationItem;
//   final List<SpeedLimitNotificationItem> speedLimitNotificationItem;
//
//
//   NotificationItem({required this.geofenceNotificationItem, required this.speedLimitNotificationItem});
//
//   factory NotificationItem.fromMap(Map<String, dynamic> json) {
//     return NotificationItem(
//       geofenceNotificationItem: (json['geofenceNotificationItem'] as List).map((data) => GeofenceNotificationItem.fromJson(data)).toList(),
//       speedLimitNotificationItem: (json['speedLimitNotificationItem'] as List).map((data) => SpeedLimitNotificationItem.fromJson(data)).toList(),
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'geofenceNotificationItem': geofenceNotificationItem,
//       'speedLimitNotificationItem': speedLimitNotificationItem,
//     };
//   }
//
// }
///
//
// class GeofenceNotificationItem {
//   final int? id;
//   final String? vin;
//   final String? brand;
//   final String? model;
//   final String? numberPlate;
//   final bool? geofence;
//   final String? createdAt;
//   final String? updatedAt;
//
//   GeofenceNotificationItem({
//     this.id,
//     this.vin,
//     this.brand,
//     this.model,
//     this.numberPlate,
//     this.geofence,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       'vin': vin,
//       'brand': brand,
//       'model': model,
//       'numberPlate': numberPlate,
//       'geofence': geofence,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt
//     };
//   }
//
//   factory GeofenceNotificationItem.fromJson(Map<String, dynamic> map) {
//     return GeofenceNotificationItem(
//       id: map['id'],
//       vin: map['vin'],
//       brand: map['brand'],
//       model: map['model'],
//       numberPlate: map['numberPlate'],
//       createdAt: map['createdAt'] ?? '',
//       updatedAt: map['updatedAt'] ?? '',
//     );
//   }
// }
//
//
//
// class SpeedLimitNotificationItem {
//   final int? id;
//   final String? vin;
//   final String? brand;
//   final String? model;
//   final String? numberPlate;
//   final String? speedLimit;
//   final String? actualSpeed;
//   final String? createdAt;
//   final String? updatedAt;
//
//   SpeedLimitNotificationItem({
//     this.id,
//     this.vin,
//     this.brand,
//     this.model,
//     this.numberPlate,
//     this.speedLimit,
//     this.actualSpeed,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   Map<String, dynamic> fromJson() {
//     return {
//       'vin': vin,
//       'brand': brand,
//       'model': model,
//       'numberPlate': numberPlate,
//       'speedLimit': speedLimit,
//       'actualSpeed': actualSpeed,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt
//     };
//   }
//
//   factory SpeedLimitNotificationItem.fromJson(Map<String, dynamic> map) {
//     return SpeedLimitNotificationItem(
//       id: map['id'],
//       vin: map['vin'],
//       brand: map['brand'],
//       model: map['model'],
//       numberPlate: map['numberPlate'],
//       speedLimit: map['speedLimit'],
//       actualSpeed: map['actualSpeed'],
//       createdAt: map['createdAt'] ?? '',
//       updatedAt: map['updatedAt'] ?? '',
//     );
//   }
//
// }

