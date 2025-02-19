import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:interns_talk_mobile/utils/string.dart';

@injectable
class DioClient {
  final Dio dio;
  final FlutterSecureStorage storage;

  DioClient(this.dio, this.storage) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    dio.interceptors.addAll([
      _AuthInterceptor(storage),
      ThrottleInterceptor(),
    ]);
  }
}

class _AuthInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  _AuthInterceptor(this.storage);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? token = await storage.read(key: kAuthTokenKey);
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
