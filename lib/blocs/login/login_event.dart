part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable{
  const LoginEvent();
}

class AttemptLogin extends LoginEvent{
  String email, password, publicKey;
  AttemptLogin( this.email, this.password, this.publicKey);

  @override
  List<Object> get props => [];
}
