import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uni_kit/app_settings.dart';
import 'package:get/get.dart';

const String _themeModeKey = "themeMode";

class ThemeManager {
  ThemeManager._();

  static ThemeMode get themeMode {
    int index = AppSettings.get(_themeModeKey) ?? ThemeMode.system.index;
    return ThemeMode.values[index];
  }

  static set themeMode(ThemeMode mode) {
    AppSettings.set(_themeModeKey, mode.index);
    Get.changeThemeMode(mode);
  }


  /// 检查系统是否为暗色模式
  static bool get isSystemDarkMode {
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return isDarkMode;
  }

  static Color themeColor(Color light, Color dark) {
    return Get.isDarkMode ? dark : light;
  }

  /// 设置状态栏样式
  /// 对一个Flutter Engine内的所有页面生效
  /// 注意，使用此方法后，设置的style将会覆盖主题切换时系统默认的状态栏配置。
  /// 如果应用内有主题切换需求需与此方法组合调用
  /// [darkText] 是否为深色字体
  /// [statusBarColor] 状态栏背景颜色（仅对Android系统生效）
  static void setStatusBarStyle({
    required bool darkText,
    Color? statusBarColor,
  }) {
    SystemUiOverlayStyle style = darkText ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light;
    if (statusBarColor != null) {
      style.copyWith(statusBarColor: statusBarColor);
    }
    SystemChrome.setSystemUIOverlayStyle(style);
  }

}