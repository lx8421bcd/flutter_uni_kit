import 'package:flutter/material.dart';

/// 纯色按钮
class ColorButton extends StatelessWidget {

  static Color? Function(BuildContext context) defaultForegroundColor = (context) {
    return null;
  };

  static Color? Function(BuildContext context) defaultForegroundColorDisabled = (context) {
    return null;
  };

  static Color? Function(BuildContext context) defaultBackgroundColor = (context) {
    return null;
  };

  static Color? Function(BuildContext context) defaultBackgroundColorDisabled = (context) {
    return null;
  };
  /// 默认按钮圆角
  static BorderRadiusGeometry defaultBorderRadius = BorderRadius.zero;

  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;
  final double? minWidth;
  final double? minHeight;
  final double? maxWidth;
  final double? maxHeight;
  final Color? foregroundColor;
  final Color? foregroundColorDisabled;
  final Color? backgroundColor;
  final Color? backgroundColorDisabled;
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsets? padding;

  const ColorButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.borderRadius,
    this.width,
    this.height,
    this.minWidth,
    this.minHeight,
    this.maxWidth,
    this.maxHeight,
    this.foregroundColor,
    this.foregroundColorDisabled,
    this.backgroundColor,
    this.backgroundColorDisabled,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      constraints: BoxConstraints(
        minWidth: minWidth ?? 0.0,
        minHeight: minHeight ?? 0.0,
        maxWidth: maxWidth ?? double.infinity,
        maxHeight: maxHeight ?? double.infinity,
      ),
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          foregroundColor: foregroundColor ?? defaultForegroundColor(context),
          disabledForegroundColor: foregroundColorDisabled ?? defaultForegroundColorDisabled(context),
          backgroundColor: backgroundColor ?? defaultBackgroundColor(context),
          disabledBackgroundColor: backgroundColorDisabled ?? defaultBackgroundColorDisabled(context),
          shape: RoundedRectangleBorder(borderRadius: borderRadius ?? defaultBorderRadius),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: padding ?? EdgeInsets.zero,
        ),
        child: child
      ),
    );
  }
}
