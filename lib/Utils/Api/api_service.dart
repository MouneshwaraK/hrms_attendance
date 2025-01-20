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
      // Send the FormData directly
      Response response = await api.sendRequest.post(
        url,
        data: reqObj, // Use the original FormData
        options: Options(headers: {
          "Accept": "application/json",
          "Content-Type": "multipart/form-data", // Explicitly set Content-Type
        }),
      );
      return response;
    } on SocketException catch (_) {
      return Response(
        requestOptions: RequestOptions(path: url),
        statusCode: 503,
        statusMessage: "No internet connection. Please check your network.",
      );
    } on DioException catch (dioError) {
      if (dioError.type == DioExceptionType.connectionError) {
        return Response(
          requestOptions: dioError.requestOptions,
          statusCode: 503,
          statusMessage: "No internet connection. Please check your network.",
        );
      } else if (dioError.type == DioExceptionType.receiveTimeout) {
        return Response(
          requestOptions: dioError.requestOptions,
          statusCode: 408,
          statusMessage: "Request timeout. Please try again.",
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

  // POST Method for Login Validation
  Future<Response<dynamic>> validateUser({
    required String url,
    required FormData reqObj,
  }) async {
    try {
      // Send the FormData directly
      Response response = await api.sendRequest.post(
        url,
        data: reqObj, // Use the original FormData
        options: Options(headers: {
          "Accept": "application/json",
          "Content-Type": "	multipart/form-data",
        }),
      );
      return response;
    } on SocketException catch (_) {
      return Response(
        requestOptions: RequestOptions(path: url),
        statusCode: 503,
        statusMessage: "No internet connection. Please check your network.",
      );
    } on DioException catch (dioError) {
      if (dioError.type == DioExceptionType.connectionError) {
        return Response(
          requestOptions: dioError.requestOptions,
          statusCode: 503,
          statusMessage: "No internet connection. Please check your network.",
        );
      } else if (dioError.type == DioExceptionType.receiveTimeout) {
        return Response(
          requestOptions: dioError.requestOptions,
          statusCode: 408,
          statusMessage: "Request timeout. Please try again.",
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
