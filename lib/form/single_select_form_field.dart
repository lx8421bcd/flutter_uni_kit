import 'package:flutter/material.dart';
import 'package:flutter_uni_kit/dialogs/dialogs.dart';
import 'package:flutter_uni_kit/widgets/app_check_box.dart';
import 'package:flutter_uni_kit/widgets/input_widget.dart';

import '../../widgets/bottom_dialog_panel.dart';
import '../../widgets/indexed_select_list_panel.dart';
import 'app_form.dart';
import 'field_option.dart';

enum SingleSelectFormFieldDisplayStyle {
  textField,
  radio,
  checkbox,
  ;
}

class SingleSelectFormField<T> extends FormField<T> {

  final AppForm? form;
  final String? fieldName;
  final SingleSelectFormFieldDisplayStyle displayStyle;
  final List<Options<T>> options;
  final bool indexOptions;
  final CheckBoxBuilder? checkBoxBuilder;
  final bool displayLabelOnReadOnly;
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
  final ValueChanged<T>? onChanged;

  SingleSelectFormField({
    super.key,
    super.validator,
    super.initialValue,
    super.autovalidateMode,
    super.enabled,
    this.form,
    this.fieldName,
    this.displayStyle = SingleSelectFormFieldDisplayStyle.textField,
    this.options = const [],
    this.indexOptions = false,
    this.checkBoxBuilder,
    this.displayLabelOnReadOnly = false,
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
    builder: (FormFieldState<T> field) {
      final _SingleSelectFormFieldState state = field as _SingleSelectFormFieldState;
      final String? errText = errorText ?? field.errorText;

      if (form != null && fieldName != null) {
        form.setNamedFields(fieldName, NamedFormItem<T>(
          getter: () {
            return state.selectedValue.value;
          },
          setter: (value) {
            state.selectedValue.value = value;
          }
        ));
      }
      return ValueListenableBuilder(
        valueListenable: state.selectedValue,
        builder: (context, value, child) {
          if (displayStyle == SingleSelectFormFieldDisplayStyle.textField) {
            return InputWidget(
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
                BottomDialogPanel(
                  title: labelText,
                  child: IndexedSelectListPanel(
                    showIndex: indexOptions,
                    sort: indexOptions ? IndexedSelectListPanel.defaultSort : null,
                    itemList: options.map((item) => IndexedListItem(
                      name: item.label,
                      selectCallback: () {
                        Navigator.pop(context);
                        state.selectedValue.value = item.value;
                        state.controller.text = item.label;
                        field.didChange(state.selectedValue.value);
                        field.validate();
                        onChanged?.call(state.selectedValue.value);
                      })
                    ).toList(),
                    showSearch: false,
                  ),
                ).showAsBottomDialogContent();
              }
              : null,
            );
          }
          var label = () {
            if (labelWidget != null) {
              return labelWidget;
            }
            if (labelText.isNotEmpty) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    labelText,
                    textAlign: TextAlign.left,
                    style: inputConfigs.labelTextStyle ?? InputWidget.defaultInputConfigs(context).labelTextStyle,
                  ),
                ),
              );
            }
            return null;
          }.call();
          Widget content = Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Wrap(
              spacing: 8,
              children: options.map((option) => AppCheckBox(
                checkBoxBuilder: () {
                  if (checkBoxBuilder != null) {
                    return checkBoxBuilder;
                  }
                  if (displayStyle == SingleSelectFormFieldDisplayStyle.radio) {
                    return (context, checked) {
                      return SizedBox(
                        width: inputConfigs.textStyle?.fontSize ?? 20,
                        height: inputConfigs.textStyle?.fontSize ?? 20,
                        child: Radio<T>(
                          value: option.value,
                          groupValue: state.selectedValue.value,
                          onChanged: null,
                          fillColor: WidgetStateProperty.resolveWith(
                            (states) => states.contains(WidgetState.selected)
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                          )
                        )
                      );
                    };
                  }
                  return null;
                }(),
                checked: state.selectedValue.value == option.value,
                onChanged: !readOnly ? (value) {
                  state.selectedValue.value = option.value;
                  field.didChange(state.selectedValue.value);
                  field.validate();
                  onChanged?.call(state.selectedValue.value);
                } : null,
                title: option.label,
                titleTextStyle: inputConfigs.textStyle,
              )).toList(),
            ),
          );
          if (readOnly && displayLabelOnReadOnly) {
            content = Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Wrap(
                children: [
                  Text(() {
                    for (var option in options) {
                      if (option.value == state.selectedValue.value) {
                        return option.label;
                      }
                    }
                    return state.selectedValue.value.toString();
                  }()),
                ],
              ),
            );
          }
          Widget errorTextWidget = errText != null
          ? SizedBox(
            width: double.infinity,
            child: Text(
              errText,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          )
          : const SizedBox();
          return Padding(
            padding: padding ?? EdgeInsets.zero,
            child: () {
              if (labelDirection == LabelDirection.top && label != null) {
                return Column(
                  children: [
                    label,
                    content,
                    errorTextWidget
                  ],
                );
              }
              if (labelDirection == LabelDirection.start && label != null) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: label,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          content,
                          errorTextWidget
                        ],
                      )
                    ),
                  ],
                );
              }
              return content;
            }.call(),
          );
        }
      );
    }
  );

  @override
  FormFieldState<T> createState() => _SingleSelectFormFieldState<T>();
}

class _SingleSelectFormFieldState<T> extends FormFieldState<T> {

  late TextEditingController controller;
  final ValueNotifier<T?> selectedValue = ValueNotifier(null);

  SingleSelectFormField get _inputWidget => super.widget as SingleSelectFormField;

  @override
  void initState() {
    super.initState();
    selectedValue.value = _inputWidget.initialValue;
    controller = TextEditingController(text: () {
      for (var option in _inputWidget.options) {
        if (option.value == selectedValue.value) {
          return option.label;
        }
      }
      return selectedValue.value.toString();
    }());
  }
}
