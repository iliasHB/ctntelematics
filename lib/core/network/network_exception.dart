class NetworkException implements Exception {
  final String message;

  NetworkException({this.message = "Network error occurred. Please check your internet connection and try again."});
}

// class TimeoutNetworkException extends NetworkException {
//   TimeoutNetworkException({super.message = "Connection timeout. Please check your internet connection and try again."});
//
// }