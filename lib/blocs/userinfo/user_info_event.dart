part of 'user_info_bloc.dart';

abstract class UserInfoEvent extends Equatable {
  const UserInfoEvent();
}

class fetchUserInfo extends UserInfoEvent{
  final String userID;

  fetchUserInfo(this.userID);

  @override
  List<Object> get props => [];

}
