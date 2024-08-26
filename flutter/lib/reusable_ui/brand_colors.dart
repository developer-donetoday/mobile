import 'package:flutter/material.dart';

class BrandColors {
  static final BrandColors _instance = BrandColors._internal();

  factory BrandColors() {
    return _instance;
  }

  BrandColors._internal();

  Color primary = Colors.greenAccent.shade400;
  Color secondary = Colors.blueAccent.shade400;
}
