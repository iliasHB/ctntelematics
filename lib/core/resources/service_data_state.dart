
import 'package:dio/dio.dart';

import '../../modules/service/data/models/resp_models/get_country_state_resp_model.dart';
import '../../modules/service/data/models/resp_models/get_service_payment_resp_model.dart';
import '../../modules/service/data/models/resp_models/get_services_model.dart';
import '../network/network_exception.dart';

class ApiErrorException implements Exception {
  final String message;

  ApiErrorException(this.message);
}

Future<GetServicePaymentRespModel> handleInitializePaymentError(Future<GetServicePaymentRespModel> future) async {
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
    } else if (error.response?.statusCode == 401 || error.response?.statusCode == 404) {
      // Parse the error response and throw a custom exception with the API message
      final errorResponse = error.response?.data;
      if(errorResponse['message'] != null){
        throw ApiErrorException(errorResponse['message']);
      }
      throw ApiErrorException(errorResponse['message'] ?? "Access token expired");
    } else if(error.response?.statusCode == 422 ){
      print('actual error::::::: ${error.response?.data.toString()}');
      // Parse the error response for a 422 Unprocessable Entity error
      final errorResponse = error.response?.data;
      if (errorResponse != null && errorResponse['errors'] != null) {
        throw ApiErrorException(errorResponse['message']);
      }
      throw ApiErrorException("Error: An unexpected error occurred.");
    }

    else {
      throw Exception("An unexpected error occurred.");
    }
  }
}


Future<List<GetServicesRespModel>> handleGetServiceError(Future<List<GetServicesRespModel>> future) async {
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
    } else if (error.response?.statusCode == 401 || error.response?.statusCode == 404) {
      // Parse the error response and throw a custom exception with the API message
      final errorResponse = error.response?.data;
      if(errorResponse != null && errorResponse['message'] != null){
        throw ApiErrorException(errorResponse['message']);
      }
      throw ApiErrorException(errorResponse['message'] ?? "Access token expired");
    } else if(error.response?.statusCode == 422 ){
      print('actual error::::::: ${error.response?.data.toString()}');
      // Parse the error response for a 422 Unprocessable Entity error
      final errorResponse = error.response?.data;
      if (errorResponse != null && errorResponse['errors'] != null) {
        throw ApiErrorException(errorResponse['message']);
      }
      throw ApiErrorException("Error: An unexpected error occurred.");
    }

    else {
      throw Exception("An unexpected error occurred.");
    }
  }
}



Future<GetCountryStateModel> handleCountryStateError(Future<GetCountryStateModel> future) async {
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
    } else if (error.response?.statusCode == 401 || error.response?.statusCode == 404) {
      // Parse the error response and throw a custom exception with the API message
      final errorResponse = error.response?.data;
      if(errorResponse != null && errorResponse['message'] != null){
        throw ApiErrorException(errorResponse['message']);
      }
      throw ApiErrorException(errorResponse['message'] ?? "Access token expired");
    } else if(error.response?.statusCode == 422 ){
      print('actual error::::::: ${error.response?.data.toString()}');
      // Parse the error response for a 422 Unprocessable Entity error
      final errorResponse = error.response?.data;
      if (errorResponse != null && errorResponse['errors'] != null) {
        throw ApiErrorException(errorResponse['message']);
      }
      throw ApiErrorException("Error: An unexpected error occurred.");
    }

    else {
      throw Exception("An unexpected error occurred.");
    }
  }
}
