import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:loyal/models/userinfo_response.dart';
import 'package:loyal/network/api.dart';
import 'package:http/http.dart' as http;

part 'user_info_event.dart';
part 'user_info_state.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  final AppAPI api;

  UserInfoBloc(this.api);

  @override
  Stream<UserInfoState> mapEventToState(
    UserInfoEvent event,
  ) async* {
    if (event is fetchUserInfo){
      yield UserInfoLoading();

      UserInfoResponse userInfoResponse = await api.getUser(http.Client(), event.userID);
        if(userInfoResponse.message == "OK"){
          yield UserInfoSuccess(userInfoResponse);
        }
        else{
          yield USerInfoError(userInfoResponse.message);
        }
    }
  }

  @override
  // TODO: implement initialState
  UserInfoState get initialState => UserInfoInitial();
}
