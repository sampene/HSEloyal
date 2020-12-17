import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loyal/blocs/restaurants/restaurants_bloc.dart';
import 'package:loyal/widgets/restaurantItem.dart';

class RestaurantListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white70,
        child: BlocListener<RestaurantsBloc, RestaurantsState>(
          listener: (context, state) {
            if (state is RestaurantsError) {
              return buildErrorUI(context);
            }
          },
          child: BlocBuilder<RestaurantsBloc, RestaurantsState>(
              builder: (context, state) {
            if (state is RestaurantsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is RestaurantsLoaded) {
              print(state.restaurant_data.restaurants[2].photograph);

              return Stack(
                children: <Widget>[
                  ListView(
                    padding: EdgeInsets.only(bottom: 20),
                    children: List<Widget>.generate(
                      state.restaurant_data.restaurants.length,
                      (position) => Container(
//                    color: Colors.white,
                        child: RestaurantsItem(
                          title: state.restaurant_data.restaurants[position].name,
                          description: state.restaurant_data.restaurants[position].neighborhood,
                          image: state.restaurant_data.restaurants[position].photograph,
                          address: state.restaurant_data.restaurants[position].address,
                          cu_type: state.restaurant_data.restaurants[position].cuisineType,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: Container());
            }
          }),
        ),
      ),
    );
  }

  simulatePress(BuildContext context) {}

  Widget buildErrorUI(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text("Error Occured. Click to Retry "),
        onPressed: () {
          final bloc = BlocProvider.of<RestaurantsBloc>(context);
          bloc.add(FetchRestaurants());
        },
        elevation: 3,
      ),
    );
  }

  Widget buildInitialUI(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text("Click to load Restaurants"),
        onPressed: () {
          final bloc = BlocProvider.of<RestaurantsBloc>(context);
          bloc.add(FetchRestaurants());
        },
        elevation: 3,
      ),
    );
  }
}
