import 'package:dio/dio.dart';
import 'package:hrvms_attendence/Utils/Api/api_const.dart';
import 'package:hrvms_attendence/Utils/Api/api_service.dart';

class RegisterRepo {
  Future<dynamic> registrationPost(FormData reqObj) async {
    Response response = await ApiService()
        .postResponseBody(url: ApiConst.registration, reqObj: reqObj);

    if (response.statusCode == 503) {
      throw Exception("No internet connection. Please check your network.");
    } else if (response.statusCode == 401) {
      throw Exception("Session expired. Please log in again.");
    } else if (response.statusCode != 200) {
      throw Exception("Failed to register. Error: ${response.statusMessage}");
    }

    return response; // Return response for further use
  }
}
