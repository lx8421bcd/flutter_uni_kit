import 'package:example/themes/app_colors.dart';
import 'package:example/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_uni_kit/alerts/dialog_alert.dart';
import 'package:flutter_uni_kit/theme/theme_identifier.dart';
import 'package:flutter_uni_kit/theme/theme_manager.dart';
import 'package:flutter_uni_kit/widgets/setting_item.dart';
import 'package:get/get.dart';


/// flutter组件交互功能测试页面
///
/// @author linxiao
/// @since 2023-11-01
class ThemeTestPage extends StatefulWidget {

  const ThemeTestPage({super.key});

  @override
  State<ThemeTestPage> createState() => _ThemeTestPageState();
}

class _ThemeTestPageState extends State<ThemeTestPage> {


  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Container(
          width: ScreenUtil().screenWidth,
          height: 60,
          color: AppColors.sample.get(),
          child: const Center(
            child: Text("Theme Color Test"),
          ),
        ),
        SettingItem(
          title: "System theme mode",
          iconData: Icons.settings_applications,
          value: SettingItem.buildValueText(
              context,
              ThemeManager.isSystemDarkMode ? "Dark" : "Light"
          ),
        ),
        SettingItem(
          title: "App theme mode",
          iconData: Icons.light_mode,
          value: SettingItem.buildValueText(
            context,
            Get.isDarkMode ? "Dark" : "Light"
          ),
          onPressed: () {
            DialogAlert()
            ..setAction(
              actionText: "follow system",
              action: () {
                ThemeManager.themeMode = ThemeMode.system;
                Navigator.of(context).pop();
              })
            ..setAction(
              actionText: "light",
              action: () {
                ThemeManager.themeMode = ThemeMode.light;
                Navigator.of(context).pop();
              })
            ..setAction(
              actionText: "dark",
              action: () {
                ThemeManager.themeMode = ThemeMode.dark;
                Navigator.of(context).pop();
              })
            ..showBottom(context);
          },
        ),
        SettingItem(
          title: "Custom Theme",
          iconData: Icons.pattern,
          value: SettingItem.buildValueText(
              context,
              Get.theme.getIdentifier() ?? 'none'
          ),
          onPressed: () {
            DialogAlert()
            ..setAction(
              actionText: "default",
              action: () {
                Get.changeTheme(Get.isDarkMode ? appThemeDark : appThemeLight);
                Navigator.of(context).pop();
              })
            ..setAction(
              actionText: "themeA",
              action: () {
                Get.changeTheme(themeA);
                Navigator.of(context).pop();
              })
            ..setAction(
              actionText: "themeB",
              action: () {
                Get.changeTheme(themeB);
                Navigator.of(context).pop();
              })
            ..showBottom(context);
          },
        ),
      ],
    );
  }
}
