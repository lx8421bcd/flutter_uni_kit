import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_uni_kit/widgets/input_widget.dart';
import 'package:flutter_uni_kit/widgets/obscure_switch_input.dart';


/// flutter组件交互功能测试页面
///
/// @author linxiao
/// @since 2024-06-25
class InputWidgetTestPage extends StatefulWidget {
  const InputWidgetTestPage({super.key});

  @override
  State<InputWidgetTestPage> createState() => _InputWidgetTestPageState();
}

class _InputWidgetTestPageState extends State<InputWidgetTestPage> {
  final textController = TextEditingController();
  final digitsInputController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        InputWidget(
          labelText: "Label Top, force errorText",
          hintText: "Please Enter",
          controller: TextEditingController(),
          padding: const EdgeInsets.symmetric(vertical: 10),
          showClearButton: true,
          // textDirection: TextDirection.rtl,
          textAlign: TextAlign.end,
          errorText: "123123asdqds",
        ),
        InputWidget(
          labelDirection: LabelDirection.start,
          labelText: "Label Left: ",
          hintText: "Please Enter",
          controller: TextEditingController(),
          padding: const EdgeInsets.symmetric(vertical: 10),
          showClearButton: true,
          // textDirection: TextDirection.rtl,
        ),
        InputWidget(
          controller: textController,
          labelDirection: LabelDirection.material,
          labelText: "Label Material",
          hintText: "input test text",
          showClearButton: true,
          // padding: const EdgeInsets.symmetric(horizontal: 12),
          inputConfigs: const InputConfigs(
            border: UnderlineInputBorder()
          ),
        ),
        12.verticalSpace,
        InputWidget(
          controller: digitsInputController,
          labelText: "Digit Input Limit",
          hintText: "digits only, max length 12",
          showClearButton: true,
          // padding: const EdgeInsets.symmetric(horizontal: 12),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(12)
          ],
          inputConfigs: const InputConfigs(
              border: UnderlineInputBorder()
          ),
        ),
        12.verticalSpace,
        ObscureSwitchInput(
          controller: passwordController,
          labelText: "Password",
          hintText: "input test password",
          showClearButton: true,
          inputConfigs: const InputConfigs(
              border: UnderlineInputBorder()
          ),
        ),
        12.verticalSpace,
      ],
    );
  }
}
