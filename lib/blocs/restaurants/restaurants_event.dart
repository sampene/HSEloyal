part of 'restaurants_bloc.dart';

abstract class RestaurantsEvent extends Equatable {
  const RestaurantsEvent();
}

class FetchRestaurants extends RestaurantsEvent{

  @override
  List<Object> get props => [];
}
