
import '../../modules/vehincle/domain/entities/resp_entities/route_history_resp_entity.dart';

class GpsProcessor {

  static Map<String, dynamic> calculateMetrics(List<DatumEntity> gpsData) {
    if (gpsData.isEmpty) {
      return {
        'routeStart': 0,
        'routeEnd': 0,
        'moveDuration': 0,
        'stopDuration': 0,
        'maxSpeed': 0.0,
        'averageSpeed': 0.0,
        'stopCount': 0,
      };
    }

    // Filter out stationary data (speed == 0)
    List<DatumEntity> movingData = gpsData.where((data) {
      final speed = double.tryParse(data.speed) ?? 0.0;
      return speed > 0.0;
    }).toList();

    if (movingData.isEmpty) {
      return {
        'routeStart': gpsData.first.created_at,
        'routeEnd': gpsData.last.created_at,
        'moveDuration': 0,
        'stopDuration': 0,
        'maxSpeed': 0.0,
        'averageSpeed': 0.0,
        'stopCount': gpsData.length,
      };
    }

    // Calculate route start and end
    DateTime routeStart =  DateTime.parse(movingData.first.fix_time);//movingData.first.created_at;
    DateTime routeEnd =  DateTime.parse(movingData.last.fix_time);//movingData.last.created_at;
    Duration moveDuration = routeEnd.difference(routeStart);

    // Maximum speed and average speed
    double maxSpeed = movingData
        .map((data) => double.tryParse(data.speed) ?? 0.0)
        .reduce((a, b) => a > b ? a : b);

    double averageSpeed = movingData
        .map((data) => double.tryParse(data.speed) ?? 0.0)
        .reduce((a, b) => a + b) /
        movingData.length;

    // Count stops and total stop duration
    int stopCount = gpsData.length - movingData.length;
    Duration totalStopDuration = _calculateStopDuration(gpsData);
    print(">>>>>>> kkkkkkkkkkkkkkkkkkkkkkk1<<<<<<<<<");
    return {
      'routeStart': routeStart.toString(),
      'routeEnd': routeEnd.toString(),
      'moveDuration': moveDuration.inMinutes.toInt(),
      'stopDuration': totalStopDuration.inMinutes.toInt(),
      'maxSpeed': maxSpeed,
      'averageSpeed': averageSpeed,
      'stopCount': stopCount,
    };
  }

  static Duration _calculateStopDuration(List<DatumEntity> gpsData) {
    Duration totalStopDuration = Duration.zero;
    DateTime? stopStartTime;

    for (int i = 0; i < gpsData.length; i++) {
      final speed = double.tryParse(gpsData[i].speed) ?? 0.0;

      // Parse created_at as DateTime
      final createdAt = DateTime.tryParse(gpsData[i].fix_time);
      if (createdAt == null) {
        throw FormatException('Invalid date format in created_at: ${gpsData[i].fix_time}');
      }

      if (speed == 0.0) {
        // Start tracking stop time if not already tracking
        stopStartTime ??= createdAt;
      } else {
        // If a stop period ends, calculate the duration
        if (stopStartTime != null) {
          totalStopDuration += createdAt.difference(stopStartTime);
          stopStartTime = null; // Reset stop start time
        }
      }
    }

    // If the last entry is a stop, add its duration
    if (stopStartTime != null) {
      final lastCreatedAt = DateTime.tryParse(gpsData.last.fix_time);
      if (lastCreatedAt == null) {
        throw FormatException('Invalid date format in last created_at: ${gpsData.last.fix_time}');
      }
      totalStopDuration += lastCreatedAt.difference(stopStartTime);
    }
    print(">>>>>>> kkkkkkkkkkkkkkkkkkkkkkk2<<<<<<<<<");
    return totalStopDuration;
  }


// static Duration _calculateStopDuration(List<DatumEntity> gpsData) {
//   Duration totalStopDuration = Duration.zero;
//
//   DateTime? stopStartTime;
//
//   for (int i = 0; i < gpsData.length; i++) {
//     final speed = double.tryParse(gpsData[i].speed) ?? 0.0;
//
//     if (speed == 0.0) {
//       // Start tracking stop time if not already tracking
//       if (stopStartTime == null) {
//         stopStartTime = gpsData[i].created_at;
//       }
//     } else {
//       // If a stop period ends, calculate the duration
//       if (stopStartTime != null) {
//         totalStopDuration += gpsData[i].created_at.difference(stopStartTime);
//         stopStartTime = null; // Reset stop start time
//       }
//     }
//   }
//
//   // If the last entry is a stop, add its duration
//   if (stopStartTime != null) {
//     totalStopDuration += gpsData.last.created_at.difference(stopStartTime);
//   }
//
//   return totalStopDuration;
// }
}