import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hrvms_attendence/Utils/Api/api.dart';

class ApiService {
  API api = API();

  // POST Method
  Future<Response<dynamic>> postResponseBody({
    required String url,
    required FormData reqObj,
  }) async {
    try {
      //FormData formData = FormData.fromMap(reqObj);

      Response response = await api.sendRequest.post(
        url,
        data: reqObj, // Send as FormData
        options: Options(headers: {
          "Accept": "application/json",
        }),
      );
      return response;
    } on SocketException catch (_) {
      return Response(
          requestOptions: RequestOptions(),
          statusCode: 503,
          statusMessage: "No internet connection. Please check your network.");
    } on DioError catch (dioError) {
      if (dioError.type == DioErrorType.connectionError) {
        return Response(
          requestOptions: dioError.requestOptions,
          statusCode: 503,
          statusMessage: "No internet connection. Please check your network.",
        );
      } else if (dioError.response?.statusCode == 401) {
        return Response(
          requestOptions: dioError.requestOptions,
          statusCode: 401,
          statusMessage: "Session expired. Please log in again.",
        );
      } else {
        return Response(
          requestOptions: dioError.requestOptions,
          statusCode: dioError.response?.statusCode ?? 500,
          statusMessage: "An unexpected error occurred: ${dioError.message}",
        );
      }
    } catch (e) {
      return Response(
        requestOptions: RequestOptions(path: url),
        statusCode: 500,
        statusMessage: "An unexpected error occurred. Please try again later.",
      );
    }
  }
}
