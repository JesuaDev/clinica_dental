import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:3000',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _configureInterceptor();
  }

  void _configureInterceptor() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final FlutterSecureStorage storage = FlutterSecureStorage();
          final token = await storage.read(key: 'token');

          if (token != null) {
            options.headers['Authorization'] = "Bearer $token";
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },

        onError: (error, handler) {
          debugPrint('========== DIO ERROR ==========');
          debugPrint('TYPE: ${error.type}');
          debugPrint('MESSAGE: ${error.message}');
          debugPrint('ERROR: ${error.error}');
          debugPrint('STATUS: ${error.response?.statusCode}');
          debugPrint('DATA: ${error.response?.data}');

          debugPrint('================================');

          if (error.response?.statusCode == 401) {
            final FlutterSecureStorage storage = FlutterSecureStorage();

            storage.delete(key: 'token');
            storage.delete(key: 'user');
          }
          handler.next(error);
        },
      ),
    );
  }
}
