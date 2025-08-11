import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uni_kit/theme/framework_dimens.dart';
import 'package:flutter_uni_kit/widgets/fp_cached_network_image.dart';

/// 设置项样式
///
/// [normal] - 右箭头跳转样式
/// [itemSwitch] - 开关样式
enum SettingItemStyle {
  normal,
  itemSwitch
}

/// App通用设置项widget
/// 包含常见的右箭头下一步样式和Switch开关样式
///
/// @author linxiao
/// @since 2023-11-15
class SettingItem extends StatelessWidget {

  static const double _iconSize = 20;
  static const double _defaultMinimumHeight = 46;
  static const double _switchScale = 0.7;
  static const double _switchDefaultWidth = 51 * _switchScale;
  static const double _switchDefaultHeight = 31 * _switchScale;

  /// 默认icon颜色
  static Color? Function(BuildContext context) defaultIconColor = (context) {
    return Theme.of(context).primaryColor;
  };
  /// 默认title颜色
  static Color? Function(BuildContext context) defaultTitleColor = (context) {
    return Theme.of(context).primaryColor;
  };
  /// 默认text颜色
  static Color? Function(BuildContext context) defaultTextColor = (context) {
    return Theme.of(context).disabledColor;
  };
  /// 默认switch颜色
  static Color? Function(BuildContext context) defaultSwitchColor = (context) {
    return Theme.of(context).primaryColor;
  };
  /// 默认divider颜色
  static Color Function(BuildContext context) defaultDividerColor = (context) {
    return Theme.of(context).dividerColor;
  };
  /// 默认是否显示底部分隔线
  static bool defaultShowDivider = true;
  /// 默认最低高度
  static double defaultMinimumHeight = _defaultMinimumHeight;

  /// 构建默认样式的value显示Text Widget
  static Widget buildValueText(BuildContext context, String valueText) {
    return Text(valueText,
        style: TextStyle(
            fontSize: FrameworkDimens().fontS,
            color: defaultTextColor(context)
        )
    );
  }
  /// 构建默认样式的icon Widget。
  /// 三个传入参数三选一即可，多个参数按 iconUrl > iconAsset > iconData来取
  /// [iconUrl] 网络图片url
  /// [iconAsset] 本地asset资源路径
  /// [iconData] 系统内的icon资源数据
  /// [iconColor] icon颜色，仅对iconData生效
  /// @return 固定大小（默认20*20）的icon widget
  static Widget? buildSettingIcon({
    String iconUrl = "",
    String iconAsset = "",
    IconData? iconData,
    Color? iconColor
  }) {
    if (iconUrl.isNotEmpty) {
      return FPCachedNetworkImage(
        width: _iconSize,
        height: _iconSize,
        imageUrl: iconUrl,
        placeholder: (context, url) => const CupertinoActivityIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    }
    if (iconAsset.isNotEmpty) {
      return SizedBox(
        width: _iconSize,
        height: _iconSize,
        child: Image.asset(iconAsset),
      );
    }
    if (iconData != null) {
      return Icon(
        iconData,
        color: iconColor,
        size: _iconSize,
      );
    }
    return null;
  }

  final SettingItemStyle style;
  final double? minimumHeight;
  final EdgeInsets padding;
  final bool? showDivider;
  final Color? dividerColor;
  final Widget? icon;
  final String iconUrl;
  final String iconAsset;
  final IconData? iconData;
  final Color? iconColor;
  final String title;
  final TextStyle? titleStyle;
  final Widget? titleWidget;
  final Widget? value;
  final bool switchSelected;
  final Color? switchActiveColor;
  final Color? switchTrackColor;
  final Color? switchThumbColor;
  final VoidCallback? onPressed;

  const SettingItem({
    super.key,
    required this.title,
    this.titleStyle,
    this.titleWidget,
    this.style = SettingItemStyle.normal,
    this.minimumHeight,
    this.padding = const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
    this.showDivider,
    this.dividerColor,
    this.icon,
    this.iconUrl = "",
    this.iconAsset = "",
    this.iconData,
    this.iconColor,
    this.value,
    this.onPressed,
    this.switchSelected = false,
    this.switchActiveColor,
    this.switchTrackColor,
    this.switchThumbColor,
  });

  @override
  Widget build(BuildContext context) {
    var icon = this.icon ?? buildSettingIcon(
      iconUrl: iconUrl,
      iconAsset: iconAsset,
      iconData: iconData,
      iconColor: iconColor ?? defaultIconColor(context)
    );
    Widget? action = onPressed == null ? null : Icon(
      Icons.arrow_forward_ios_outlined,
      color: defaultTitleColor(context),
      size: 14,
    );
    VoidCallback? itemOnPressed = onPressed;
    if (style == SettingItemStyle.itemSwitch) {
      action = SizedBox(
        height: _switchDefaultHeight,
        width: _switchDefaultWidth,
        child: Transform.scale(
          scale: _switchScale,
          child: CupertinoSwitch(
            activeTrackColor: switchActiveColor ?? defaultSwitchColor(context),
            inactiveTrackColor: switchTrackColor,
            thumbColor: switchThumbColor,
            value: switchSelected,
            onChanged: itemOnPressed == null ? null : (select) {
              itemOnPressed.call();
            }
          ),
        ),
      );
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: itemOnPressed,
        child: Container(
          constraints: BoxConstraints(
            minHeight: minimumHeight ?? defaultMinimumHeight
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: (showDivider ?? defaultShowDivider) ? 1.0 : 0,
                color: (showDivider ?? defaultShowDivider)
                  ? dividerColor ?? defaultDividerColor(context)
                  : Colors.transparent
              ),
            )
          ),
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: icon != null ? 8 : 0,
                ),
                child: icon,
              ),
              titleWidget ?? Text(
                title,
                style: titleStyle ?? TextStyle(
                  fontSize: FrameworkDimens().fontL,
                  color: defaultTitleColor(context)
                )
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: value ?? const SizedBox()
                )
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: action != null ? 8 : 0,
                ),
                child: action,
              ),
            ],
          ),
        ),
      ),
    );
  }


}
