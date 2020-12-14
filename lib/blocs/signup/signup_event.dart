part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();
}

class AttemptSignup extends SignupEvent{
  final String email, firstname, othernames, password, public_address;

  AttemptSignup(this.email, this.firstname, this.othernames, this.password, this.public_address);

  @override
  List<Object> get props => [];
}