import 'package:flutter_easyloading/flutter_easyloading.dart';

///全局Toast
///持续时间默认2秒
///弹出位置默认底部
toastAlert(String message, [Duration duration = const Duration(seconds: 2)]) {
  EasyLoading.showToast(message,
    duration: duration,
    toastPosition: EasyLoadingToastPosition.center,
    maskType: EasyLoadingMaskType.none
  );
}