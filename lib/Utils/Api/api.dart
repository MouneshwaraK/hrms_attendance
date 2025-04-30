import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class API {
  final Dio _dio = Dio();
  API() {
    ///****************** QA Base URL  *******************/
    _dio.options.baseUrl = "http://34.229.118.216:8000/";

    ///****************** Prod Base URL  *******************/
    // _dio.options.baseUrl = "http://34.235.114.150:8000/";

    _dio.interceptors.add(PrettyDioLogger());
  }
  Dio get sendRequest => _dio;
}
