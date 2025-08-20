import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class BottomDialogPanel extends StatefulWidget {

  static Color? Function(BuildContext context) defaultTitleColor = (context) {
    return Colors.black;
  };

  static double Function(BuildContext context) defaultTitleSize = (context) {
    return 16;
  };

  final String? title;
  final bool showBack;
  final double? childHeight;
  final Widget? child;
  final Widget? leftButton;
  final Widget? rightButton;

  const BottomDialogPanel({
    super.key,
    this.child,
    this.showBack = true,
    this.title,
    this.childHeight,
    this.leftButton,
    this.rightButton,
  });

  @override
  State<BottomDialogPanel> createState() => _BottomDialogPanelState();

}

class _BottomDialogPanelState extends State<BottomDialogPanel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 56,
          child: Stack(
            children: [
              Row(
                children: [
                  ...(widget.showBack ? [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: BottomDialogPanel.defaultTitleColor(context),
                      ),
                    )
                  ] : []),
                  widget.leftButton ?? const SizedBox()
                ],
              ),
              Center(
                child: Text(widget.title ?? "",
                  style: TextStyle(
                    fontSize: BottomDialogPanel.defaultTitleSize(context),
                    color: BottomDialogPanel.defaultTitleColor(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: widget.rightButton
              ),
            ],
          ),
        ),
        SizedBox(
          height: widget.childHeight ?? ScreenUtil().screenHeight * 0.5,
          child: widget.child
        ),
      ],
    );
  }
}
