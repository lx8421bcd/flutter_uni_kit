import 'package:flutter/material.dart';
import 'package:flutter_uni_kit/common/device_functions.dart';

class DeviceFunctionTestPage extends StatelessWidget {
  const DeviceFunctionTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          "Platform: ${getPlatformName()}"
        ),
        FutureBuilder<String>(
          future: getDeviceGUID(),
          builder: (ctx, snapshot) => Text(
            "Device GUID: ${snapshot.data}"
          )
        ),
        FutureBuilder<String>(
          future: getDeviceBrand(),
          builder: (ctx, snapshot) => Text(
            "Device brand: ${snapshot.data}"
          )
        ),
        FutureBuilder<String>(
          future: getDeviceModel(),
          builder: (ctx, snapshot) => Text(
            "Device model: ${snapshot.data}"
          )
        ),
        FutureBuilder<String>(
          future: getSystemVersionName(),
          builder: (ctx, snapshot) => Text(
            "System version name: ${snapshot.data}"
          )
        ),
        FutureBuilder<String>(
          future: getAppVersionName(),
          builder: (ctx, snapshot) => Text(
            "App version name: ${snapshot.data}"
          )
        ),
        FutureBuilder<String>(
          future: getAppBuildNumber(),
          builder: (ctx, snapshot) => Text(
            "App build number: ${snapshot.data}"
          )
        ),
      ],
    );
  }

}
