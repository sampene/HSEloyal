import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loyal/blocs/exceptions/base_exception.dart';
import 'package:loyal/blocs/exceptions/server_exception.dart';
import 'package:loyal/blocs/login/login_bloc.dart';
import 'package:loyal/models/login_response.dart';
import 'package:loyal/models/signup_response.dart';
import 'package:loyal/models/userinfo_response.dart';
import 'package:loyal/network/api_exception_model.dart';

abstract class API {
  Future<LoginResponse> loginUser(
      http.Client client, String email, String password);

  Future<SignupResponse> signupUser(http.Client client, String lastname,
      String othernames, String email, String password, String eth_address);

  Future<UserInfoResponse> getUser(http.Client client, String userID);
}

class AppAPI implements API {
  static String baseUrl = "https://loyalhse.herokuapp.com/api/v1";

  LoginResponse parseLoginResponse(String responseBody) {
    final parsed = jsonDecode(responseBody);
    LoginResponse rr = LoginResponse.fromJson(parsed);
    return rr;
  }

  ErrorResponse parseErrorResponse(String responseBody) {
    final parsed = jsonDecode(responseBody);
    ErrorResponse rr = ErrorResponse.fromJson(parsed);
    return rr;
  }

  SignupResponse parseSignupResponse(String responseBody) {
    final parsed = jsonDecode(responseBody);
    SignupResponse rr = SignupResponse.fromJson(parsed);
    return rr;
  }

  UserInfoResponse parseUserResponse(String responsebody) {
    final parsed = jsonDecode(responsebody);
    UserInfoResponse rr = UserInfoResponse.fromJson(parsed);
    return rr;
  }

  @override
  Future<LoginResponse> loginUser(http.Client client, email, password) async {
    Map data = {
      'email': email,
      'password': password,
      'eth_address': "0x42Ab9c9E8BDBB7bACA96C8ea6aa252e72D8004D2",
    };

    final response = await http.post(baseUrl + "/tokens",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'accept': 'application/json'
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      return parseLoginResponse(response.body);
    } else if (response.statusCode == 401) {
      return parseLoginResponse(response.body);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<SignupResponse> signupUser(
      http.Client client,
      String firstname,
      String othernames,
      String email,
      String password,
      String eth_address) async {
    Map data = {
      'first_name': othernames,
      'last_name': firstname,
      'email': email,
      'password': password,
      'eth_address': eth_address,
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
    } else if (response.statusCode == 401) {
      return parseSignupResponse(response.body);
      // String message = ApiExceptionUtil.getErrorMessage(response.body);
      // throw BaseException(message);
    } else if (response.statusCode == 409) {
      // String message = ApiExceptionUtil.getErrorMessage(response.body);
      return parseSignupResponse(response.body);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserInfoResponse> getUser(http.Client client, String userID) async {
    final response = await http.get(baseUrl + "/users/" + userID,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'accept': 'application/json'
        });

    if (response.statusCode == 200) {
      return parseUserResponse(response.body);
    }
    else{
    return parseUserResponse(response.body);
    }
  }
}
