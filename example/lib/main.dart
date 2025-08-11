import 'package:easy_refresh/easy_refresh.dart';
import 'package:example/framework_configs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_uni_kit/app_settings.dart';
import 'package:flutter_uni_kit/theme/theme_manager.dart';
import 'package:example/routes.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'generated/l10n.dart';
import 'themes/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await ScreenUtil.ensureScreenSize();
  await AppSettings.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initGlobalConfigs(context);

    return GetMaterialApp(
      title: 'FastPay Flutter',
      theme: appThemeLight,
      darkTheme: appThemeDark,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.delegate.supportedLocales,
      locale: getLocation(),
      themeMode: ThemeManager.themeMode,
      getPages: AppRouteDefines.namedRoutes,
      initialRoute: AppRouteDefines.root,
      builder: EasyLoading.init(),
    );
  }

  void initGlobalConfigs(BuildContext context) {
    initFrameworkConfigs();
    initializeDateFormatting(Intl.getCurrentLocale());
    ScreenUtil.init(context);
    EasyRefresh.defaultHeaderBuilder = () => const MaterialHeader();
    EasyRefresh.defaultFooterBuilder = () => const ClassicFooter(showMessage: false);
  }

  Locale getLocation() {
    String? locale = AppSettings.get("locale");
    if (locale != null) {
      return Locale(locale);
    }
    return const Locale("en", "US");
  }
}
