import 'package:flutter/material.dart';

///渐变色按钮
class GradientButton extends StatelessWidget {

  /// 渐变按钮样式 - 默认
  static Gradient Function(BuildContext) defaultEnabledGradient = (context) {
    return const LinearGradient(
        colors: [Color(0xFF49B2FF), Color(0xFF005DA0)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight
    );
  };
  /// 渐变按钮样式 - 不可用
  static Gradient Function(BuildContext) defaultDisabledGradient = (context) {
    return const LinearGradient(
      colors: [Color(0x8049B2FF), Color(0x80005DA0)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight
    );
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
  final Gradient? gradientEnabled;
  final Gradient? gradientDisabled;
  final VoidCallback? onPressed;
  final Widget child;

  const GradientButton({
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
    this.gradientEnabled,
    this.gradientDisabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var gradientEnabled  = this.gradientEnabled ?? defaultEnabledGradient(context);
    var gradientDisabled  = this.gradientDisabled ?? defaultDisabledGradient(context);
    final borderRadius = this.borderRadius ?? defaultBorderRadius;
    final buttonGradient = onPressed != null ? gradientEnabled : gradientDisabled;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: buttonGradient,
        borderRadius: borderRadius,
      ),
      constraints: BoxConstraints(
        minWidth: minWidth ?? 0.0,
        minHeight: minHeight ?? 0.0,
        maxWidth: maxWidth ?? double.infinity,
        maxHeight: maxHeight ?? double.infinity,
      ),
      child: FilledButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: child,
      ),
    );
  }
}