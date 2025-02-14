import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:interns_talk_mobile/data/datasources/api_constants.dart';
import 'package:interns_talk_mobile/utils/string.dart';

class DioClient {
  final Dio dio;

  DioClient()
      : dio = Dio(BaseOptions(
          baseUrl: kBaseUrl,
          connectTimeout: Duration(seconds: 60),
          receiveTimeout: Duration(seconds: 60),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        )) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    dio.interceptors.addAll([
      _AuthInterceptor(),
      ThrottleInterceptor(),
    ]);
  }
}

class _AuthInterceptor extends Interceptor {
  final _storage = FlutterSecureStorage();

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? token = await _storage.read(key: kAuthTokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }
}

class ThrottleInterceptor extends Interceptor {
  static const int requestInterval = 1000;
  DateTime? _lastRequestTime;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final now = DateTime.now();

    if (_lastRequestTime != null) {
      final timeSinceLastRequest =
          now.difference(_lastRequestTime!).inMilliseconds;

      if (timeSinceLastRequest < requestInterval) {
        final delay = requestInterval - timeSinceLastRequest;
        await Future.delayed(Duration(milliseconds: delay));
      }
    }

    _lastRequestTime = DateTime.now();
    return handler.next(options);
  }
}
