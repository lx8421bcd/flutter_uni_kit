import 'package:flutter/material.dart';
import 'package:flutter_uni_kit/dialogs/dialogs.dart';
import 'package:flutter_uni_kit/widgets/input_widget.dart';
import 'package:flutter_uni_kit/widgets/wheel_datetime_picker.dart';
import 'package:flutter_uni_kit/widgets/wheel_datetime_picker_panel.dart';
import 'package:flutter_uni_kit/widgets/wheel_view.dart';
import 'package:intl/intl.dart';

import 'app_form.dart';


class DateSelectFormField extends FormField<DateTime> {

  final AppForm? form;
  final String? fieldName;
  final WheelDateTimePickerMode mode;
  final String displayFormat;
  final DateTime? maxDate;
  final DateTime? minDate;
  final DateTimeItemBuilder? yearBuilder;
  final DateTimeItemBuilder? monthBuilder;
  final DateTimeItemBuilder? dayBuilder;
  final DateTimeItemBuilder? hourBuilder;
  final DateTimeItemBuilder? minuteBuilder;
  final DateTimeItemBuilder? secondBuilder;
  final String hintText;
  final TextInputAction inputAction;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final bool obscureText;
  final String obscureCharacter;
  final LabelDirection labelDirection;
  final Widget? labelWidget;
  final String labelText;
  final ErrorTextController? errorTextController;
  final String? errorText;
  final bool readOnly;
  final bool showClearButton;
  final InputConfigs inputConfigs;
  final EdgeInsetsGeometry? padding;
  final FocusNode? focusNode;
  final ValueChanged<DateTime?>? onChanged;

  DateSelectFormField({
    super.key,
    super.validator,
    super.initialValue,
    super.autovalidateMode,
    super.enabled,
    this.form,
    this.fieldName,
    this.mode = WheelDateTimePickerMode.date,
    this.displayFormat = "yyyy-MM-dd",
    this.maxDate,
    this.minDate,
    this.yearBuilder,
    this.monthBuilder,
    this.dayBuilder,
    this.hourBuilder,
    this.minuteBuilder,
    this.secondBuilder,
    this.hintText = "",
    this.inputAction = TextInputAction.next,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.obscureText = false,
    this.obscureCharacter = "•",
    this.labelDirection = LabelDirection.top,
    this.labelWidget,
    this.labelText = "",
    this.errorTextController,
    this.errorText,
    this.readOnly = false,
    this.showClearButton = false,
    this.inputConfigs = const InputConfigs(),
    this.padding,
    this.focusNode,
    this.onChanged,

  }): super (
    builder: (FormFieldState<DateTime> field) {
      final _SingleSelectFormFieldState state = field as _SingleSelectFormFieldState;
      final String? errText = errorText ?? field.errorText;

      if (form != null && fieldName != null) {
        form.setNamedFields(fieldName, NamedFormItem<DateTime>(
            getter: () {
              return state.selectedDateTime.value;
            },
            setter: (value) {
              state.selectedDateTime.value = value;
            }
        ));
      }
      return ValueListenableBuilder(
        valueListenable: state.selectedDateTime,
        builder: (context, value, child) => InputWidget(
          labelText: labelText,
          hintText: hintText,
          controller: state.controller,
          errorTextController: errorTextController,
          errorText: errText,
          padding: const EdgeInsets.symmetric(vertical: 10),
          readOnly: true,
          obscureText: obscureText,
          suffixWidget: !readOnly
              ? const Icon(Icons.arrow_forward_ios, size: 12)
              : null,
          onTap: !readOnly
          ? () {
            WheelDatetimePickerPanel(
              wheelIndicator: WheelView.defaultMaskedIndicator,
              mode: WheelDateTimePickerMode.date,
              selectedDateTime: initialValue,
              maxDateTime: maxDate,
              minDateTime: minDate,
              yearBuilder: yearBuilder,
              monthBuilder: monthBuilder,
              dayBuilder: dayBuilder,
              hourBuilder: hourBuilder,
              minuteBuilder: minuteBuilder,
              secondBuilder: secondBuilder,
              title: (selected) {
                var str = DateFormat(displayFormat, "en_US").format(selected);
                return str;
              },
              onSelected: (selected) {
                Navigator.pop(context);
                state.selectedDateTime.value = selected;
                state.controller.text = DateFormat(displayFormat, "en_US").format(selected);
                field.didChange(state.selectedDateTime.value);
                field.validate();
                onChanged?.call(state.selectedDateTime.value);
              },
            ).showAsBottomDialogContent();
          }
              : null,
        )
      );
    }
  );

  @override
  FormFieldState<DateTime> createState() => _SingleSelectFormFieldState();
}

class _SingleSelectFormFieldState extends FormFieldState<DateTime> {

  late TextEditingController controller;
  final ValueNotifier<DateTime?> selectedDateTime = ValueNotifier(null);

  DateSelectFormField get _inputWidget => super.widget as DateSelectFormField;

  @override
  void initState() {
    super.initState();
    var initialValue = _inputWidget.initialValue;
    if (initialValue != null) {
      selectedDateTime.value = initialValue;
      controller = TextEditingController(text: DateFormat(_inputWidget.displayFormat, "en_US").format(initialValue));
    }
  }
}
