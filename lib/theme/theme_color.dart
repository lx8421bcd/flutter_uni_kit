import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'theme_identifier.dart';

class ThemeColor {

  final Color light;
  final Color? dark;

  final Map<ThemeData, Color>? customThemes;

  ThemeColor({
    required this.light,
    this.dark,
    this.customThemes,
  });

  Color get() {
    var currentThemeName = Get.theme.getIdentifier();
    if (customThemes != null && currentThemeName != null) {
      for (var item in customThemes!.entries) {
        var theme = item.key;
        var themeName = theme.getIdentifier();
        if (themeName == currentThemeName) {
          return item.value;
        }
      }
    }
    return Get.isDarkMode ? dark ?? light : light;
  }

}