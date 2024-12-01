

import 'package:ctntelematics/modules/map/data/models/resp_models/route_history_model.dart';
import 'package:dio/dio.dart';

import '../../modules/map/data/models/resp_models/last_location_resp_model.dart';
import '../../modules/map/data/models/resp_models/resp_model.dart';
import '../network/network_exception.dart';

class ApiErrorException implements Exception {
  final String message;

  ApiErrorException(this.message);
}

Future<List<LastLocationRespModel>> handleLastLocationError(Future<List<LastLocationRespModel>> future) async {
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

      throw ApiErrorException(errorResponse['message'] ?? "Access token expired");
    } else {
      throw Exception("An unexpected error occurred.");
    }
  }
}

Future<RouteHistoryRespModel> handleRouteHistoryError(Future<RouteHistoryRespModel> future) async {
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
    } else if (error.response?.statusCode == 401 ) {
      // Parse the error response and throw a custom exception with the API message
      final errorResponse = error.response?.data;

      throw ApiErrorException(errorResponse['message'] ?? "Access token expired");
    } else if (error.response?.statusCode == 422) {
      print(":::::::::::::::--here--::::::::::::::");
      // Parse the error response for a 422 Unprocessable Entity error
      final errorResponse = error.response?.data;
      if (errorResponse != null && errorResponse['errors'] != null) {
        // Extract the specific validation error, e.g., vehicle_vin
        final vehicleVinErrors = errorResponse['errors']['vehicle_vin'];
        final timeFromErrors = errorResponse['errors']['time_from'];
        final timeToErrors = errorResponse['errors']['time_to'];
        print("vehicleVinErrors::: $vehicleVinErrors");
        print("timeFromErrors::: $timeFromErrors");
        print("timeToErrors::: $timeToErrors");
        if (vehicleVinErrors != null && vehicleVinErrors.isNotEmpty) {
          throw ApiErrorException(vehicleVinErrors.first);
        }
        if(timeFromErrors != null && timeFromErrors.isNotEmpty){
          throw ApiErrorException(timeFromErrors.first);
        }
        if(timeToErrors != null && timeToErrors.isNotEmpty){
          throw ApiErrorException(timeToErrors.first);
        }
      }
      throw ApiErrorException("Error: An unexpected error occurred.");
    } else {
      throw Exception("An unexpected error occurred.");
    }
  }
}


Future<RespModel> handleSendLocationError(Future<RespModel> future) async {
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

      throw ApiErrorException(
          errorResponse['message'] ?? "Email fail");
    } else {
      throw Exception("An unexpected error occurred.");
    }
  }
}

