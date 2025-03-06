import 'package:dio/dio.dart';

import '../../modules/profile/data/models/resp_models/complete_schedule_resp_model.dart';
import '../../modules/profile/data/models/resp_models/create_schedule_resp_model.dart';
import '../../modules/profile/data/models/resp_models/get_schedule_notice_resp_model.dart';
import '../../modules/profile/data/models/resp_models/get_schedule_resp_model.dart';
import '../../modules/profile/data/models/resp_models/profile_resp_model.dart';
import '../../modules/profile/data/models/resp_models/profile_vehicles_resp_model.dart';
import '../network/network_exception.dart';

class ApiErrorException implements Exception {
  final String message;

  ApiErrorException(this.message);
}

Future<ProfileRespModel> handleProfileErrorHandling(Future<ProfileRespModel> future) async {
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
    } else if (error.response?.statusCode == 401) {
      // Parse the error response and throw a custom exception with the API message
      final errorResponse = error.response?.data;

      throw ApiErrorException(errorResponse['message'] ?? "Access token expired");
    } else if(error.response?.statusCode == 422){
      print('actual error::::::: ${error.response?.data.toString()}');
      // Parse the error response for a 422 Unprocessable Entity error
      final errorResponse = error.response?.data;
      if (errorResponse != null && errorResponse['errors'] != null) {
        // Extract the specific validation error, e.g., vehicle_vin
        final errors = errorResponse['errors'];
        final emailErrors = errorResponse['errors']['email'];
        final passwordErrors = errorResponse['errors']['password'];
        final otpErrors = errorResponse['errors']['otp'];
        print("emailErrors::: $emailErrors");
        print("passwordErrors::: $passwordErrors");
        print("otpErrors::: $otpErrors");
        if (emailErrors != null && emailErrors.isNotEmpty) {
          throw ApiErrorException(emailErrors.first);
        }
        if(passwordErrors != null && passwordErrors.isNotEmpty){
          throw ApiErrorException(passwordErrors.first);
        }
        if(otpErrors != null && otpErrors.isNotEmpty){
          print("otpErrors22222::: $otpErrors");
          throw ApiErrorException(otpErrors.first);
        }
        if(errors != null && errors.isNotEmpty){
          throw ApiErrorException(errors);
        }
      }
      throw ApiErrorException("Error: An unexpected error occurred.");
    }

    else {
      throw Exception("An unexpected error occurred.");
    }
  }
}


Future<GetScheduleRespModel> handleGetScheduleErrorHandling(Future<GetScheduleRespModel> future) async {
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
    } else if (error.response?.statusCode == 401) {
      // Parse the error response and throw a custom exception with the API message
      final errorResponse = error.response?.data;

      throw ApiErrorException(errorResponse['message'] ?? "Access token expired");
    } else if(error.response?.statusCode == 422){
      // Parse the error response for a 422 Unprocessable Entity error
      final errorResponse = error.response?.data;
      if (errorResponse != null && errorResponse['errors'] != null) {
        // Extract the specific validation error, e.g., vehicle_vin
        final errors = errorResponse['errors'];
        final emailErrors = errorResponse['errors']['email'];
        final passwordErrors = errorResponse['errors']['password'];
        final otpErrors = errorResponse['errors']['otp'];
        print("emailErrors::: $emailErrors");
        print("passwordErrors::: $passwordErrors");
        print("otpErrors::: $otpErrors");
        if (emailErrors != null && emailErrors.isNotEmpty) {
          throw ApiErrorException(emailErrors.first);
        }
        if(passwordErrors != null && passwordErrors.isNotEmpty){
          throw ApiErrorException(passwordErrors.first);
        }
        if(otpErrors != null && otpErrors.isNotEmpty){
          print("otpErrors22222::: $otpErrors");
          throw ApiErrorException(otpErrors.first);
        }
        if(errors != null && errors.isNotEmpty){
          throw ApiErrorException(errors);
        }
      }
      throw ApiErrorException("Error: An unexpected error occurred.");
    }

    else {
      throw Exception("An unexpected error occurred.");
    }
  }
}


Future<CreateScheduleRespModel> handleCreateScheduleErrorHandling(Future<CreateScheduleRespModel> future) async {
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
    } else if (error.response?.statusCode == 401) {
      // Parse the error response and throw a custom exception with the API message
      final errorResponse = error.response?.data;

      throw ApiErrorException(errorResponse['message'] ?? "Access token expired");
    } else if(error.response?.statusCode == 422){

      // Parse the error response for a 422 Unprocessable Entity error
      final errorResponse = error.response?.data;
      print('errorrrr:::::: ${errorResponse.toString()}');
      if (errorResponse != null && errorResponse['errors'] != null) {
        // Extract the specific validation error, e.g., vehicle_vin
        final errors = errorResponse['errors'];
        final vehicle_vin_Errors = errorResponse['errors']['vehicle_vin'];
        final schedule_type = errorResponse['errors']['schedule_type'];
        final otpErrors = errorResponse['errors']['otp'];
        print("vehicle_vin_Errors::: $vehicle_vin_Errors");
        print("schedule_type::: $schedule_type");
        print("otpErrors::: $otpErrors");
        if (vehicle_vin_Errors != null && vehicle_vin_Errors.isNotEmpty) {
          throw ApiErrorException(vehicle_vin_Errors.first);
        }
        if(schedule_type != null && schedule_type.isNotEmpty){
          throw ApiErrorException(schedule_type.first);
        }
        if(otpErrors != null && otpErrors.isNotEmpty){
          print("otpErrors11111::: $otpErrors");
          throw ApiErrorException(otpErrors.first);
        }
        if(errors != null && errors.isNotEmpty){
          throw ApiErrorException(errors);
        }
      }
      throw ApiErrorException("Error: An unexpected error occurred.");
    }

    else {
      throw Exception("An unexpected error occurred.");
    }
  }
}


Future<ProfileVehicleRespModel> handleProfileVehicleErrorHandling(Future<ProfileVehicleRespModel> future) async {
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

    } else if(error.response?.statusCode == 422){
      final errorResponse = error.response?.data;
      if (errorResponse != null && errorResponse['errors'] != null) {
        // Extract the specific validation error, e.g., vehicle_vin
        final errors = errorResponse['errors'];
        if(errors != null && errors.isNotEmpty){
          throw ApiErrorException(errors);
        }
      }
      throw ApiErrorException("Error: An unexpected error occurred.");
    }
    else {
      throw Exception("An unexpected error occurred.");
    }
  }
}


Future<List<GetScheduleNoticeRespModel>> handleScheduleNoticeErrorHandling(Future<List<GetScheduleNoticeRespModel>> future) async {
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

    } else if(error.response?.statusCode == 422){
      final errorResponse = error.response?.data;
      if (errorResponse != null && errorResponse['errors'] != null) {
        // Extract the specific validation error, e.g., vehicle_vin
        final errors = errorResponse['errors'];
        if(errors != null && errors.isNotEmpty){
          throw ApiErrorException(errors);
        }
      }
      throw ApiErrorException("Error: An unexpected error occurred.");
    }
    else {
      throw Exception("An unexpected error occurred.");
    }
  }
}

Future<CompleteScheduleRespModel> handleCompleteScheduleErrorHandling(Future<CompleteScheduleRespModel> future) async {
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
    } else if (error.response?.statusCode == 401) {
      // Parse the error response and throw a custom exception with the API message
      final errorResponse = error.response?.data;

      throw ApiErrorException(errorResponse['message'] ?? "Access token expired");
    } else if(error.response?.statusCode == 422){

      // Parse the error response for a 422 Unprocessable Entity error
      final errorResponse = error.response?.data;
      print('errorrrr:::::: ${errorResponse.toString()}');
      if (errorResponse != null && errorResponse['errors'] != null) {
        // Extract the specific validation error, e.g., vehicle_vin
        final errors = errorResponse['errors'];
        final vehicle_vin_Errors = errorResponse['errors']['vehicle_vin'];
        final schedule_type = errorResponse['errors']['schedule_type'];
        final otpErrors = errorResponse['errors']['otp'];
        print("vehicle_vin_Errors::: $vehicle_vin_Errors");
        print("schedule_type::: $schedule_type");
        print("otpErrors::: $otpErrors");
        if (vehicle_vin_Errors != null && vehicle_vin_Errors.isNotEmpty) {
          throw ApiErrorException(vehicle_vin_Errors.first);
        }
        if(schedule_type != null && schedule_type.isNotEmpty){
          throw ApiErrorException(schedule_type.first);
        }
        if(otpErrors != null && otpErrors.isNotEmpty){
          print("otpErrors11111::: $otpErrors");
          throw ApiErrorException(otpErrors.first);
        }
        if(errors != null && errors.isNotEmpty){
          throw ApiErrorException(errors);
        }
      }
      throw ApiErrorException("Error: An unexpected error occurred.");
    }

    else {
      throw Exception("An unexpected error occurred.");
    }
  }
}


