import 'package:flutter/material.dart';

class WheelView extends StatelessWidget {

  static final defaultBorderIndicator = Container(
    decoration: const BoxDecoration(
      border: Border.symmetric(
          horizontal: BorderSide(color: Color(0x40000000))
      ),
    ),
  );

  static final defaultMaskedIndicator = Container(
    decoration: const BoxDecoration(
      color: Color(0x10000000),
    ),
  );

  final List<Widget> children;

  final int initialItem;

  final double itemExtent;

  final double squeeze;

  final double perspective;

  final ValueChanged<int>? onSelectedItemChanged;

  final Widget indicator;

  final bool loop;

  final FixedExtentScrollController controller;

  final double overAndUnderCenterOpacity;

  WheelView({
    super.key,
    Widget? indicator,
    FixedExtentScrollController? controller,
    required this.children,
    this.itemExtent = 50,
    this.squeeze = 1.0,
    this.perspective = 0.0000001,
    this.initialItem = 0,
    this.overAndUnderCenterOpacity = 1,
    this.onSelectedItemChanged,
    this.loop = false,
  }):
    controller = controller ?? FixedExtentScrollController(initialItem: initialItem),
    indicator = indicator ?? defaultBorderIndicator;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (controller.selectedItem != initialItem) {
        controller.jumpToItem(initialItem);
      }
    });
    final childDelegate = loop
        ? ListWheelChildLoopingListDelegate(children: children)
        : ListWheelChildListDelegate(children: children);
    return Stack(
      children: [
        ListWheelScrollView.useDelegate(
          itemExtent: itemExtent,
          squeeze: squeeze,
          perspective: perspective,
          // 不能为0
          physics: const FixedExtentScrollPhysics(),
          overAndUnderCenterOpacity: overAndUnderCenterOpacity,
          controller: controller,
          onSelectedItemChanged: onSelectedItemChanged,
          childDelegate: childDelegate,
        ),
        Center(
          child: IgnorePointer(
            child: SizedBox (
              height: itemExtent,
              child: indicator,
            ),
          ),
        ),
      ],
    );
  }
}
