part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  List<Object> get props => [];
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState{}

class LoginError extends LoginState{
  final String message;

  LoginError(this.message);
  @override
  List<Object> get props => [message];
}

class LoginSuccess extends LoginState{
    final LoginResponse loginResponse;

  LoginSuccess(this.loginResponse);
}

