import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


/// widget以PopupWindow样式快速显示扩展
extension ShowAsPopupExtension on Widget {

  Future<T?> showAsPopupWindow<T>({
    required GlobalKey targetKey,
    PopupGravity gravity = PopupGravity.bottom,
    Offset offset = Offset.zero,
    BuildContext? context,
    bool cancelable = true,
  }) {
    return showPopupWindow<T?>(
        context: context,
        child: this,
        targetKey: targetKey,
        gravity: gravity,
        dismissible: cancelable,
        offset: offset
    );
  }

  Future<T?> showAsPopupWindowContent<T>({
    required GlobalKey targetKey,
    PopupGravity gravity = PopupGravity.bottom,
    Offset offset = Offset.zero,
    BuildContext? context,
    bool cancelable = true,
  }) {
    return Material(
      elevation: 4,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: this,
      ),
    )
        .showAsPopupWindow<T>(
        targetKey: targetKey,
        gravity: gravity,
        offset: offset,
        context: context,
        cancelable: cancelable
    );
  }
}

/// 高亮导航队列，先添加后显示
class HighlightGuideQueue {

  final Queue<PopupWindow> guideQueue = Queue();

  void addGuide({
    required Widget child,
    required GlobalKey targetKey,
    PopupGravity gravity = PopupGravity.bottom,
  }) {
    guideQueue.add(
      PopupWindow(
        child: child,
        targetKey: targetKey,
        gravity: gravity,
        highlightGuideStyle: true
      )
    );
  }

  void show(BuildContext? context) {
    context = context ?? Get.context;
    if (context == null || guideQueue.isEmpty) {
      return;
    }
    var showPopup = guideQueue.removeFirst();
    Navigator.of(context).push(showPopup).then((value) async {
      await Future.delayed(const Duration(milliseconds: 200));
      Future.sync(() => show(context));
    });
  }
}

/// 以PopupWindow样式显示内容构建函数
Future<T?> showPopupWindow<T>({
  required Widget child,
  required GlobalKey targetKey,
  BuildContext? context,
  PopupGravity gravity = PopupGravity.bottom,
  bool dismissible = true,
  Offset offset = Offset.zero,
  bool highlightGuideStyle = false,
}) {
  context = context ?? Get.context;
  if (context == null) {
    return Future(() {
      return null;
    });
  }
  return Navigator.of(context).push(PopupWindow<T>(
      child: child,
      targetKey: targetKey,
      gravity: gravity,
      dismissible: dismissible,
      offset: offset,
      highlightGuideStyle: highlightGuideStyle
  ));
}

/// PopupWindow内容相对于目标Widget的显示位置
/// [left] - 左边，垂直居中
/// [right] - 右边，垂直居中
/// [top] - 顶部，水平居中
/// [bottom] - 底部，水平居中
enum PopupGravity {
  left,
  right,
  top,
  bottom,
}

/// popup window样式弹窗
///
/// @author linxiao
/// @since 2023-11-17
class PopupWindow<T> extends PopupRoute<T> {

  final Widget child;
  final GlobalKey targetKey;
  final PopupGravity gravity;
  final bool dismissible;
  final Offset offset;
  final bool highlightGuideStyle;

  final GlobalKey _childContainerKey = GlobalKey();
  final _positionParams = _PositionParams().obs;

  PopupWindow({
    required this.child,
    required this.targetKey,
    this.gravity = PopupGravity.top,
    this.dismissible = true,
    this.offset = Offset.zero,
    this.highlightGuideStyle = false
  });

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Color get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => dismissible;

  @override
  String get barrierLabel => '';

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation
  ) {
    final RenderBox targetBox = targetKey.currentContext?.findRenderObject() as RenderBox;
    final Offset targetOffset = targetBox.localToGlobal(targetBox.size.bottomLeft(Offset.zero));
    // 在首次渲染后调整位置
    if (_positionParams.value.childWidth == 0 && _positionParams.value.childHeight == 0) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _repositionWindow(context);
      });
    }
    _positionParams.value = _PositionParams(
      targetWidth: targetBox.size.width,
      targetHeight: targetBox.size.height,
      targetDx: targetOffset.dx,
      targetDy: targetOffset.dy,
      dx: targetOffset.dx,
      dy: targetOffset.dy
    );
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // 如果为高亮引导模式，添加蒙版及高亮区域
          highlightGuideStyle ? GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.black54,
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  Container(
                    color: Colors.black54,
                  ),
                  Positioned(
                    left: targetOffset.dx - 4,
                    top: targetOffset.dy - targetBox.size.height - 4,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(24))
                      ),
                      width: targetBox.size.width + 8,
                      height: targetBox.size.height + 8,
                    ),
                  ),
                ],
              ),
            ),
          )
          :
          const SizedBox(),
          Obx(() => Positioned(
            left: _positionParams.value.dx,
            top: _positionParams.value.dy,
            child: Visibility(
              maintainSize: true,
              maintainState: true,
              maintainAnimation: true,
              visible: _positionParams.value.childWidth != 0 || _positionParams.value.childHeight != 0,
              child: Container(
                key: _childContainerKey,
                child: child,
              ),
            )
          ),)
        ],
      ),
    );
  }

  /// 根据设定gravity和当前popupWindow情况调整位置
  void _repositionWindow(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final RenderBox childBox = _childContainerKey.currentContext?.findRenderObject() as RenderBox;
    double adjustedX = _positionParams.value.dx;
    double adjustedY = _positionParams.value.dy;
    switch (gravity) {
      case PopupGravity.left:
        adjustedX = _positionParams.value.dx - childBox.size.width;
        adjustedY = _positionParams.value.dy - _positionParams.value.targetHeight / 2 - childBox.size.height / 2;
        break;
      case PopupGravity.right:
        adjustedX = _positionParams.value.dx + _positionParams.value.targetWidth;
        adjustedY = _positionParams.value.dy - _positionParams.value.targetHeight / 2 - childBox.size.height / 2;
        break;
      case PopupGravity.top:
        adjustedX = _positionParams.value.dx + _positionParams.value.targetWidth / 2 - childBox.size.width / 2;
        adjustedY = _positionParams.value.dy - _positionParams.value.targetHeight - childBox.size.height;
        break;
      case PopupGravity.bottom:
        adjustedX = _positionParams.value.dx + _positionParams.value.targetWidth / 2 - childBox.size.width / 2;
        adjustedY = _positionParams.value.dy;
        break;
    }
    // 如果child显示超出屏幕，尽量调整child位置至可以完全显示
    if (adjustedX < 0) {
      adjustedX = 0;
      adjustedY = _positionParams.value.dy;
    }
    if (adjustedX > screenSize.width - childBox.size.width) {
      adjustedX = screenSize.width - childBox.size.width;
      adjustedY = _positionParams.value.dy;
    }
    if (adjustedY < 0) {
      adjustedY = _positionParams.value.dy;
    }
    if (adjustedY + childBox.size.height > screenSize.height) {
      adjustedY = _positionParams.value.dy - _positionParams.value.targetHeight - childBox.size.height;
    }
    _positionParams.value = _positionParams.value.copyWith(
      dx: adjustedX + offset.dx,
      dy: adjustedY + offset.dy,
      childWidth: childBox.size.width,
      childHeight: childBox.size.height,
    );
  }
}

class _PositionParams {
  double targetWidth;
  double targetHeight;
  double targetDx;
  double targetDy;
  double childWidth;
  double childHeight;
  double dx;
  double dy;

  _PositionParams({
    this.targetWidth = 0,
    this.targetHeight = 0,
    this.targetDx = 0,
    this.targetDy = 0,
    this.childWidth = 0,
    this.childHeight = 0,
    this.dx = 0,
    this.dy = 0,

  });

  _PositionParams copyWith({
    double targetWidth = 0,
    double targetHeight = 0,
    double targetDx = 0,
    double targetDy = 0,
    double childWidth = 0,
    double childHeight = 0,
    double dx = 0,
    double dy = 0,
  }) {
    return _PositionParams(
        targetWidth: targetWidth,
        targetHeight: targetHeight,
        targetDx: targetDx,
        targetDy: targetDy,
        childWidth: childWidth,
        childHeight: childHeight,
        dx: dx,
        dy: dy
    );
  }
}