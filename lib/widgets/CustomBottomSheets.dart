import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBottomSheetColor {
  Color main;
  Color accent;
  Color icon;

  CustomBottomSheetColor(
      {@required this.main, @required this.accent, this.icon});
}

class CustomSweetSheetColor {
  static CustomBottomSheetColor DANGER = CustomBottomSheetColor(
    main: Color(0xffEF5350),
    accent: Color(0xffD32F2F),
    icon: Colors.white,
  );
  static CustomBottomSheetColor SUCCESS = CustomBottomSheetColor(
    main: Color(0xff009688),
    accent: Color(0xff00695C),
    icon: Colors.white,
  );
  static CustomBottomSheetColor WARNING = CustomBottomSheetColor(
    main: Color(0xffFF8C00),
    accent: Color(0xffF55932),
    icon: Colors.white,
  );
  static CustomBottomSheetColor NICE = CustomBottomSheetColor(
    main: Color(0xff2979FF),
    accent: Color(0xff0D47A1),
    icon: Colors.white,
  );
}

class CustomSweetSheet {
  show({
    @required BuildContext context,
    Text title,
    @required Widget description,
    @required CustomBottomSheetColor color,
    @required CustomSweetSheetAction positive,
    CustomSweetSheetAction negative,
    IconData icon,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: double.infinity,
              color: color.main,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  title == null
                      ? Container()
                      : DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                          child: title),
                  _buildContent(color, description, icon)
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              color: color.accent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _buildActions(positive, negative),
              ),
            )
          ],
        );
      },
    );
  }

  _buildContent(
      CustomBottomSheetColor color, Widget description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: SingleChildScrollView(
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: DefaultTextStyle(
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: 'circular'),
                        child: description),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Icon(
                    icon,
                    size: 52,
                    color: color.icon ?? Colors.white,
                  )
                ],
              )
            : DefaultTextStyle(
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                child: description,
              ),
      ),
    );
  }

  _buildActions(
      CustomSweetSheetAction positive, CustomSweetSheetAction negative) {
    List<CustomSweetSheetAction> actions = [];

    // This order is important
    // It helps to place the positive at the right and the negative before
    if (negative != null) {
      actions.add(negative);
    }

    if (positive != null) {
      actions.add(positive);
    }

    return actions;
  }
}

class CustomSweetSheetAction extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final IconData icon;
  final Color color;

  CustomSweetSheetAction({
    @required this.title,
    @required this.onPressed,
    this.icon,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return icon == null
        ? FlatButton(
            onPressed: onPressed,
            child: Text(
              title,
              style: TextStyle(
                color: color,
              ),
            ),
          )
        : FlatButton.icon(
            onPressed: onPressed,
            label: Text(
              title,
            ),
            icon: Icon(
              icon,
              color: color,
            ),
          );
  }
}
