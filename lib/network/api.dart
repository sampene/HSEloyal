import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loyal/blocs/exceptions/base_exception.dart';
import 'package:loyal/blocs/exceptions/server_exception.dart';
import 'package:loyal/blocs/login/login_bloc.dart';
import 'package:loyal/models/login_response.dart';
import 'package:loyal/models/signup_response.dart';

import 'api_exception_util.dart';

abstract class API {
  Future<LoginResponse> loginUser(http.Client client, String email, String password);
  Future<SignupResponse> signupUser(http.Client client, String lastname, String othernames, String email, String password);

}

class AppAPI implements API {
  static String baseUrl = "https://loyalhse.herokuapp.com/api/v1";

  LoginResponse parseLoginResponse(String responseBody) {
    final parsed = jsonDecode(responseBody);
    LoginResponse rr = LoginResponse.fromJson(parsed);
    return rr;
  }
  SignupResponse parseSignupResponse(String responseBody) {
    final parsed = jsonDecode(responseBody);
    SignupResponse rr = SignupResponse.fromJson(parsed);
    return rr;
  }

  @override
  Future<LoginResponse> loginUser(
      http.Client client, email, password) async {
    Map data = {
      'email': email,
      'password': password,
    };

    final response = await http.post(baseUrl + "/tokens",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'accept': 'application/json'
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      print(response);
      return parseLoginResponse(response.body);
    }
    else if(response.statusCode == 404){
      String message = ApiExceptionUtil.getErrorMessage(response.body);
      throw BaseException(message);
    }

    else if (response.statusCode == 400) {
      String message = ApiExceptionUtil.getErrorMessage(response.body);
      throw BaseException(message);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<SignupResponse> signupUser(http.Client client, String firstname,
      String othernames, String email, String password) async {
    Map data = {
      'first_name': othernames,
      'last_name': firstname,
      'email': email,
      'password': password,
    };

    final response = await http.post(baseUrl + "/users",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'accept': 'application/json'
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      print(response);
      return parseSignupResponse(response.body);
    }
    else if(response.statusCode == 404){
      String message = ApiExceptionUtil.getErrorMessage(response.body);
      throw BaseException(message);
    }

    else if (response.statusCode == 400) {
      String message = ApiExceptionUtil.getErrorMessage(response.body);
      throw BaseException(message);
    } else {
      throw ServerException();
    }
  }

  }


