import 'package:flutter/material.dart';

class ThemeIdentifier extends ThemeExtension<ThemeIdentifier> {
  final String name;

  const ThemeIdentifier(this.name);

  @override
  ThemeExtension<ThemeIdentifier> copyWith() => this;

  @override
  ThemeExtension<ThemeIdentifier> lerp(covariant ThemeExtension<ThemeIdentifier>? other, double t) => this;
}

extension ThemeIdentifierExtension on ThemeData {

  String? getIdentifier() {
    return extension<ThemeIdentifier>()?.name;
  }

}