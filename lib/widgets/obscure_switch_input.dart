import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uni_kit/widgets/input_widget.dart';

class ObscureSwitchInput extends StatefulWidget {

  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextInputAction inputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscured;
  final String? obscureCharacter;
  final Widget? prefixWidget;
  final String prefixText;
  final String? errorText;
  final bool readOnly;
  final bool enabled;
  final bool showClearButton;
  final bool showSwitchButton;
  final GestureTapCallback? onTap;
  final InputConfigs inputConfigs;
  final EdgeInsetsGeometry? padding;
  final FocusNode? focusNode;
  final Widget Function(bool obscure)? switchIconBuilder;

  const ObscureSwitchInput({
    super.key,
    required this.controller,
    this.labelText = "",
    this.hintText = "",
    this.keyboardType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.inputFormatters,
    this.obscured = true,
    this.obscureCharacter,
    this.prefixWidget,
    this.prefixText = "",
    this.errorText,
    this.readOnly = false,
    this.enabled = true,
    this.showClearButton = false,
    this.showSwitchButton = true,
    this.onTap,
    this.inputConfigs = const InputConfigs(),
    this.padding,
    this.focusNode,
    this.switchIconBuilder,
  });

  @override
  State<ObscureSwitchInput> createState() => _ObscureSwitchInputState();
}

class _ObscureSwitchInputState extends State<ObscureSwitchInput> {

  bool obscured = true;

  @override
  void initState() {
    obscured = widget.obscured;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var switchBtn = InkWell(
        onTap: () {
          setState(() {
            obscured = !obscured;
          });
        },
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: widget.switchIconBuilder?.call(obscured) ?? Icon(
            obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            size: 20,
            color: widget.inputConfigs.suffixTextStyle?.color
        )
    );
    return InputWidget(
      obscureText: obscured,
      obscureCharacter: widget.obscureCharacter ?? "•",
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText,
      keyboardType: widget.keyboardType,
      inputAction: widget.inputAction,
      inputFormatters: widget.inputFormatters,
      prefixWidget: widget.prefixWidget,
      prefixText: widget.prefixText,
      suffixWidget: widget.showSwitchButton ? switchBtn : null,
      errorText: widget.errorText,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      showClearButton: widget.showClearButton,
      onTap: widget.onTap,
      inputConfigs: widget.inputConfigs,
      padding: widget.padding,
      focusNode: widget.focusNode,
    );
  }

}