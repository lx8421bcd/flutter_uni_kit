import 'package:flutter/material.dart';

typedef ExpandAnimationCallback = void Function(double expandPercent);

enum ExpandDirection {
  left,
  right,
  top,
  bottom,
  ;
}

class ExpansionLayoutController {
  _ExpansionLayoutState? _state;

  bool get expanded => _state?.isExpanded ?? false;

  set expanded(bool value) {
    _state?.changeExpandState(value);
  }

  void _bind(_ExpansionLayoutState state) {
    _state = state;
  }
}

class ExpansionLayout extends StatefulWidget {

  final void Function(bool expanded)? onExpansionChanged;
  final Widget Function(bool expanded)? indicatorBuilder;
  final ExpansionLayoutController? controller;
  final Widget? child;
  final bool expanded;
  final ExpandDirection expandDirection;
  final Duration expandDuration;
  final ExpandAnimationCallback? animationCallback;
  // 默认indicator配置，设置了indicatorBuilder之后不生效
  final double? indicatorWidth;
  final double? indicatorHeight;
  final double? indicatorIconSize;
  final Color? indicatorColor;
  final Color? indicatorBackgroundColor;

  const ExpansionLayout({
    super.key,
    this.onExpansionChanged,
    this.indicatorBuilder,
    this.controller,
    this.child,
    this.expanded = false,
    this.expandDirection = ExpandDirection.bottom,
    this.expandDuration = const Duration(milliseconds: 200),
    this.animationCallback,
    this.indicatorWidth,
    this.indicatorHeight,
    this.indicatorIconSize = 24,
    this.indicatorColor = Colors.grey,
    this.indicatorBackgroundColor,
  });

  @override
  State<ExpansionLayout> createState() => _ExpansionLayoutState();
}

class _ExpansionLayoutState extends State<ExpansionLayout> with SingleTickerProviderStateMixin {

  Animatable<double> easeInTween = CurveTween(curve: Curves.easeIn);
  late ExpansionLayoutController controller;
  late AnimationController animationController;
  late Animation<double> expandFactor;
  late bool isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.expanded;
    controller = widget.controller ?? ExpansionLayoutController();
    controller._bind(this);
    animationController = AnimationController(duration: widget.expandDuration, vsync: this);
    if (isExpanded) {
      animationController.value = 1.0;
    }
    animationController.addListener(() {
      widget.animationCallback?.call(expandFactor.value);
    });
    expandFactor = animationController.drive(easeInTween);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !isExpanded && animationController.isDismissed;
    return AnimatedBuilder(
      animation: animationController.view,
      builder: buildChild,
      child: closed ? null : widget.child,
    );
  }

  Widget buildChild(BuildContext context, Widget? child) {
    var isVerticalOrientation =
        widget.expandDirection == ExpandDirection.top ||
        widget.expandDirection == ExpandDirection.bottom;
    var children = <Widget>[];
    children.add(ClipRect(
      child: Align(
        widthFactor: isVerticalOrientation ? null : expandFactor.value,
        heightFactor: isVerticalOrientation ? expandFactor.value : null,
        child: child,
      ),
    ),);
    var indicatorFirst =
        widget.expandDirection == ExpandDirection.top ||
        widget.expandDirection == ExpandDirection.right;
    children.insert(indicatorFirst ? 0 : 1, buildIndicator());
    return isVerticalOrientation
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: children,
          );
  }

  Widget buildIndicator() {
    if (widget.indicatorBuilder != null) {
      return widget.indicatorBuilder!.call(isExpanded);
    }
    IconData icon() {
      if (widget.expandDirection == ExpandDirection.top ||
          widget.expandDirection == ExpandDirection.bottom
      ) {
        return isExpanded
            ? Icons.keyboard_arrow_up
            : Icons.keyboard_arrow_down;
      }
      else {
        return isExpanded
            ? Icons.keyboard_arrow_left
            : Icons.keyboard_arrow_right;
      }
    }
    return Material(
      color: widget.indicatorBackgroundColor ?? Colors.transparent,
      child: InkWell(
        onTap: () {
          controller.expanded = !isExpanded;
        },
        child: SizedBox(
          width: widget.indicatorWidth,
          height: widget.indicatorHeight,
          child: Icon(icon(),
              size: widget.indicatorIconSize,
              color: widget.indicatorColor
          ),
        ),
      ),
    );
  }

  void changeExpandState(bool expand) {
    setState(() {
      isExpanded = expand;
      if (isExpanded) {
        animationController.forward();
      } else {
        animationController.reverse().then<void>((void value) {
          if (!mounted) return;
        });
      }
      PageStorage.of(context).writeState(context, isExpanded);
    });
    widget.onExpansionChanged?.call(isExpanded);
  }
}