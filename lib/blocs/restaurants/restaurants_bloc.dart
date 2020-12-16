import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:loyal/models/restaurant_data.dart';
import 'package:loyal/network/api.dart';
import 'package:http/http.dart' as http;

part 'restaurants_event.dart';

part 'restaurants_state.dart';

class RestaurantsBloc extends Bloc<RestaurantsEvent, RestaurantsState> {
  final AppAPI api;

  RestaurantsBloc(this.api);

  @override
  Stream<RestaurantsState> mapEventToState(
    RestaurantsEvent event,
  ) async* {
    if (event is FetchRestaurants) {
      yield RestaurantsLoading();

      Restaurant_Data rstResponse = await api.getRestaurants(http.Client());
      yield RestaurantsLoaded(rstResponse);
    }
  }

  @override
  // TODO: implement initialState
  RestaurantsState get initialState => RestaurantsInitial();
}
