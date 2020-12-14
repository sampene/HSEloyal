import 'package:flutter/material.dart';

class CustomAppbarWithLogout extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onLogoutPressed;

  CustomAppbarWithLogout({this.onLogoutPressed});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(double.infinity, 200),
      child: SafeArea(
          child: Stack(
        children: [
          Image.asset("assets/cafehatte.png"),
          Positioned(
            right: 0, top: 0,
              child: IconButton(icon: Icon(Icons.logout), onPressed: onLogoutPressed)),
        ],
      )),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size(double.infinity, 200);
}
