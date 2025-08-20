import 'package:flutter/material.dart';
import 'package:flutter_uni_kit/dialogs/dialogs.dart';
import 'package:flutter_uni_kit/widgets/app_check_box.dart';
import 'package:flutter_uni_kit/widgets/input_widget.dart';

import '../../widgets/bottom_dialog_panel.dart';
import '../../widgets/indexed_select_list_panel.dart';
import 'app_form.dart';
import 'field_option.dart';

enum MultiSelectFormFieldDisplayStyle {
  textField,
  checkbox,
  ;
}

class MultiSelectFormField<T> extends FormField<List<T>> {

  final AppForm? form;
  final String? fieldName;
  final MultiSelectFormFieldDisplayStyle displayStyle;
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
  final ValueChanged<List<T>?>? onChanged;

  MultiSelectFormField({
    super.key,
    super.validator,
    super.initialValue,
    super.autovalidateMode,
    super.enabled,
    this.form,
    this.fieldName,
    this.displayStyle = MultiSelectFormFieldDisplayStyle.textField,
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
    builder: (FormFieldState<List<T>> field) {
      final _MultiSelectFormFieldState<T> state = field as _MultiSelectFormFieldState<T>;
      final String? errText = errorText ?? field.errorText;

      if (form != null && fieldName != null) {
        form.setNamedFields(fieldName, NamedFormItem<List<T>>(
          getter: () {
            return state.selectedValues.value;
          },
          setter: (value) {
            state.selectedValues.value = value;
          }
        ));
      }
      return ValueListenableBuilder(
        valueListenable: state.selectedValues,
        builder: (context, value, child) {
          if (displayStyle == MultiSelectFormFieldDisplayStyle.textField) {
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
                var selectedOptions = ValueNotifier(options.where((option) => state.selectedValues.value?.contains(option.value) ?? false).toList());
                BottomDialogPanel(
                  title: labelText,
                  rightButton: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      state.selectedValues.value = selectedOptions.value.isNotEmpty
                        ? selectedOptions.value.map((option) => option.value).toList()
                        : null;
                      state.controller.text = selectedOptions.value.isNotEmpty
                        ? selectedOptions.value.map((option) => option.label).join(", ")
                        : "";
                      field.didChange(state.selectedValues.value);
                      field.validate();
                      onChanged?.call(state.selectedValues.value);
                    },
                    child: const Text("Done")
                  ),
                  child: IndexedSelectListPanel(
                    showIndex: indexOptions,
                    sort: indexOptions ? IndexedSelectListPanel.defaultSort : null,
                    itemList: options.map((option) => IndexedListItem(
                      name: option.label,
                      itemBuilder: (String index, int position) => ValueListenableBuilder(
                        valueListenable: selectedOptions,
                        builder: (context, value, child) {
                          return Container(
                            margin: const EdgeInsets.only(left: 12),
                            height: 56,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              // color: Theme.of(context).scaffoldBackgroundColor,
                              border: Border(
                                bottom: BorderSide(
                                  color: Theme.of(context).dividerColor,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: AppCheckBox(
                              checked: selectedOptions.value.contains(options[position]),
                              onChanged: (value) {
                                List<Options<T>> newSelectedOptions = [];
                                newSelectedOptions.addAll(selectedOptions.value);
                                if (newSelectedOptions.contains(options[position])) {
                                  newSelectedOptions.remove(options[position]);
                                }
                                else {
                                  newSelectedOptions.add(options[position]);
                                }
                                selectedOptions.value = newSelectedOptions;
                              },
                              title: options[position].label,
                              titleTextStyle: inputConfigs.textStyle,
                            ),
                          );
                        }
                      ),
                    ))
                    .toList(),
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
                checked: state.selectedValues.value?.contains(option.value) == true,
                onChanged: (value) {
                  List<T>? selectedValues = [];
                  selectedValues.addAll(state.selectedValues.value ?? []);
                  if (selectedValues.contains(option.value)) {
                    selectedValues.remove(option.value);
                    if (selectedValues.isEmpty) {
                      selectedValues = null;
                    }
                  }
                  else {
                    selectedValues.add(option.value);
                  }
                  state.selectedValues.value = selectedValues;
                  field.didChange(state.selectedValues.value);
                  field.validate();
                  onChanged?.call(state.selectedValues.value);
                },
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
                  Text(
                    state.selectedValues.value
                    ?.map((value) {
                      for (var option in options) {
                        if (option.value == value) {
                          return option.label;
                        }
                        return value.toString();
                      }
                    })
                    .join(", ") ?? ""
                  ),
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
  FormFieldState<List<T>> createState() => _MultiSelectFormFieldState<T>();
}

class _MultiSelectFormFieldState<T> extends FormFieldState<List<T>> {

  late TextEditingController controller;
  final ValueNotifier<List<T>?> selectedValues = ValueNotifier(null);

  MultiSelectFormField<T> get _inputWidget => super.widget as MultiSelectFormField<T>;

  @override
  void initState() {
    super.initState();
    if (_inputWidget.options.isNotEmpty && _inputWidget.initialValue != null) {
      selectedValues.value = _inputWidget.initialValue;
    }
    final labelText = selectedValues.value
    ?.map((value) {
      for (var option in _inputWidget.options) {
        if (option.value == value) {
          return option.label;
        }
        return value.toString();
      }
    })
    .join(", ");
    controller = TextEditingController(text: labelText ?? "");
  }
}
