import 'package:example/test/test_root.dart';
import 'package:get/get.dart';

/// 全局页面路由表
///
/// @author linxiao
/// @since 2023-11-01
class AppRouteDefines {
  AppRouteDefines._internal();

  static const String root = '/';

  static var namedRoutes = [
    GetPage(
      name: AppRouteDefines.root,
      page: () => const TestRootPage()
    ),
  ];

}
