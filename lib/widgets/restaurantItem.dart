import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loyal/resources/my_colors.dart';

class RestaurantsItem extends StatelessWidget {
  String title, description, image, address, cu_type;

  RestaurantsItem({this.title, this.image, this.description, this.address, this.cu_type});
  
  
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 30;
      final thumbnail = Container(
                  width: 150,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              )));

      final orderCard = Container(
        margin: const EdgeInsets.only(left: 5.0, right: 5.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey, blurRadius: 5.0, offset: Offset(0.0, 2.0))
          ],
        ),
        child: Container(
          width: width,
          margin: const EdgeInsets.only(top: 10.0, left: 10.0),
          constraints: BoxConstraints.expand(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title,
                  style: Theme.of(context).textTheme.headline3,),
              SizedBox(
                height: 5,
              ),
              Text(address,
                  style: Theme.of(context).textTheme.body1),
              Container(
                  color: Colors.deepOrange,
                  width: 24.0,
                  height: 1.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0)),
              // Row(
              //   children: <Widget>[
              //     Icon(Icons.location_on, size: 14.0, color: Colors.black),
              //     Text(order.user.address.street,
              //         style: Theme.of(context).textTheme.caption),
              //     Container(width: 24.0),
              //   ],
              // ),
              Container(
                  color: Colors.deepOrange,
                  width: 24.0,
                  height: 1.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0)),
              // Row(
              //   children: <Widget>[
              //     Icon(Icons.access_time, size: 14.0, color: Colors.black),
              //     Container(width: 5),
              //     Text(
              //       timeago.format(order.createdAt.toDate()).toString(),
              //       style: Theme.of(context).textTheme.caption,
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      );

      return Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey, blurRadius: 5.0, offset: Offset(0.0, 2.0))
            ],
          ),
        height: 120.0,
        width: width,
        margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(flex: 1, child: thumbnail),
            SizedBox(width: 20,),
            Expanded(flex: 2, child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headline6,),
                Text(description, style: TextStyle(fontSize: 16)),
                Text(address),
                Text(cu_type),
              ],
            ))
            // orderCard,
          ],
        ),
      );

    }

  }


  // @override
  // Widget build(BuildContext context) {
  //   var width = MediaQuery.of(context).size.width - 30;
  //   // TODO: implement build
  //   return ListTile(
  //     isThreeLine: true,
  //       title: Text(title),
  //       subtitle: Text(description),
  //       leading:
//       Container(
  //           width: 150,
  //           decoration: BoxDecoration(
  //               image: DecorationImage(
  //         image: NetworkImage(image),
  //         fit: BoxFit.cover,
  //       ))));
  // }

