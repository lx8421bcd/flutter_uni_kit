import 'package:flutter/material.dart';

/// 点击非编辑区域收起软键盘
class AutoHideKeyboard extends StatelessWidget {

  final Widget? child;

  const AutoHideKeyboard({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      child: child,
      onPointerUp: (ev) {
        var primaryFocusChild = FocusManager.instance.primaryFocus;
        if (primaryFocusChild == null) {
          return;
        }
        var focusRect = primaryFocusChild.rect;
        // print(
        //   "focusRect.left = ${focusRect.left} \n"
        //   "focusRect.right = ${focusRect.right} \n"
        //   "focusRect.top = ${focusRect.top}\n"
        //   "focusRect.bottom = ${focusRect.bottom}\n"
        //   "position.dx = ${ev.position.dx}\n"
        //   "position.dy = ${ev.position.dy}\n"
        // );
        if (ev.position.dx >= focusRect.left &&
            ev.position.dx <= focusRect.right &&
            ev.position.dy >= focusRect.top &&
            ev.position.dy <= focusRect.bottom
        ) {
          // 点击区域位于焦点widget内，不作处理
          return;
        }
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
