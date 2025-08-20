import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uni_kit/dialogs/dialogs.dart';
import 'package:flutter_uni_kit/widgets/input_widget.dart';
import 'package:get/get.dart';

import '../../widgets/bottom_dialog_panel.dart';
import '../../widgets/indexed_select_list_panel.dart';
import 'app_form.dart';

class PhoneLocaleInfo {

  String code;
  String isoCode;
  String Function() name;
  int maxLength;

  PhoneLocaleInfo({
    required this.code,
    required this. isoCode,
    required this.name,
    this.maxLength = 0,
  });

  @override
  String toString() {
    return 'PhoneLocaleInfo{code: $code, isoCode: $isoCode, name: $name, maxLength: $maxLength}';
  }

}


class PhoneNumberInputFormField extends FormField<String> {

  final AppForm? form;
  final String? fieldName;
  final String? localeFieldName;
  final List<PhoneLocaleInfo> locales;
  final String? initialLocaleCode;
  final TextEditingController? controller;
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
  final GestureTapCallback? onTap;
  final InputConfigs inputConfigs;
  final EdgeInsetsGeometry? padding;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  
  PhoneNumberInputFormField({
    super.key,
    super.validator,
    super.initialValue,
    super.autovalidateMode,
    super.enabled,
    this.form,
    this.fieldName,
    this.localeFieldName,
    this.locales = const <PhoneLocaleInfo>[],
    this.initialLocaleCode,
    this.controller,
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
    this.onTap,
    this.inputConfigs = const InputConfigs(),
    this.padding,
    this.focusNode,
    this.onChanged,
    
  }): super (
    builder: (FormFieldState<String> field) {
      final _PhoneNumberInputFormFieldState state = field as _PhoneNumberInputFormFieldState;
      final selectedCountryCode = state.selectedCountryCode;
      final String? errText = errorText ?? field.errorText;
      void onChangedHandler(String value) {
        field.didChange(value);
        onChanged?.call(value);
      }
      if (form != null && fieldName != null) {
        form.setNamedFields(fieldName, NamedFormItem<String>(
            getter: () {
              var value = state.controller.text;
              return value;
            },
            setter: (value) {
              state.controller.text = value;
            }
        ));
        if (localeFieldName != null) {
          form.setNamedFields(localeFieldName, NamedFormItem<PhoneLocaleInfo>(
              getter: () {
                var value = state.selectedCountryCode.value;
                return value;
              },
              setter: (value) {
                state.selectedCountryCode.value = value;
              }
          ));
        }
      }
      return ValueListenableBuilder(
          valueListenable: selectedCountryCode,
          builder: (context, value, child) => InputWidget(
            controller: state.controller,
            hintText: hintText,
            inputAction: inputAction,
            textDirection: textDirection,
            textAlign: textAlign,
            obscureText: obscureText,
            obscureCharacter: obscureCharacter,
            labelDirection: labelDirection,
            labelWidget: labelWidget,
            labelText: labelText,
            errorTextController: errorTextController,
            errorText: errText,
            readOnly: readOnly,
            enabled: enabled,
            showClearButton: showClearButton,
            onTap: onTap,
            inputConfigs: inputConfigs,
            padding: padding,
            focusNode: focusNode,
            onChanged: onChangedHandler,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              ...((selectedCountryCode.value?.maxLength ?? 0) > 0 ? [
                LengthLimitingTextInputFormatter(selectedCountryCode.value!.maxLength),
              ] : [])
            ],
            prefixWidget: locales.isNotEmpty
                ? InkWell(
              onTap: locales.length > 1 ? () {
                BottomDialogPanel(
                  title: "",
                  child: IndexedSelectListPanel(
                    itemList: locales.map((item) => IndexedListItem(
                        name: "${item.name()} \t +${item.code}",
                        selectCallback: () {
                          Navigator.pop(context);
                          selectedCountryCode.value = item;
                        })
                    ).toList(),
                    showSearch: false,
                  ),
                ).showAsBottomDialogContent();
              } : null,
              child:  Container(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  "+${selectedCountryCode.value?.code}",
                  style: inputConfigs.textStyle,
                ),
              ),
            )
                : null,
          )
      );
    }
  );

  @override
  FormFieldState<String> createState() => _PhoneNumberInputFormFieldState();
}

class _PhoneNumberInputFormFieldState extends FormFieldState<String> {

  late TextEditingController controller;
  final ValueNotifier<PhoneLocaleInfo?> selectedCountryCode = ValueNotifier(null);

  PhoneNumberInputFormField get _inputWidget => super.widget as PhoneNumberInputFormField;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
    if (_inputWidget.locales.isNotEmpty) {
      selectedCountryCode.value = _inputWidget.locales.firstWhereOrNull((item) => item.code == _inputWidget.initialLocaleCode) ?? _inputWidget.locales.first;
    }
  }
}
