import 'package:dio/dio.dart';

class Handler{
 static String handleDioError(DioException e) {
    if (e.response != null) {
      final message = e.response?.data?['message'] ?? "Something went wrong!";
      return message;
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timed out. Please check your internet.";
      case DioExceptionType.sendTimeout:
        return "Request took too long to send. Try again.";
      case DioExceptionType.receiveTimeout:
        return "Server is taking too long to respond. Try again later.";
      case DioExceptionType.badCertificate:
        return "Security issue detected. Unable to proceed.";
      case DioExceptionType.badResponse:
        return "Server error: ${e.response?.statusCode} ${e.response?.statusMessage}";
      case DioExceptionType.cancel:
        return "Request was cancelled.";
      case DioExceptionType.connectionError:
        return "No internet connection. Please check your network.";
      case DioExceptionType.unknown:
        return "An unexpected error occurred. Please try again.";
    }
  }
}