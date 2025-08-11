import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_uni_kit/common/device_functions.dart';
import 'package:flutter_uni_kit/extensions/density_extension.dart';
import 'package:flutter_uni_kit/theme/theme_manager.dart';
import 'package:example/themes/app_colors.dart';
import 'package:example/routes.dart';
import 'package:example/test/loading_sample.dart';
import 'package:example/themes/dimens.dart';
import 'package:flutter_uni_kit/alerts/toast_alert.dart';
import 'package:flutter_uni_kit/widgets/app_check_box.dart';
import 'package:flutter_uni_kit/widgets/setting_item.dart';
import 'package:get/get.dart';

/// flutter组件交互功能测试页面
///
/// @author linxiao
/// @since 2023-11-01
class WidgetApiTestPage extends StatefulWidget {
  const WidgetApiTestPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WidgetApiTestPageState();
  }
}

class _WidgetApiTestPageState extends State<WidgetApiTestPage> with WidgetsBindingObserver {

  final testBadgeCount = 1.obs;
  final debugPaintSwitch = debugPaintSizeEnabled.obs;
  final statusBarLightMode = true.obs;
  final deviceId = "unknown".obs;
  final checkboxChecked = false.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getDeviceGUID().then((value) => deviceId.value = value);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      decoration: const BoxDecoration(
        color: Colors.white
      ),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text('''
page width = ${MediaQuery.of(context).size.width}
      page height = ${MediaQuery.of(context).size.height}
      screen width = ${ScreenUtil().screenWidth}
      screen height = ${ScreenUtil().screenHeight}
      screen width px = ${ScreenUtil().screenWidth.pxValue}
      screen height px = ${ScreenUtil().screenHeight.pxValue}
      status bar height = ${ScreenUtil().statusBarHeight}
      bottom navigation bar height = ${ScreenUtil().bottomBarHeight}
      screen ratio = ${ScreenUtil().pixelRatio}
      orientation = ${ScreenUtil().orientation}
          '''),
          Obx(() => Text(
              "DeviceGUID:\n${deviceId.value}"
          )),
          Obx(() => SettingItem(
            title: "Show debug size",
            style: SettingItemStyle.itemSwitch,
            iconData: Icons.screenshot_monitor_outlined,
            switchSelected: debugPaintSwitch.value,
            value: Text("${debugPaintSwitch.value}"),
            onPressed: () {
              debugPaintSizeEnabled = !debugPaintSizeEnabled;
              debugPaintSwitch.value = debugPaintSizeEnabled;
            },
          )),
          Obx(() => SettingItem(
            title: "Status bar light mode",
            style: SettingItemStyle.itemSwitch,
            iconData: Icons.screenshot_monitor_outlined,
            switchSelected: statusBarLightMode.value,
            onPressed: () {
              statusBarLightMode.value = !statusBarLightMode.value;
              ThemeManager.setStatusBarStyle(
                darkText: statusBarLightMode.value,
                statusBarColor: statusBarLightMode.value ? Colors.white : Colors.black
              );
            },
          )),
          SettingItem(
            title: "Network image",
            iconData: Icons.image,
            value: SettingItem.buildSettingIcon(
                iconUrl:
                    "https://www.baidu.com/img/flexible/logo/pc/result@2.png"),
          ),
          Obx(() => AppCheckBox(
            title: "AppCheckBox test",
            checked: checkboxChecked.value,
            onChanged: (checked) => checkboxChecked.value = checked,
          )),
          ElevatedButton(
              child: const Text("test navigation by route"),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRouteDefines.root);
              }),
          ElevatedButton(
              child: const Text("show alert with toast"),
              onPressed: () {
                final topOfNavigationStack =
                    ModalRoute.of(context)?.isCurrent ?? false;
                toastAlert("is top of navigation stack: $topOfNavigationStack");
              }),
          ElevatedButton(
              child: const Text("test loading page"),
              onPressed: () {
                Get.to(LoadingSamplePage());
              }),
          ElevatedButton(
              child: const Text("test loading dialog"),
              onPressed: () {
                EasyLoading.show(status: "test loading");
                Future.delayed(const Duration(seconds: 3), () {
                  EasyLoading.dismiss();
                });
              }),
          Badge(
            isLabelVisible: true,
            alignment: Alignment.topRight,
            backgroundColor: AppColors.main.get(),
            smallSize: 12,
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            largeSize: 22,
            textStyle: const TextStyle(
                fontSize: GlobalDimens.fontS, fontWeight: FontWeight.bold),
            textColor: Colors.white,
            label: Obx(() {
              var content = testBadgeCount.value <= 10
                  ? testBadgeCount.value.toString()
                  : "99+";
              return Text(content);
            }),
            offset: const Offset(-8, 0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text("test badge"),
                onPressed: () {
                  testBadgeCount.value++;
                },
              ),
            ),
          ),

        ],
      ),
    );
  }
}
