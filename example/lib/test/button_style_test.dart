import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_uni_kit/widgets/border_button.dart';
import 'package:flutter_uni_kit/widgets/color_button.dart';
import 'package:flutter_uni_kit/widgets/gradient_button.dart';
import 'package:example/themes/app_colors.dart';


/// flutter组件交互功能测试页面
///
/// @author linxiao
/// @since 2023-11-01
class ButtonTestPage extends StatelessWidget {
  const ButtonTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        GradientButton(
          height: 40,
          child: const Text("Gradient Button"),
          onPressed: () {
          },
        ),
        12.verticalSpace,
        const GradientButton(
          height: 40,
          onPressed: null,
          child: Text("Gradient Button disabled"),
        ),
        12.verticalSpace,
        BorderButton(
          onPressed: () {},
          child: const Text("Border Button"),
        ),
        12.verticalSpace,
        BorderButton(
          onPressed: null,
          color: AppColors.main.get(),
          child: const Text("Border Button disabled"),
        ),
        12.verticalSpace,
        ColorButton(
          onPressed: () {},
          child: const Text("Filled Button"),
        ),
        12.verticalSpace,
        const ColorButton(
          onPressed: null,
          child: Text("Filled Button disabled"),
        ),
      ],
    );
  }
}
