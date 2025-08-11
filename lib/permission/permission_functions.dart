import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_uni_kit/alerts/dialog_alert.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

/// 权限完全禁止时的提示
class PermissionRestrictedHint {
  PermissionRestrictedHint._internal();

  static PermissionRestrictedHint instance = PermissionRestrictedHint._internal();

  factory PermissionRestrictedHint() => instance;

  static String Function() title = () {
    return "Attention";
  };

  static String Function() defaultHint = () {
    return "Attention";
  };

  static String Function() goSettings = () {
    return "Go Settings";
  };

  static String Function() cancel = () {
    return "Cancel";
  };

  void show(String? hintOnRestricted) {
    DialogAlert()
    ..setTitle(title())
    ..setMessage(hintOnRestricted ?? defaultHint())
    ..setAction(
        actionText: goSettings(),
        action: () {
          Get.back();
          openAppSettings();
        }
    )
    ..setAction(
        actionText: cancel(),
        action: () {
          Get.back();
        },
        negative: true
    )
    ..show();
  }
}

/// 检查权限申请，如果完全禁止则执行完全禁止的操作
Future<bool> requestPermission(Permission permission, {
  String? hintOnRestricted,
}) async {
  var permissionStatus = await permission.request();
  if (permissionStatus.isPermanentlyDenied) {
    PermissionRestrictedHint().show(hintOnRestricted);
    return false;
  }
  return permissionStatus.isGranted;
}

Future<bool> requestGalleryPermission() async {
  // Permission.photos权限在低于Android 13版本上无法使用
  if (Platform.isAndroid) {
    var androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    if (androidDeviceInfo.version.sdkInt > 32) {
      return await requestPermission(Permission.photos);
    }
  }
  return await requestPermission(Permission.storage);
}

Future<bool> requestCameraPermission() async {
  return await requestPermission(Permission.camera);
}