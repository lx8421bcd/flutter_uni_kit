import 'package:flutter/material.dart';

typedef CheckBoxBuilder = Widget Function(BuildContext context, bool checked);

enum CheckBoxDisplaySide {
  left,
  top,
  right,
  bottom,
}

class AppCheckBox extends StatefulWidget {
  
  static CheckBoxBuilder defaultCheckboxBuilder = (context, checked) {
    return SizedBox(
      width: 20,
      height: 20,
      child: Checkbox(
        value: checked,
        onChanged: null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: WidgetStateBorderSide.resolveWith(
              (states) => states.contains(WidgetState.selected)
              ? BorderSide.none
              : const BorderSide(width: 1.0, color: Color(0xFFD1DAE7)),
        ),
        fillColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
              ? const Color(0xFF159CFF)
              : Colors.transparent,
        ),
      ),
    );
  };

  final bool checked;
  final CheckBoxBuilder? checkBoxBuilder;
  final CheckBoxDisplaySide checkBoxDisplaySide;
  final EdgeInsets contentPadding;
  final String title;
  final TextStyle? titleTextStyle;
  final double spaceBetween;
  final void Function(bool)? onChanged;

  const AppCheckBox({
    super.key,
    this.checked = false,
    this.checkBoxBuilder,
    this.checkBoxDisplaySide = CheckBoxDisplaySide.left,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 4),
    this.title = "",
    this.titleTextStyle,
    this.spaceBetween = 4,
    this.onChanged,
  });

  @override
  State<AppCheckBox> createState() => _AppCheckBoxState();
}

class _AppCheckBoxState extends State<AppCheckBox> {

  bool checked = false;

  @override
  Widget build(BuildContext context) {
    checked = widget.checked;
    var checkBoxBuilder = widget.checkBoxBuilder ?? AppCheckBox.defaultCheckboxBuilder;
    var checkBox = checkBoxBuilder(context, checked);
    var spaceBetween = SizedBox(width: widget.spaceBetween);
    var title = Flexible(
        child: Text(widget.title, style: widget.titleTextStyle)
    );
    return InkWell(
      onTap: widget.onChanged != null
      ? () {
        setState(() {
          checked = !checked;
          widget.onChanged?.call(checked);
        });
      }
      : null,
      child: Container(
        padding: widget.contentPadding,
        child: {
          CheckBoxDisplaySide.left: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              checkBox,
              spaceBetween,
              title
            ],
          ),
          CheckBoxDisplaySide.top: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              checkBox,
              spaceBetween,
              title
            ],
          ),
          CheckBoxDisplaySide.right: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              title,
              spaceBetween,
              checkBox
            ],
          ),
          CheckBoxDisplaySide.bottom: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              title,
              spaceBetween,
              checkBox
            ],
          ),
        }[widget.checkBoxDisplaySide],
      ),
    );
  }
}
