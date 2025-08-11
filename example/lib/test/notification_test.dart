import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_uni_kit/notification/notifications.dart';
import 'package:flutter_uni_kit/widgets/gradient_button.dart';
import 'package:example/routes.dart';
import 'package:flutter_uni_kit/alerts/toast_alert.dart';
import 'package:get/get.dart';

/// flutter组件交互功能测试页面
///
/// @author linxiao
/// @since 2023-11-01
class NotificationTestPage extends StatelessWidget {

  NotificationTestPage({super.key});

  final testNotifyId = LocalNotificationManager.generateNotificationId();

  @override
  Widget build(BuildContext context) {

    LocalNotificationManager.init(androidIconResName: "push_icon");
    LocalNotificationManager.registerResponseListener((response) {
      var routePath = response.payload;
      if (routePath != null) {
        Get.toNamed(routePath);
      }
    });
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        GradientButton(
          height: 40,
          child: const Text("Check has notification permission"),
          onPressed: () async {
            bool result = await LocalNotificationManager.hasPermission();
            toastAlert("has permission: $result");
          },
        ),
        12.verticalSpace,
        GradientButton(
          height: 40,
          child: const Text("Request permission"),
          onPressed: () async {
            await LocalNotificationManager.requestPermission();
          },
        ),
        12.verticalSpace,
        GradientButton(
          height: 40,
          child: const Text("Send simple notification"),
          onPressed: () async {
            await LocalNotificationManager.sendSimpleNotification(
              notificationId: testNotifyId,
              title: "Test notification",
              content: "Click to go to the test root page",
              payload: AppRouteDefines.root,
            );
            // toastAlert(NotificationManager.generateNotificationId().toString());
          },
        ),
        12.verticalSpace,
        GradientButton(
          height: 40,
          child: const Text("Cancel notification"),
          onPressed: () {
            LocalNotificationManager.cancelNotification(testNotifyId);
          },
        ),
      ],
    );
  }

}
