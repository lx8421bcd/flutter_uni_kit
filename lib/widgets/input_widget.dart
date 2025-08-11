import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_uni_kit/theme/framework_dimens.dart';

enum LabelDirection {
  top,
  start,
  material,
}

class ErrorTextController {

  void Function(bool hasFocus, String text)? onEditingStatusChanged;

  String? _text;
  _InputWidgetState? _state;

  set text(String? text) {
    _text = text;
    _state?.refresh();
  }
  String? get text => _text;

}

class InputWidget extends StatefulWidget {

  /// 默认颜色样式配置
  static InputConfigs Function(BuildContext context) defaultInputConfigs = (context) {
    return InputConfigs(
      textStyle: TextStyle(
        fontSize: FrameworkDimens().fontM,
      ),
      labelTextStyle: TextStyle(
        fontSize: FrameworkDimens().fontL,
      ),
      hintTextStyle: TextStyle(
          fontSize: FrameworkDimens().fontM
      ),
      prefixTextStyle: TextStyle(
        fontSize: FrameworkDimens().fontL,
      ),
      suffixTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: FrameworkDimens().fontXL,
      )
    );
  };
  /// 默认清空按钮配置
  static Widget Function(BuildContext context) defaultClearButton = (context) {
    return const Icon(
      Icons.cancel,
      size: 20,
      color: Colors.grey,
    );
  };
  final TextEditingController controller;
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
  final bool enabled;
  final bool showClearButton;
  final GestureTapCallback? onTap;
  final InputConfigs inputConfigs;
  final EdgeInsetsGeometry? padding;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  const InputWidget({
    super.key,
    required this.controller,
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
    this.enabled = true,
    this.showClearButton = false,
    this.onTap,
    this.inputConfigs = const InputConfigs(),
    this.padding,
    this.focusNode,
    this.onChanged,
  });

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {

  late InputBorder defaultBorder;
  late InputConfigs defaultInputConfigs;
  late FocusNode focusNode;

  void onEditingStatusChanged () {
    widget.errorTextController?.onEditingStatusChanged?.call(
      focusNode.hasFocus,
      widget.controller.text
    );
  }

  @override
  void initState() {
    super.initState();
    widget.errorTextController?._state = this;
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(() {
      onEditingStatusChanged();
    });
    widget.controller.addListener(onEditingStatusChanged);
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    widget.errorTextController?._state = null;
    widget.controller.removeListener(onEditingStatusChanged);
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.errorText != null) {
      widget.errorTextController?._text = widget.errorText;
    }
    defaultInputConfigs = InputWidget.defaultInputConfigs(context);
    defaultBorder = widget.inputConfigs.border ?? UnderlineInputBorder(
        borderSide: BorderSide(
          color: widget.inputConfigs.borderColor
              ?? defaultInputConfigs.borderColor
              ?? Colors.transparent,
        )
    );
    var label = () {
      if (widget.labelWidget != null) {
        return widget.labelWidget;
      }
      if (widget.labelText.isNotEmpty) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.labelText,
              textAlign: TextAlign.left,
              style: widget.inputConfigs.labelTextStyle ?? defaultInputConfigs.labelTextStyle,
            ),
          ),
        );
      }
      return null;
    }.call();
    var textField = TextField(
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      onTap: widget.onTap,
      obscureText: widget.obscureText,
      obscuringCharacter: widget.obscureCharacter,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      controller: widget.controller,
      textInputAction: widget.inputAction,
      focusNode: focusNode,
      textDirection: widget.textDirection,
      textAlign: widget.textAlign,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      style: widget.inputConfigs.textStyle ?? defaultInputConfigs.textStyle,
      decoration: InputDecoration(
        isDense: true, // 用于缩小上下边距
        label: widget.labelDirection == LabelDirection.material ? label : null,
        hintText: widget.hintText,
        hintStyle: widget.inputConfigs.hintTextStyle ?? defaultInputConfigs.hintTextStyle,
        errorText: widget.errorTextController != null ? widget.errorTextController?.text : widget.errorText,
        prefixIcon: _buildPrefixWidget(),
        prefixIconConstraints: const BoxConstraints(
          minHeight: 0,
          minWidth: 0
        ),
        suffixIcon: _buildSuffixWidget(),
        suffixIconConstraints: const BoxConstraints(
          minHeight: 0,
          minWidth: 0
        ),
        border: widget.inputConfigs.border ?? defaultBorder,
        enabledBorder: widget.inputConfigs.border ?? defaultBorder,
        disabledBorder: widget.inputConfigs.disabledBorder ?? defaultBorder,
        focusedBorder: widget.inputConfigs.focusedBorder ?? defaultBorder,
        filled: true,
        fillColor: () {
          var defaultColor = widget.inputConfigs.backgroundColor ?? Colors.transparent;
          if (focusNode.hasFocus) {
            return widget.inputConfigs.focusedBackgroundColor ?? defaultColor;
          }
          if (!widget.enabled) {
            return widget.inputConfigs.disabledBackgroundColor ?? defaultColor;
          }
          return defaultColor;
        }.call(),
        contentPadding: widget.inputConfigs.contentPadding,
      ),
    );
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: () {
        if (widget.labelDirection == LabelDirection.top && label != null) {
          return Column(
            children: [
              label,
              textField,
            ],
          );
        }
        if (widget.labelDirection == LabelDirection.start && label != null) {
          return Row(
            children: [
              label,
              Expanded(
                child: textField
              ),
            ],
          );
        }
        return textField;
      }.call(),
    );
  }

  Widget? _buildPrefixWidget() {
    Widget? prefix;
    if (widget.prefixWidget != null) {
      prefix = widget.prefixWidget!;
    }
    if (widget.prefixText.isNotEmpty) {
      prefix = Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(
          widget.prefixText,
          style: widget.inputConfigs.prefixTextStyle ?? defaultInputConfigs.prefixTextStyle,
        )
      );
    }
    if (prefix != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          prefix,
          SizedBox(width: widget.inputConfigs.prefixPaddingContent),
        ],
      );
    }
    return null;
  }

  Widget? _buildSuffixWidget() {
    var suffixExtra = widget.suffixWidget;
    if (suffixExtra == null && widget.suffixText.isNotEmpty) {
      suffixExtra = Padding(
        padding: EdgeInsets.only(right: 0.w),
        child: Text(
          widget.suffixText,
          style: widget.inputConfigs.suffixTextStyle ?? defaultInputConfigs.suffixTextStyle,
        ),
      );
    }
    var clearButton = widget.showClearButton ? _ClearButton(
      textController: widget.controller,
      focusNode: focusNode,
    ) : null;
    if (clearButton != null || suffixExtra != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: widget.inputConfigs.suffixPaddingContent),
          clearButton ?? const SizedBox(),
          suffixExtra ?? const SizedBox(),
        ],
      );
    }
    return null;
  }
}

class _ClearButton extends StatefulWidget {

  final TextEditingController textController;
  final FocusNode focusNode;

  const _ClearButton({
    required this.textController,
    required this.focusNode
  });

  @override
  State<_ClearButton> createState() => _ClearButtonState();
}

class _ClearButtonState extends State<_ClearButton> {

  bool show = false;

  void Function() checkListener = () {};

  void checkShowButton() {
    bool shouldShow = widget.focusNode.hasFocus && widget.textController.text.isNotEmpty;
    if (show != shouldShow) {
      setState(() {
        show = shouldShow;
      });
    }
  }

  @override
  void initState() {
    checkListener = () {
      checkShowButton();
    };
    widget.focusNode.addListener(checkListener);
    widget.textController.addListener(checkListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.textController.removeListener(checkListener);
    widget.focusNode.removeListener(checkListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return show ? SizedBox(
      width: 30,
      height: 30,
      child: InkWell(
        onTap: () {
          widget.textController.clear();
        },
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: InputWidget.defaultClearButton(context),
      ),
    ) : const SizedBox();
  }
}

class InputConfigs {

  final TextStyle? textStyle;
  final TextStyle? labelTextStyle;
  final TextStyle? hintTextStyle;
  final TextStyle? prefixTextStyle;
  final TextStyle? suffixTextStyle;

  final Color? borderColor;
  final InputBorder? border;
  final InputBorder? disabledBorder;
  final InputBorder? focusedBorder;

  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final Color? focusedBackgroundColor;

  final EdgeInsetsGeometry contentPadding; // 注意，在设置了prefix和suffix之后，水平方向的padding将不再生效
  final double? prefixPaddingContent;
  final double? suffixPaddingContent;

  const InputConfigs({
    this.textStyle,
    this.labelTextStyle,
    this.hintTextStyle,
    this.prefixTextStyle,
    this.suffixTextStyle,
    this.borderColor,
    this.border,
    this.disabledBorder,
    this.focusedBorder,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.focusedBackgroundColor,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 4),
    this.prefixPaddingContent,
    this.suffixPaddingContent,
  });

  InputConfigs copyFrom({
    TextStyle? textStyle,
    TextStyle? labelTextStyle,
    TextStyle? hintTextStyle,
    TextStyle? prefixTextStyle,
    TextStyle? suffixTextStyle,
    Color? borderColor,
    InputBorder? border,
    InputBorder? disabledBorder,
    InputBorder? focusedBorder,
    Color? backgroundColor,
    Color? disabledBackgroundColor,
    Color? focusedBackgroundColor,
    EdgeInsetsGeometry? contentPadding,
    double? prefixPaddingContent,
    double? suffixPaddingContent,
  }) {
    return InputConfigs(
      textStyle: textStyle ?? this.textStyle,
      labelTextStyle: labelTextStyle ?? this.labelTextStyle,
      hintTextStyle: hintTextStyle ?? this.hintTextStyle,
      prefixTextStyle: prefixTextStyle ?? this.prefixTextStyle,
      suffixTextStyle: suffixTextStyle ?? this.suffixTextStyle,
      borderColor: borderColor ?? this.borderColor,
      border: border ?? this.border,
      disabledBorder: disabledBorder ?? this.disabledBorder,
      focusedBorder: focusedBorder ?? this.focusedBorder,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      disabledBackgroundColor: disabledBackgroundColor ?? this.disabledBackgroundColor,
      focusedBackgroundColor: focusedBackgroundColor ?? this.focusedBackgroundColor,
      contentPadding: contentPadding ?? this.contentPadding,
      prefixPaddingContent: prefixPaddingContent ?? this.prefixPaddingContent,
      suffixPaddingContent: suffixPaddingContent ?? this.suffixPaddingContent,
    );
  }

}
