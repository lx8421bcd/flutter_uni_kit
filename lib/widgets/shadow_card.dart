import 'package:flutter/material.dart';

class ShadowCard extends Container {

  static Color? Function(BuildContext context) defaultForegroundColor = (context) {
    return Colors.white;
  };

  static Color? Function(BuildContext context) defaultShadowColor = (context) {
    return Colors.black.withAlpha(20);
  };

  final double? width;
  final double? height;
  final VoidCallback? onPressed;

  ShadowCard({
    super.key,
    super.alignment,
    super.child,
    super.clipBehavior = Clip.hardEdge,
    super.constraints,
    super.decoration = const BoxDecoration(),
    super.foregroundDecoration,
    super.margin,
    super.padding,
    super.transform,
    super.transformAlignment,
    this.width,
    this.height,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var shadowedDecoration = decoration;
    if (decoration is BoxDecoration) {
      var boxDecoration = (decoration as BoxDecoration);
      shadowedDecoration = (decoration as BoxDecoration).copyWith(
        color: boxDecoration.color ?? defaultForegroundColor(context),
        borderRadius: (decoration as BoxDecoration).borderRadius ?? BorderRadius.circular(16),
        boxShadow: (decoration as BoxDecoration).boxShadow ?? [
          BoxShadow(
            color: defaultShadowColor(context) ?? Colors.black.withAlpha(20),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );
    }
    var actualChild = onPressed != null
    ? Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    )
    : child;
    var actualCardPadding = onPressed != null ? null : padding;
    return Container(
      alignment: alignment,
      clipBehavior: clipBehavior,
      constraints: constraints,
      decoration: shadowedDecoration,
      foregroundDecoration: foregroundDecoration,
      margin: margin,
      padding: actualCardPadding,
      transform: transform,
      transformAlignment: transformAlignment,
      height: height,
      width: width,
      child: actualChild,
    );
  }

}