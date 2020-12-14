import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:loyal/models/signup_response.dart';
import 'package:loyal/network/api.dart';
import 'package:http/http.dart' as http;

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {

  final AppAPI api;

  SignupBloc(this.api);

  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if(event is AttemptSignup){
      yield SignupLoading();

      if(event.email.isEmpty || event.firstname.isEmpty || event.othernames.isEmpty  || event.password.isEmpty){
        yield SignupError("All fields are required");
        return;
      }
      else
        yield SignupLoading();

      SignupResponse rres = await api.signupUser(http.Client(), event.firstname, event.othernames, event.email, event.password, event.public_address);
      if (rres.message == "OK") {
        yield SignupSuccess(rres);
      }
      else{
        yield SignupError(rres.message);
      }

    }
  }

  @override
  // TODO: implement initialState
  SignupState get initialState => SignupInitial();
}
