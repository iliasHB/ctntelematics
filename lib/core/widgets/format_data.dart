import 'package:intl/intl.dart'; //

class FormatData {
  static handle2DecimalPointFormat(double value){
    String formattedValue = "${value.toStringAsFixed(2)}km";
    return formattedValue;
  }

  static String formatTimestamp(String timestamp) {
    try {
      // Parse the string timestamp into a DateTime object
      DateTime parsedTimestamp = DateTime.parse(timestamp);

      // Format the DateTime object into the desired format
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedTimestamp);
    } catch (e) {
      // Handle parsing errors
      print('Error parsing timestamp: $e');
      return timestamp; // Return the original string if parsing fails
    }
  }
  static String formatTimestampToDate(String timestamp) {
    final DateTime dateTime = DateTime.parse(timestamp);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  static String convertDurationToDate(String duration) {
    final now = DateTime.now(); // Current date
    final today = DateTime(now.year, now.month, now.day); // Strip time
    final parts = duration.split(" "); // Split the input (e.g., "10 months")

    if (parts.length != 2) {
      throw ArgumentError("Invalid format. Expected format: '<number> <unit>'");
    }

    final int value = int.tryParse(parts[0]) ?? 0; // Extract the numeric value
    final String unit = parts[1].toLowerCase(); // Extract the unit (e.g., days, months)

    DateTime result;

    switch (unit) {
      case 'days':
      case 'day':
        print('today::::---');
        print(today.add(Duration(days: value)));
        result = today.add(Duration(days: value)); // Add dynamic days
        break;
      case 'months':
      case 'month':
      print('month::::---');

        result = DateTime(today.year, today.month + value, today.day); // Add dynamic months
      print(DateFormat('yyyy-MM-dd').format(result));
      break;
      case 'years':
      case 'year':
      print('year::::---');
      print(today.add(Duration(days: value)));
        result = DateTime(today.year + value, today.month, today.day); // Add dynamic years
        break;
      default:
        throw ArgumentError("Unsupported time unit: $unit");
    }

    // Format the result to 'YYYY-MM-DD' without time
    return DateFormat('yyyy-MM-dd').format(result);
  }

  static String calculateReminderTime(int hoursFromNow) {
    final now = DateTime.now(); // Current date and time
    final reminderTime = now.add(Duration(hours: hoursFromNow)); // Add the selected hours
    return DateFormat('HH:mm').format(reminderTime); // Format to show only the time
  }

  static String formatTimeAgo(String timestamp) {
    final DateTime now = DateTime.now();
    final DateTime dateTime = DateTime.parse(timestamp);
    final Duration difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}min ago';
    } else if (difference.inHours < 24) {
      final int hours = difference.inHours;
      final int minutes = difference.inMinutes % 60;
      return minutes > 0 ? '${hours}hr ${minutes}min ago' : '${hours}hr ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final int weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 365) {
      final int months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final int years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }

}