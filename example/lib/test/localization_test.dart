import 'dart:async';

import 'package:example/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uni_kit/app_settings.dart';
import 'package:flutter_uni_kit/widgets/gradient_button.dart';
import 'package:flutter_uni_kit/alerts/dialog_alert.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LocalizationTestPage extends StatefulWidget {
  const LocalizationTestPage({super.key});

  @override
  State<LocalizationTestPage> createState() => _LocalizationTestPageState();
}

class _LocalizationTestPageState extends State<LocalizationTestPage> {

  final timeNow = DateTime.now().obs;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => timeNow.value = DateTime.now());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        GradientButton(
          height: 40,
          child: Text(AppLocalizations.current.switchLocalizationTest),
          onPressed: () {
            DialogAlert()
              ..setAction(
                  actionText: "中文",
                  action: () {
                    AppLocalizations.load(const Locale("zh"));
                    Get.back();
                    Get.forceAppUpdate();
                    AppSettings.set("locale", "zh");
                  })
              ..setAction(
                  actionText: "English",
                  action: () {
                    AppLocalizations.load(const Locale("en"));
                    Get.back();
                    Get.forceAppUpdate();
                    AppSettings.set("locale", "en");
                  })
              ..showBottom();
          },
        ),
        Obx(() => Text(AppLocalizations.current.dateTimeTest(timeNow.value, timeNow.value))),
        Text(AppLocalizations.current.currentLocalTest(Intl.getCurrentLocale(), Localizations.localeOf(context).countryCode ?? "null")),
        Text(AppLocalizations.current.messageTest(0)),
        Text(AppLocalizations.current.messageTest(1)),
        Text(AppLocalizations.current.messageTest(2)),
        Text(AppLocalizations.current.roleTest("123")),
        Text(AppLocalizations.current.genderTest("123")),
      ],
    );
  }
}

