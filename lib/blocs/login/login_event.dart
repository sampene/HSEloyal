part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable{
  const LoginEvent();
}

class AttemptLogin extends LoginEvent{
  String email, password;
  AttemptLogin( this.email, this.password);

  @override
  List<Object> get props => [];
}
