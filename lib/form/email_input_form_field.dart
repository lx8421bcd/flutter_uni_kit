import 'package:flutter/services.dart';
import 'package:flutter_uni_kit/widgets/input_widget.dart';
import 'text_input_form_field.dart';


class EmailInputInputFormField extends TextInputFormField {

  EmailInputInputFormField({
    super.key,
    super.validator,
    super.initialValue,
    super.autovalidateMode,
    super.enabled,
    super.form,
    super.fieldName,
    super.controller,
    super.hintText = "",
    super.inputAction = TextInputAction.next,
    super.textDirection,
    super.textAlign = TextAlign.start,
    super.obscureText = false,
    super.obscureCharacter = "•",
    super.labelDirection = LabelDirection.top,
    super.labelWidget,
    super.labelText = "",
    super.errorTextController,
    super.errorText,
    super.readOnly = false,
    super.showClearButton = false,
    super.onTap,
    super.inputConfigs = const InputConfigs(),
    super.padding,
    super.focusNode,
    super.onChanged,

  }): super (
    keyboardType: TextInputType.emailAddress,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')),
    ],
  );

}
