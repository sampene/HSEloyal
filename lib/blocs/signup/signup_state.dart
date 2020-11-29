part of 'signup_bloc.dart';

abstract class SignupState extends Equatable {
  List<Object> get props => [];
}

class SignupInitial extends SignupState {
  @override
  List<Object> get props => [];
}


class SignupLoading extends SignupState{

}

class SignupError extends SignupState{
  final String message;

  SignupError(this.message);
  @override
  List<Object> get props => [message];
}

class SignupSuccess extends SignupState{
  final SignupResponse response;

  SignupSuccess(this.response);
}
