import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

// Future<String?> getRealDeviceIdentifier() async {
//   var deviceInfo = DeviceInfoPlugin();
//   if (Platform.isIOS) {
//     var info = await deviceInfo.iosInfo;
//     return info.identifierForVendor;
//   }
//   if (Platform.isAndroid) {
//     var info = await deviceInfo.androidInfo;
//     return info.id; // actually returned system version code, not identifier strings
//   }
//   if (Platform.isWindows) {
//     var info = await deviceInfo.windowsInfo;
//     return info.deviceId;
//   }
//   if (Platform.isMacOS) {
//     var info = await deviceInfo.macOsInfo;
//     return info.systemGUID;
//   }
//   if (Platform.isLinux) {
//     LinuxDeviceInfo info = await deviceInfo.linuxInfo;
//     return info.machineId;
//   }
//   if (kIsWeb) {
//     // The web doesn't have a device UID, so use a combination fingerprint as an example
//     WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
//     return "${webInfo.vendor}${webInfo.userAgent}${webInfo.hardwareConcurrency}";
//   }
//   return null;
// }

Future<String> getAppVersionName() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

Future<String> getAppBuildNumber() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.buildNumber;
}

Future<String> getDeviceGUID() async {
  var cacheBox = await Hive.openBox("DeviceIdStorage");
  String deviceId = cacheBox.get("deviceId") ?? "";
  if (deviceId.isEmpty) {
    // generate a random uuid as deviceId when the real deviceId cannot be obtained
    deviceId = const Uuid().v4();
    await cacheBox.put("deviceId", deviceId);
    await cacheBox.flush();
  }
  return deviceId;
}

Future<String> getDeviceBrand() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS || Platform.isMacOS) {
    return "apple";
  }
  if (Platform.isAndroid) {
    var info = await deviceInfo.androidInfo;
    return info.brand;
  }
  return "unknown";
}

Future<String> getDeviceModel() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    var info = await deviceInfo.iosInfo;
    return info.model;
  }
  if (Platform.isAndroid) {
    var info = await deviceInfo.androidInfo;
    return info.model;
  }
  if (Platform.isMacOS) {
    var info = await deviceInfo.macOsInfo;
    return info.model;
  }
  if (Platform.isWindows) {
    var info = await deviceInfo.windowsInfo;
    return info.productName;
  }
  if (Platform.isLinux) {
    LinuxDeviceInfo info = await deviceInfo.linuxInfo;
    return info.name;
  }
  return "unknown";
}


Future<String> getSystemVersionName() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    var info = await deviceInfo.iosInfo;
    return info.systemVersion;
  }
  if (Platform.isAndroid) {
    var info = await deviceInfo.androidInfo;
    return info.version.release;
  }
  if (Platform.isMacOS) {
    var info = await deviceInfo.macOsInfo;
    return info.osRelease;
  }
  if (Platform.isWindows) {
    var info = await deviceInfo.windowsInfo;
    return info.displayVersion;
  }
  if (Platform.isLinux) {
    LinuxDeviceInfo info = await deviceInfo.linuxInfo;
    return info.version ?? "unknown";
  }
  return "unknown";
}

String getPlatformName() {
  if (Platform.isIOS) {
    return "ios";
  }
  if (Platform.isAndroid) {
    return "android";
  }
  if (Platform.isMacOS) {
    return "macos";
  }
  if (Platform.isWindows) {
    return "windows";
  }
  if (Platform.isLinux) {
    return "linux";
  }
  if (kIsWeb) {
    return "web";
  }
  return "unknown";
}