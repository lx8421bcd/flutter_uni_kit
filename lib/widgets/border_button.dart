import 'package:flutter/material.dart';

/// 边框按钮
class BorderButton extends StatelessWidget {

  static Color? Function(BuildContext context) defaultColor = (context) {
    return null;
  };

  static Color? Function(BuildContext context) defaultColorDisabled = (context) {
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
  final double borderWidth;
  final Color? color;
  final Color? colorDisabled;
  final Color? filledColor;
  final Color? filledColorDisabled;
  final VoidCallback? onPressed;
  final Widget child;

  final EdgeInsets? padding;

  const BorderButton(
      {Key? key,
        required this.onPressed,
        required this.child,
        this.borderRadius,
        this.width,
        this.height,
        this.minWidth,
        this.minHeight,
        this.maxWidth,
        this.maxHeight,
        this.borderWidth = 1.0,
        this.color,
        this.colorDisabled,
        this.filledColor,
        this.filledColorDisabled,
        this.padding,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? defaultBorderRadius;
    final finalColor = color ?? defaultColor(context);
    final finalColorDisabled = colorDisabled ?? defaultColorDisabled(context);
    final borderColor = onPressed != null ? finalColor : finalColorDisabled;
    return Container(
      width: width,
      height: height,
      constraints: BoxConstraints(
        minWidth: minWidth ?? 0.0,
        minHeight: minHeight ?? 0.0,
        maxWidth: maxWidth ?? double.infinity,
        maxHeight: maxHeight ?? double.infinity,
      ),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: finalColor,
          disabledForegroundColor: colorDisabled,
          backgroundColor: filledColor,
          disabledBackgroundColor: filledColorDisabled,
          padding: padding,
          side: BorderSide(
            width: borderWidth,
            color: borderColor ?? Theme.of(context).primaryColor,
            style: BorderStyle.solid,
          ),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: child
      ),
    );
  }
}