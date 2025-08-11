import 'package:flutter/material.dart';
import 'package:flutter_uni_kit/theme/framework_colors.dart';
import 'package:flutter_uni_kit/theme/framework_dimens.dart';
import 'package:get/get.dart';

/// 以App通用样式dialog形式显示Widget扩展方法
///
/// showAsDialog - 直接以dialog形式显示
/// showAsDialogContent - 外层包裹dialog样式Container，再以dialog样式显示
extension ShowAsDialogExtension on Widget {

  Future<T?> showAsCommonDialog<T>({
    BuildContext? context,
    bool cancelable = true,
  }) {
    return showDialog<T?>(
        context: context ?? Get.context!,
        builder: (BuildContext context) => WillPopScope(
          child: this,
          onWillPop: () => Future.value(cancelable)
        )
    );
  }

  Future<T?> showAsCommonDialogContent<T>({
    BuildContext? context,
    bool cancelable = true,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: FrameworkDimens().dialogMarginBoth,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(FrameworkDimens().dialogRadius),
          child: Container(
            decoration: BoxDecoration(
              color: FrameworkColors().foreground(context ?? Get.context!),
            ),
            child: this,
          ),
        ),
      ),
    )
    .showAsCommonDialog<T>(context: context, cancelable: cancelable);
  }

  Future<T?> showAsBottomDialog<T>({
    BuildContext? context,
    bool cancelable = true,
  }) {
    return showModalBottomSheet<T>(
        context: context ?? Get.context!,
        isScrollControlled: true,
        isDismissible: cancelable,
        enableDrag: cancelable,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => WillPopScope(
            child: Wrap(
              children: [this],
            ),
            onWillPop: () => Future.value(cancelable)
        )
    );
  }

  Future<T?> showAsBottomDialogContent<T>({
    BuildContext? context,
    bool cancelable = true,
  }) {
    var radius = Radius.circular(FrameworkDimens().dialogRadius);
    BorderRadius dialogRadius = BorderRadius.only(
      topLeft: radius,
      topRight: radius,
    );
    return Center(
      child: ClipRRect(
        borderRadius: dialogRadius,
        child: Container(
          // width: double.infinity,
          decoration: BoxDecoration(
            color: FrameworkColors().foreground(context ?? Get.context!),
          ),
          child: this,
        ),
      ),
    )
    .showAsBottomDialog<T>(context: context, cancelable: cancelable);
  }

}