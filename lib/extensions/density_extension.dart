import 'package:flutter_screenutil/flutter_screenutil.dart';

extension DensityExtension on num {
  int get pxValue {
    return (this * (ScreenUtil().pixelRatio ?? 1)).toInt();
  }

  double get dpValue {
    return this / (ScreenUtil().pixelRatio ?? 1);
  }
}