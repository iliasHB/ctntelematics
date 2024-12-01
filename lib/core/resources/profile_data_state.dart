import 'package:dio/dio.dart';

import '../../modules/profile/data/models/resp_models/profile_resp_model.dart';
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
