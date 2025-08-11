import 'package:flutter/material.dart';
import 'package:flutter_uni_kit/theme/theme_color.dart';

import 'app_themes.dart';


class AppColors {
  const AppColors._();

  static var sample = ThemeColor(
    light: Colors.blue,
    dark: Colors.green,
    customThemes: {
      themeA: Colors.orange,
      themeB: Colors.purple
    }
  );

  static var main = ThemeColor(
    light: const Color(0xFF159CFF),
    dark: const Color(0xFF49B2FF),
  );

  static var background = ThemeColor(
    light: const Color(0xFFEEF4FE),
    dark: Colors.black,
  );

  static var foreground = ThemeColor(
    light: Colors.white,
    dark: const Color(0xFF241E30),
  );

  static var divider = ThemeColor(
    light: const Color(0xFFD1DAE7),
    dark: const Color(0xFFD1DAE7),
  );

  static var title = ThemeColor(
    light: Colors.black,
    dark: Colors.white,
  );

  static var textDark = ThemeColor(
    light: const Color(0xFF333333),
    dark: const Color(0xFFD6D6D6),
  );

  static var textNormal = ThemeColor(
    light: const Color(0xFF666666),
    dark: const Color(0xFF999999),
  );

  static var textLight = ThemeColor(
    light: const Color(0xFF999999),
    dark: const Color(0xFF666666),
  );

  static var hint = ThemeColor(
    light: const Color(0xFFD6D6D6),
    dark: const Color(0xFF333333),
  );

  static var positive = ThemeColor(
    light: const Color(0xFF2AC769),
    dark: const Color(0xFF2AC769),
  );

  static var negative = ThemeColor(
    light: const Color(0xFFFB4E4E),
    dark: const Color(0xFFFB4E4E),
  );

  static var textButton = ThemeColor(
    light: main.light,
    dark: main.dark,
  );

  static var textButtonDisabled = ThemeColor(
    light: Colors.grey,
    dark: Colors.grey,
  );

  static var colorButtonBackground = ThemeColor(
    light: main.light,
    dark: main.dark,
  );

  static var colorButtonForeground = ThemeColor(
    light: Colors.white,
    dark: Colors.white,
  );

  static var colorButtonBackgroundDisabled = ThemeColor(
    light: Colors.black12,
    dark: Colors.black12,
  );

  static var colorButtonForegroundDisabled = ThemeColor(
    light: Colors.grey,
    dark: Colors.grey,
  );
}