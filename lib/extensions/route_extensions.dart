
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// 关闭当前页面
/// 如果当前页面为页面栈内唯一页面则退出app
Future<void> closePage() async {
  if (await navigator?.maybePop() != true) {
    SystemNavigator.pop(animated: true);
  }
}

/// 退出应用
void exitApp() async {
  while (await navigator?.maybePop() == true) {
    navigator?.pop();
  }
  SystemNavigator.pop(animated: true);
  exit(0); // adapt for iOS exit
}