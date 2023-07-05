import 'package:accomod8/services/cookie/cookie_manager.dart';
import 'package:dio/dio.dart';

class DioInstance {
  late Dio _dio;

  DioInstance() {
    _dio = Dio();
    _dio.interceptors.add(CookieManager.instance);
  }

  Dio get dio => _dio;
}
