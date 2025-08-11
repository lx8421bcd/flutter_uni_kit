import 'package:flutter/material.dart';
import 'package:flutter_uni_kit/extensions/route_extensions.dart';
import 'package:flutter_uni_kit/theme/framework_dimens.dart';
import 'package:get/get.dart';

///App内通用顶部NavigationBar
///
/// @author linxiao
/// @since 2023-11-13
class AppNavigationBar extends AppBar {

  /// 默认title颜色
  static Color? Function(BuildContext context) defaultTitleColor = (context) {
    return Theme.of(context).textTheme.displayLarge?.color;
  };

  /// 构建默认样式的title widget
  static Widget buildTitleText(BuildContext context, String titleText, {Color? titleColor}) {
    return Text(titleText,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: titleColor ?? defaultTitleColor(context),
          fontSize: FrameworkDimens().fontXL,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis);
  }

  /// 构建默认样式Back按钮
  static Widget buildBackButton(BuildContext context, {Color? color}) {
    return  SizedBox(
      width: 40,
      child: IconButton(
          onPressed: () {
            closePage();
          },
          icon: Icon(Icons.arrow_back_ios_new, color: color ?? defaultTitleColor(context)
          )
      ),
    );
  }

  /// 构建默认样式的title右侧文字按钮
  static Widget buildActionText(BuildContext context, String name, VoidCallback onPressed) {
    return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: defaultTitleColor(context),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          padding: EdgeInsets.zero
        ),
        child: Text(name,
          textAlign: TextAlign.center,
          style: TextStyle(color: defaultTitleColor(context), fontSize: FrameworkDimens().fontM)
        )
    );
  }

  AppNavigationBar({
    super.key,
    super.automaticallyImplyLeading = false,
    super.flexibleSpace,
    super.bottom,
    super.elevation = 4,
    super.scrolledUnderElevation,
    super.notificationPredicate = defaultScrollNotificationPredicate,
    super.shadowColor = Colors.black26,
    super.surfaceTintColor,
    super.shape,
    super.backgroundColor,
    super.foregroundColor,
    super.iconTheme,
    super.actionsIconTheme,
    super.primary = true,
    super.centerTitle = true,
    super.excludeHeaderSemantics = false,
    super.titleSpacing,
    super.toolbarOpacity = 1.0,
    super.bottomOpacity = 1.0,
    super.leadingWidth,
    super.toolbarTextStyle,
    super.titleTextStyle,
    super.systemOverlayStyle,
    super.forceMaterialTransparency = false,
    super.clipBehavior,
    BuildContext? context,
    double? toolbarHeight,
    Widget? title,
    String titleText = "",
    Color? titleColor,
    bool showBack = true,
    Widget? leading,
    List<Widget> actionButtonLeft = const [],
    List<Widget> actionButtonRight = const [],
  }): super (
    toolbarHeight: toolbarHeight ?? FrameworkDimens().navigationBarHeight,
    title: title ?? buildTitleText(context ?? Get.context!, titleText, titleColor: titleColor),
    leading: leading ?? (showBack || actionButtonLeft.isNotEmpty
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: []
              ..addIf(showBack, buildBackButton(context ?? Get.context!, color: titleColor))
              ..addAll(actionButtonLeft)
          )
        : null),
    actions: actionButtonRight.isNotEmpty ? actionButtonRight : null,
  );

}
