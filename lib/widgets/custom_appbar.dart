import 'package:flutter/material.dart';
Widget ourCustomAppbar() {
  return PreferredSize(
    preferredSize: Size(double.infinity, 200),
    child: SafeArea(child: Image.asset("assets/cafehatte.png")),
  );
}


