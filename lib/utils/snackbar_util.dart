import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class SnackbarUtil {
  static void showSimpleSnackbar(BuildContext context, String message, {
        Duration duration,
//        Icon icon,
      }){

    ThemeData themeData = Theme.of(context);

    Flushbar(
      message: message,
      margin: EdgeInsets.all(8),
      borderRadius: 8,
//      icon: icon ?? Icon(
//        Icons.info_outline,
//        size: 28.0,
//        color: themeData.primaryColor,
//      ),
      duration: duration ?? Duration(seconds: 3),
    )..show(context);
  }
}