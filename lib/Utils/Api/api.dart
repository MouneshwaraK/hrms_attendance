import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class API {
  final Dio _dio = Dio();
  API() {
    ///=========== Testing Base URL =================
    _dio.options.baseUrl = "http://98.81.165.36:8000/";

    _dio.interceptors.add(PrettyDioLogger());
  }
  Dio get sendRequest => _dio;
}
