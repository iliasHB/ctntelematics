
import 'package:dio/dio.dart';

import '../../modules/dashboard/data/models/resp_models/dash_vehicle_resp_model.dart';
import '../network/network_exception.dart';

class ApiErrorException implements Exception {
  final String message;

  ApiErrorException(this.message);
}

// Helper method to check the response status and throw appropriate exceptions
Future<DashVehicleRespModel> handleDashVehicleErrorHandling(Future<DashVehicleRespModel> future) async {
  try {
    return await future;
  } on DioException catch (error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.unknown ||
        // error.type == DioExceptionType.badResponse ||
        error.type == DioExceptionType.badCertificate ||
        error.type == DioExceptionType.cancel ||
        error.type == error.message!.contains('SocketException')) {

      throw NetworkException(); // Handle network-related exceptions
    } else if (error.response?.statusCode == 401 || error.response?.statusCode == 422) {
      // Parse the error response and throw a custom exception with the API message
      final errorResponse = error.response?.data;

      throw ApiErrorException(errorResponse['message'] ?? "An unexpected error occurred.");
    } else {
      throw Exception("An unexpected error occurred.");
    }
  }
}
