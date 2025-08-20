
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uni_kit/widgets/input_widget.dart';

import 'app_form.dart';

class TextInputFormField extends FormField<String> {

  final AppForm? form;
  final String? fieldName;
  final String Function(dynamic value)? formatter;
  final dynamic Function (String value)? parser;
  final TextEditingController? controller;
  final String hintText;
  final TextInputType keyboardType;
  final TextInputAction inputAction;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final String obscureCharacter;
  final LabelDirection labelDirection;
  final Widget? labelWidget;
  final String labelText;
  final Widget? prefixWidget;
  final String prefixText;
  final Widget? suffixWidget;
  final String suffixText;
  final ErrorTextController? errorTextController;
  final String? errorText;
  final int maxLines;
  final bool readOnly;
  final bool showClearButton;
  final GestureTapCallback? onTap;
  final InputConfigs inputConfigs;
  final EdgeInsetsGeometry? padding;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  TextInputFormField({
    super.key,
    super.validator,
    super.initialValue,
    super.autovalidateMode,
    super.enabled,
    this.form,
    this.fieldName,
    this.formatter,
    this.parser,
    this.controller,
    this.hintText = "",
    this.keyboardType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.obscureText = false,
    this.obscureCharacter = "•",
    this.labelDirection = LabelDirection.top,
    this.labelWidget,
    this.labelText = "",
    this.prefixWidget,
    this.prefixText = "",
    this.suffixWidget,
    this.suffixText = "",
    this.errorTextController,
    this.errorText,
    this.maxLines = 1,
    this.readOnly = false,
    this.showClearButton = false,
    this.onTap,
    this.inputConfigs = const InputConfigs(),
    this.padding,
    this.focusNode,
    this.onChanged,
  }): super(
    builder: (FormFieldState<String> field) {
      final _TextInputFormFieldState state = field as _TextInputFormFieldState;
      final String? errText = errorText ?? field.errorText;
      void onChangedHandler(String value) {
        field.didChange(value);
        onChanged?.call(value);
      }
      if (form != null && fieldName != null) {
        form.setNamedFields(fieldName, NamedFormItem<String>(
          getter: () {
            var value = state._effectiveController.text;
            if (parser != null) {
              value = parser(value);
            }
            return value;
          },
          setter: (value) {
            var setValue = value;
            if (formatter != null) {
              setValue = formatter(setValue);
            }
            state._effectiveController.text = setValue;
          }
        ));
      }
      return UnmanagedRestorationScope(
        child: InputWidget(
          controller: state._effectiveController,
          hintText: hintText,
          keyboardType: keyboardType,
          inputAction: inputAction,
          textDirection: textDirection,
          textAlign: textAlign,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          obscureCharacter: obscureCharacter,
          labelDirection: labelDirection,
          labelWidget: labelWidget,
          labelText: labelText,
          prefixWidget: prefixWidget,
          prefixText: prefixText,
          suffixWidget: suffixWidget,
          suffixText: suffixText,
          errorTextController: errorTextController,
          errorText: errText,
          maxLines: maxLines,
          readOnly: readOnly,
          enabled: enabled,
          showClearButton: showClearButton,
          onTap: onTap,
          inputConfigs: inputConfigs,
          padding: padding,
          focusNode: focusNode,
          onChanged: onChangedHandler,
        )
      );
    }
  );

  @override
  FormFieldState<String> createState() => _TextInputFormFieldState();
}

class _TextInputFormFieldState extends FormFieldState<String> {

  RestorableTextEditingController? _controller;

  TextEditingController get _effectiveController => _textInputFormField.controller ?? _controller!.value;

  TextInputFormField get _textInputFormField => super.widget as TextInputFormField;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(oldBucket, initialRestore);
    if (_controller != null) {
      _registerController();
    }
    // Make sure to update the internal [FormFieldState] value to sync up with
    // text editing controller value.
    setValue(_effectiveController.text);
  }

  void _registerController() {
    assert(_controller != null);
    registerForRestoration(_controller!, 'controller');
  }

  void _createLocalController([TextEditingValue? value]) {
    assert(_controller == null);
    _controller = RestorableTextEditingController(text: value?.text);
    _controller!.addListener(_handleControllerChanged);
    if (!restorePending) {
      _registerController();
    }
  }

  @override
  void initState() {
    super.initState();
    if (_textInputFormField.controller == null) {
      _createLocalController(
        widget.initialValue != null ? TextEditingValue(text: widget.initialValue!) : null,
      );
    } else {
      _textInputFormField.controller!.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(TextInputFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_textInputFormField.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      _textInputFormField.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && _textInputFormField.controller == null) {
        _createLocalController(oldWidget.controller!.value);
      }

      if (_textInputFormField.controller != null) {
        setValue(_textInputFormField.controller!.text);
        if (oldWidget.controller == null) {
          unregisterFromRestoration(_controller!);
          _controller!.dispose();
          _controller = null;
        }
      }
    }
  }

  @override
  void dispose() {
    _textInputFormField.controller?.removeListener(_handleControllerChanged);
    _controller?.removeListener(_handleControllerChanged);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChange(String? value) {
    super.didChange(value);

    if (_effectiveController.text != value) {
      _effectiveController.value = TextEditingValue(text: value ?? '');
    }
  }

  @override
  void reset() {
    // Set the controller value before calling super.reset() to let
    // _handleControllerChanged suppress the change.
    _effectiveController.value = TextEditingValue(text: widget.initialValue ?? '');
    super.reset();
    _textInputFormField.onChanged?.call(_effectiveController.text);
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController.text != value) {
      didChange(_effectiveController.text);
    }
  }
}

