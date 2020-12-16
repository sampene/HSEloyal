import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loyal/resources/my_colors.dart';

class RestaurantsItem extends StatelessWidget {
  String title, description, image;

  RestaurantsItem({this.title, this.image, this.description});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 30;
    // TODO: implement build
    return ListTile(
      isThreeLine: true,
        title: Text(title),
        subtitle: Text(description),

        leading: Container(
            width: 150,
            decoration: BoxDecoration(
                image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ))));
  }
}
