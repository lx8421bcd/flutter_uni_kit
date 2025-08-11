import 'package:flutter/material.dart';
import 'package:flutter_uni_kit/theme/framework_dimens.dart';
import 'package:flutter_uni_kit/widgets/wheel_datetime_picker.dart';

class WheelDatetimePickerPanel extends StatefulWidget {

  static Color? Function(BuildContext context) titleColor = (context) {
    return Theme.of(context).textTheme.displayLarge?.color;
  };

  static Color? Function(BuildContext context) confirmColor = (context) {
    return Theme.of(context).primaryColor;
  };

  static Color? Function(BuildContext context) cancelColor = (context) {
    return Theme.of(context).disabledColor;
  };

  static Color? Function(BuildContext context) dividerColor = (context) {
    return Theme.of(context).dividerColor;
  };

  static String Function() confirmText = () => "Confirm";

  static String Function() cancelText = () => "Cancel";

  final WheelDateTimePickerMode mode;
  final String Function(DateTime selectedDateTime)? title;
  final DateTime? selectedDateTime;
  final DateTime? minDateTime;
  final DateTime? maxDateTime;
  final TimeSelectCallback? onSelected;
  final double itemHeight;
  final TextStyle itemTextStyle;
  final Widget? wheelIndicator;

  final DateTimeItemBuilder? yearBuilder;
  final DateTimeItemBuilder? monthBuilder;
  final DateTimeItemBuilder? dayBuilder;
  final DateTimeItemBuilder? hourBuilder;
  final DateTimeItemBuilder? minuteBuilder;
  final DateTimeItemBuilder? secondBuilder;

  const WheelDatetimePickerPanel({
    super.key,
    this.mode = WheelDateTimePickerMode.date,
    this.selectedDateTime,
    this.title,
    this.minDateTime,
    this.maxDateTime,
    this.onSelected,
    this.itemHeight = 50,
    this.itemTextStyle = WheelDateTimePicker.defaultItemTextStyle,
    this.yearBuilder,
    this.monthBuilder,
    this.dayBuilder,
    this.hourBuilder,
    this.minuteBuilder,
    this.secondBuilder,
    this.wheelIndicator,
  });

  @override
  State<WheelDatetimePickerPanel> createState() => _WheelDatetimePickerPanelState();
}

class _WheelDatetimePickerPanelState extends State<WheelDatetimePickerPanel> {

  late DateTime selectedDateTime;

  @override
  void initState() {
    selectedDateTime = widget.selectedDateTime ?? DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              child: Text(WheelDatetimePickerPanel.cancelText(),
                style: TextStyle(
                  color: WheelDatetimePickerPanel.cancelColor(context),
                  fontSize: 15
                )
              ),
              onPressed: () => Navigator.pop(context),
            ),
            Text(widget.title?.call(selectedDateTime) ?? "",
              style: TextStyle(
                fontSize: FrameworkDimens().fontL,
                color: WheelDatetimePickerPanel.titleColor(context)
              ),
            ),
            TextButton(
              child: Text(WheelDatetimePickerPanel.confirmText(),
                style: TextStyle(
                  color: WheelDatetimePickerPanel.confirmColor(context),
                  fontSize: 15
                )
              ),
              onPressed: () {
                if (widget.onSelected != null) {
                  widget.onSelected?.call(selectedDateTime);
                }
                else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        Divider(
          height: 1,
          color: WheelDatetimePickerPanel.dividerColor(context),
        ),
        WheelDateTimePicker(
          height: 280,
          mode: widget.mode,
          selectedDateTime: widget.selectedDateTime,
          minDateTime: widget.minDateTime,
          maxDateTime: widget.maxDateTime,
          itemHeight: widget.itemHeight,
          itemTextStyle: widget.itemTextStyle,
          yearBuilder: widget.yearBuilder,
          monthBuilder: widget.monthBuilder,
          dayBuilder: widget.dayBuilder,
          hourBuilder: widget.hourBuilder,
          minuteBuilder: widget.minuteBuilder,
          secondBuilder: widget.secondBuilder,
          wheelIndicator: widget.wheelIndicator,
          onDateTimeSelected: (dateTime) {
            setState(() {
              selectedDateTime = dateTime;
            });
          },
        )
      ],
    );
  }
}
