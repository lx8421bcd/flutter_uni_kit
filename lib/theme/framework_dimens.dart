/// framework包内，通用尺寸定义
class FrameworkDimens {
  FrameworkDimens._internal();

  static FrameworkDimens instance = FrameworkDimens._internal();

  factory FrameworkDimens() => instance;

  double get fontXXL => 20.0;
  double get fontXL => 18.0;
  double get fontL => 16.0;
  double get fontM => 14.0;
  double get fontS => 12.0;
  double get fontXS => 10.0;
  double get fontXXS => 8.0;

  double get navigationBarHeight => 56.0;
  double get paddingBoth => 12.0;
  double get dialogRadius => 20.0;
  double get dialogMarginBoth => 32.0;

}