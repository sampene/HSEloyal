import 'package:flutter/material.dart';
import 'package:loyal/resources/my_colors.dart';
import 'package:loyal/resources/my_dimens.dart';

class DialogProgress extends StatelessWidget {

  final String message;

  DialogProgress(this.message);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((MyDimens.dialogCornerRadius))),
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(MyColors.primaryColor),
          ),
          SizedBox(width: MyDimens.standardMargin),
          Text(message)
        ],
      ),
    );
  }
}
