part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();
}

class AttemptSignup extends SignupEvent{
  final String email, firstname, othernames, password;

  AttemptSignup(this.email, this.firstname, this.othernames, this.password);

  @override
  List<Object> get props => [];
}