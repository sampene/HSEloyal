import 'dart:convert';

import 'package:loyal/network/api_exception_model.dart';


class ApiExceptionUtil {
  static String getErrorMessage(String body) {
    var map = jsonDecode(body);
    ApiExceptionModel apiException = ApiExceptionModel.fromJson(map);
    return apiException.error;
  }
}