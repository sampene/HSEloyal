part of 'restaurants_bloc.dart';

abstract class RestaurantsState extends Equatable {
  List<Object> get props => [];
}

class RestaurantsInitial extends RestaurantsState {}
class RestaurantsLoading extends RestaurantsState{}
class RestaurantsLoaded extends RestaurantsState{
  final Restaurant_Data restaurant_data;

  RestaurantsLoaded(this.restaurant_data);
}
class RestaurantsError extends RestaurantsState{}

