part of 'user_info_bloc.dart';

abstract class UserInfoState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserInfoInitial extends UserInfoState {}

class UserInfoLoading extends UserInfoState{}

class USerInfoError extends UserInfoState{
  final String message;

  USerInfoError(this.message);
  List<Object> get props => [message];
}

class UserInfoSuccess extends UserInfoState{
  final UserInfoResponse userInfoResponse;

  UserInfoSuccess(this.userInfoResponse);
}
