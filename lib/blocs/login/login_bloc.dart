import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loyal/models/login_response.dart';
import 'package:loyal/network/api.dart';
import 'package:http/http.dart' as http;
import 'package:loyal/utils/utils.dart';

import '../../main.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AppAPI api;

  LoginBloc(this.api);

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is AttemptLogin) {
      if (event.email.isEmpty || event.password.isEmpty) {
        yield LoginError("Please fill out both username and password.");
        return;
      }
     else
      yield LoginLoading();

      LoginResponse lgResponse = await api.loginUser(http.Client(), event.email, event.password);
      if(lgResponse.message == "OK") {
        await sharedPreferences.setString(Keys.USER_ID, lgResponse.data.userId);
        yield LoginSuccess(lgResponse);
      }
      else{
        yield LoginError(lgResponse.message);
      }
    }
  }

  @override
  // TODO: implement initialState
  LoginState get initialState => LoginInitial();
}
