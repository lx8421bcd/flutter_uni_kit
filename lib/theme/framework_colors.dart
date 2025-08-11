import 'package:flutter/material.dart';

class FrameworkColors {
  FrameworkColors._internal();

  static FrameworkColors instance = FrameworkColors._internal();

  factory FrameworkColors() => instance;

  Color? Function(BuildContext context) foreground = (context) {
    return Theme.of(context).cardColor;
  };

  Color? Function(BuildContext context) background = (context) {
    return Theme.of(context).scaffoldBackgroundColor;
  };

}