import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:clinica_prodental/core/network/dio/dio_client.dart';

final dioProvider = Provider<Dio>((ref) {
  return DioClient().dio;
});
