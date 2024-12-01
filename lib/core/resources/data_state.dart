import 'dart:async';

import 'package:dio/dio.dart';

import '../../modules/authentication/data/models/auth_resp_models/auth_resp_model.dart';
import '../../modules/authentication/data/models/auth_resp_models/gen_otp_resp_model.dart';
import '../../modules/authentication/data/models/auth_resp_models/login_resp_model.dart';
import '../../modules/vehincle/data/models/resp_models/vehicles_resp_model.dart';
import '../network/network_exception.dart';


class ApiErrorException implements Exception {
  final String message;

  ApiErrorException(this.message);
}

// Helper method to check the response status and throw appropriate exceptions
Future<LoginRespModel> handleLoginErrorHandling(Future<LoginRespModel> future) async {
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

      throw ApiErrorException(errorResponse['message'] ?? "Invalid email or password.");
    } else {
      throw Exception("An unexpected error occurred.");
    }
  }
}


// Helper method to check the response status and throw appropriate exceptions
Future<AuthRespModel> handleOtpErrorHandling(Future<AuthRespModel> future) async {
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

      throw ApiErrorException(errorResponse['message'] ?? "Invalid email or password.");
    }  else if(error.response?.statusCode == 422){
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
