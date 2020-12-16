import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:loyal/blocs/exceptions/base_exception.dart';
import 'package:loyal/blocs/exceptions/server_exception.dart';
import 'package:loyal/blocs/login/login_bloc.dart';
import 'package:loyal/models/login_response.dart';
import 'package:loyal/models/restaurant_data.dart';
import 'package:loyal/models/signup_response.dart';
import 'package:loyal/models/userinfo_response.dart';
import 'package:loyal/network/api_exception_model.dart';

abstract class API {
  Future<LoginResponse> loginUser(
      http.Client client, String email, String password, String privateKey);

  Future<SignupResponse> signupUser(http.Client client, String lastname,
      String othernames, String email, String password, String eth_address);

  Future<UserInfoResponse> getUser(http.Client client, String userID);
  Future<Restaurant_Data> getRestaurants(http.Client client);
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
  Restaurant_Data parseRestaurants(String responseBody) {
    final parsed = jsonDecode(responseBody);
    Restaurant_Data rr = Restaurant_Data.fromJson(parsed);
    return rr;
  }


  Future<String> loadlocalRestaurants() async {
    String json = await rootBundle.loadString('assets/restaurants.json');
    return json;
  }

  @override
  Future<LoginResponse> loginUser(http.Client client, email, password, publicKey) async {


    Map data = {
      'email': email,
      'password': password,
      'eth_address': publicKey,
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

  @override
  Future<Restaurant_Data> getRestaurants(http.Client client) async {

    String body = await loadlocalRestaurants();
    return parseRestaurants(body);


  }
}
