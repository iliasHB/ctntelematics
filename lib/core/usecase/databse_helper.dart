import 'dart:ui';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../modules/websocket/domain/entitties/resp_entities/vehicle_entity.dart';

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
      version: 4,
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

        // Create the user cart table
        await db.execute('''
          CREATE TABLE user_carts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            productId INTEGER,
            name TEXT,
            description TEXT,
            price TEXT,
            stock_quantity TEXT,
            sku TEXT,
            image TEXT,
            category_id INTEGER,
            is_active INTEGER,
            createdAt TEXT,
            updatedAt TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE profile_picture (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER NOT NULL,
            filePath TEXT NOT NULL,
            uploadedAt TEXT NOT NULL 
          )
        ''');

        await db.execute('''
          CREATE TABLE schedule (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            vehicle_vin TEXT NOT NULL,
            service_task TEXT NOT NULL,
            schedule TEXT NOT NULL,
            byTime TEXT,
            byTimeReminder TEXT,
            byHour TEXT,
            byHourReminder TEXT,
            no_kilometer TEXT,
            reminder_advance_km TEXT,
            createdAt TEXT
            )
        ''');

      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 4) {

          // Create the schedule table
          await db.execute('''
          CREATE TABLE schedule (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            vehicle_vin TEXT NOT NULL,
            service_task TEXT NOT NULL,
            schedule_type TEXT NOT NULL,
            byTime TEXT,
            byTimeReminder TEXT,
            byHour TEXT,
            byHourReminder TEXT,
            no_kilometer TEXT,
            reminder_advance_km TEXT,
            createdAt TEXT
            )
        ''');

        }
      },
    );
  }

  // Print all tables in the database
  Future<void> printTables() async {
    final db = await database;

    // Query the sqlite_master table for table names
    List<Map<String, dynamic>> tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table';"
    );

    print('Tables in the database:');
    for (var table in tables) {
      print('- ${table['name']}');
    }
  }

  // Insert into general notifications table
  Future<int> insertGeofenceNotification(
      Map<String, dynamic> notification) async {
    final db = await database;
    return db.insert('notifications', notification);
  }

  // Insert into speed limit notifications table
  Future<int> insertSpeedLimitNotification(
      Map<String, dynamic> notification) async {
    final db = await database;
    return db.insert('speed_limit_notifications', notification);
  }

  // Insert into user cart table
  Future<int> insertUserCart(Map<String, dynamic> cart) async {
    final db = await database;
    return db.insert('user_carts', cart);
  }

  // Insert into user schedule table
  Future<int> insertSchedule(Map<String, dynamic> schedule) async {
    final db = await database;
    return db.insert('schedules', schedule);
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

  // Fetch user cart from the general table
  Future<List<Map<String, dynamic>>> fetchUserCart() async {
    final db = await database;
    return await db.query('user_carts', orderBy: 'createdAt DESC');
  }

  // Fetch user cart from the general table
  Future<List<Map<String, dynamic>>> fetchSchedule() async {
    final db = await database;
    return await db.query('schedules', orderBy: 'createdAt DESC');
  }

  // Delete notification by ID from the general table
  Future<int> deleteNotification(int id) async {
    final db = await database;
    return db.delete('notifications', where: 'id = ?', whereArgs: [id]);
  }

  // Delete notification by ID from the speed limit table
  Future<int> deleteSpeedLimitNotification(int id) async {
    final db = await database;
    return db
        .delete('speed_limit_notifications', where: 'id = ?', whereArgs: [id]);
  }

  // Delete notification by ID from the speed limit table
  Future<int> deleteUserCart(int id) async {
    final db = await database;
    return db.delete('user_carts', where: 'id = ?', whereArgs: [id]);
  }
  // Delete notification by ID from the speed limit table
  Future<int> deleteSchedule(int id) async {
    final db = await database;
    return db.delete('schedules', where: 'id = ?', whereArgs: [id]);
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

  // Clear all user carts
  Future<void> clearAllUserCart() async {
    final db = await database;
    await db.delete('user_carts');
  }

  Future<void> clearAllSchedule() async {
    final db = await database;
    await db.delete('schedules');
  }

  // Insert a profile picture
  Future<int> insertProfilePicture(Map<String, dynamic> picture) async {
    final db = await database;
    return db.insert('profile_picture', picture);
  }

  // // Fetch profile pictures by userId
  Future<Map<String, dynamic>?> fetchLatestProfilePicture(int userId) async {
    final db = await database;
    final results = await db.query(
      'profile_picture',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'uploadedAt DESC',
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  //Update profile pictures by userId
  Future<void> updateProfilePicture(int userId, Map<String, dynamic> data) async {
    final db = await database;

    // Check if a record exists for the user
    final existingPictures = await db.query(
      'profile_picture',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (existingPictures.isNotEmpty) {
      // Update the existing record
      await db.update(
        'profile_picture',
        data,
        where: 'userId = ?',
        whereArgs: [userId],
      );
    } else {
      // Insert a new record if none exists
      await db.insert('profile_picture', data);
    }
  }



  // // Fetch profile pictures by userId
  // Future<List<Map<String, dynamic>>> fetchProfilePictures(int userId) async {
  //   final db = await database;
  //   return db.query('profile_picture',
  //       where: 'userId = ?', whereArgs: [userId], orderBy: 'uploadedAt DESC');
  // }

  // Delete a profile picture by ID
  Future<int> deleteProfilePicture(int id) async {
    final db = await database;
    return db.delete('profile_picture', where: 'id = ?', whereArgs: [id]);
  }

  // Clear all profile pictures (optional)
  Future<void> clearAllProfilePictures() async {
    final db = await database;
    await db.delete('profile_picture');
  }
}

class DB_notification {
  Future<void> saveNotifications(
    List<VehicleEntity> geofenceVehicles,
    List<VehicleEntity> speedLimitVehicles,
  ) async {
    final dbHelper = DatabaseHelper();

    // Save geofence notifications
    for (var v in geofenceVehicles) {
      await dbHelper.insertGeofenceNotification({
        'vin': v.locationInfo.vin,
        'brand': v.locationInfo.brand,
        'model': v.locationInfo.model,
        'numberPlate': v.locationInfo.numberPlate,
        'createdAt': v.locationInfo.tracker?.lastUpdate,
      });
    }

    // Save speed limit notifications
    for (var v in speedLimitVehicles) {
      await dbHelper.insertSpeedLimitNotification({
        'vin': v.locationInfo.vin,
        'brand': v.locationInfo.brand,
        'model': v.locationInfo.model,
        'numberPlate': v.locationInfo.numberPlate,
        'speedLimit': v.locationInfo.speedLimit,
        'createdAt':v.locationInfo.tracker?.lastUpdate,
      });
    }
  }

  Future<List<NotificationItem>> fetchCombinedNotifications() async {
    final dbHelper = DatabaseHelper();

    final geofenceData = await dbHelper.fetchGeofenceNotifications();
    final speedLimitData = await dbHelper.fetchSpeedLimitNotifications();

    // Convert to respective objects
    List<NotificationItem> geofenceItems = geofenceData
        .map((row) => GeofenceNotificationItem.fromJson(row))
        .toList();
    List<NotificationItem> speedLimitItems = speedLimitData
        .map((row) => SpeedLimitNotificationItem.fromJson(row))
        .toList();

    // Combine lists
    List<NotificationItem> allNotifications = [
      ...geofenceItems,
      ...speedLimitItems
    ];

    return allNotifications;
  }
}

class DB_cart {
  Future<bool> saveProducts(
    String productName,
    String productImage,
    String price,
    String categoryId,
    String description,
    int productId,
  ) async {
    final dbHelper = DatabaseHelper();

// Insert the item into the user_cart table
    int result = await dbHelper.insertUserCart({
      'productId': productId,
      'name': productName,
      'description': description,
      'price': price,
      'stock_quantity': '',
      'sku': '',
      'image': productImage,
      'category_id': categoryId,
      'is_active': 1,
      'createdAt': DateTime.now().toString(),
      'updatedAt': ''
    });
    // Check the result
    return result > 0; // Returns true if successfully inserted
  }


  Future<List<CartProducts>> fetchUserCart() async {
    final dbHelper = DatabaseHelper();

    final userCartItem = await dbHelper.fetchUserCart();

    // Convert to respective objects
    List<CartProducts> userCartItems =
        userCartItem.map((row) => CartProducts.fromJson(row)).toList();

    // Combine lists
    List<CartProducts> allUserCarts = userCartItems;

    return allUserCarts;
  }

  // Method to delete a specific product from the cart
  Future<bool> deleteProduct(int productId) async {
    final dbHelper = DatabaseHelper();

    try {
      int rowsAffected = await dbHelper.deleteUserCart(productId);
      return rowsAffected > 0; // Return true if deletion was successful
    } catch (e) {
      print('Error deleting product from cart: $e');
      return false; // Return false if there was an error
    }
  }
}

class DB_schedule {
  Future<bool> saveSchedule(
      String vehicle_vin,
      String service_task,
      String schedule_type,
      String byTime,
      String byTimeReminder,
      String byHour,
      String byHourReminder,
      String no_kilometer,
      String reminder_advance_km,
      String createdAt,) async {
    final dbHelper = DatabaseHelper();

// Insert the item into the user_cart table
    int result = await dbHelper.insertSchedule({
      'vehicle_vin': vehicle_vin,
      'service_task': service_task,
      'schedule_type': schedule_type,
      'byTime': byTime,
      'byTimeReminder': byTimeReminder,
      'byHour': byHour,
      'byHourReminder': byHourReminder,
      'no_kilometer': no_kilometer,
      'reminder_advance_km': reminder_advance_km,
      'createdAt': createdAt,
    });
    // Check the result
    return result > 0; // Returns true if successfully inserted
  }

  Future<List<VehicleSchedule>> fetchSchedule() async {
    final dbHelper = DatabaseHelper();

    final vehicleSchedule = await dbHelper.fetchSchedule();

    // Convert to respective objects
    List<VehicleSchedule> vehicleSchedules =
    vehicleSchedule.map((row) => VehicleSchedule.fromJson(row)).toList();

    // Combine lists
    List<VehicleSchedule> allVehicleSchedule = vehicleSchedules;

    return allVehicleSchedule;
  }

  // Method to delete a specific product from the cart
  Future<bool> deleteSchedule(int id) async {
    final dbHelper = DatabaseHelper();

    try {
      int rowsAffected = await dbHelper.deleteSchedule(id);
      return rowsAffected > 0; // Return true if deletion was successful
    } catch (e) {
      print('Error deleting product from cart: $e');
      return false; // Return false if there was an error
    }
  }
}

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

class CartProducts {
  final int? id;
  final int? productId;
  final String? name;
  final String? description;
  final String? price;
  final String? stock_quantity;
  final String? image;
  final String? sku;
  final int? category_id;
  final int? is_active;
  final String? createdAt;
  final String? updatedAt;

  CartProducts({
    this.id,
    this.productId,
    this.name,
    this.description,
    this.price,
    this.stock_quantity,
    this.image,
    this.sku,
    this.category_id,
    this.is_active,
    this.createdAt,
    this.updatedAt,
  });

  /// Converts the CartProducts object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name, // Changed to match the database key
      'description': description,
      'price': price,
      'stock_quantity': stock_quantity,
      'sku': sku,
      'image': image,
      'category_id': category_id,
      'is_active': is_active,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Creates a CartProducts object from a JSON map
  factory CartProducts.fromJson(Map<String, dynamic> map) {
    return CartProducts(
      id: map['id'],
      productId: map['productId'],
      name: map['name'], // Matches the database key
      description: map['description'],
      price: map['price'],
      stock_quantity: map['stock_quantity'],
      sku: map['sku'],
      image: map['image'],
      category_id: map['category_id'],
      is_active: map['is_active'],
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
    );
  }
}



class VehicleSchedule {
  final int? id;
  final String? vehicle_vin;
      final String? service_task;
  final String? schedule_type;
      final String? byTime;
  final String? byTimeReminder;
      final String? byHour;
  final String? byHourReminder;
      final String? no_kilometer;
  final String? reminder_advance_km;
      final String? createdAt;

  VehicleSchedule({
    this.id,
    this.schedule_type,
    this.createdAt,
    this.reminder_advance_km,
    this.no_kilometer,
    this.byHourReminder,
    this.byHour,
    this.vehicle_vin,
    this.byTimeReminder,
    this.byTime,
    this.service_task
  });

  /// Converts the CartProducts object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_vin': vehicle_vin,
      'service_task': service_task,
      'schedule_type': schedule_type,
      'byTime': byTime,
      'byTimeReminder': byTimeReminder,
      'byHour': byHour,
      'byHourReminder': byHourReminder,
      'no_kilometer': no_kilometer,
      'reminder_advance_km': reminder_advance_km,
      'createdAt': createdAt,
    };
  }

  /// Creates a CartProducts object from a JSON map
  factory VehicleSchedule.fromJson(Map<String, dynamic> map) {
    return VehicleSchedule(
      id: map['id'],
      vehicle_vin: map['vehicle_vin'],
      service_task: map['service_task'], // Matches the database key
      byTime: map['byTime'],
      byTimeReminder: map['byTimeReminder'],
      byHour: map['byHour'],
      byHourReminder: map['byHourReminder'],
      no_kilometer: map['no_kilometer'],
      reminder_advance_km: map['reminder_advance_km'],
      createdAt: map['createdAt'] ?? '',
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
