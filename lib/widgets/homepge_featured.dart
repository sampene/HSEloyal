import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loyal/models/restaurant_data.dart';
import 'package:loyal/resources/my_colors.dart';

class FeaturedCafes extends StatelessWidget {
  final Restaurant_Data restaurant_data;

  FeaturedCafes(this.restaurant_data);

  @override
  Widget build(BuildContext context) {
    int randomNumber = 8;//Random().nextInt(8) + 1;
    print(randomNumber);
    var width = MediaQuery.of(context).size.width - 30;
    var height = MediaQuery.of(context).size.height / 3.5;
    Restaurants rr = restaurant_data.restaurants[randomNumber];
    print(rr.name);
    return Column(
      children: [
        Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: MyColors.backgroundColor.withOpacity(1),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
                image: DecorationImage(
                  image: NetworkImage(rr.photograph),
                  fit: BoxFit.cover,
                ))),
        Container(
          width: width,
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Text(rr.name, style: TextStyle(fontFamily: "fatface", fontSize: 23),),
                SizedBox(height: 20,),
                Text(rr.neighborhood, style: Theme.of(context).textTheme.headline5,),
                Text(rr.cuisineType),
                Text(rr.address),
              ],
            ),
          ),
        )
      ],
    );
  }
}
