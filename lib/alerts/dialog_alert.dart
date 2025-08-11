import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_uni_kit/dialogs/dialogs.dart';
import 'package:flutter_uni_kit/dialogs/popup_window.dart';
import 'package:flutter_uni_kit/theme/framework_dimens.dart';
import 'package:flutter_uni_kit/widgets/border_button.dart';
import 'package:get/get.dart';

class ButtonConfig {
  String name;
  VoidCallback action;
  bool negative;
  TextStyle? textStyle;

  ButtonConfig(this.name, this.action, this.negative, this.textStyle);
}

abstract class ActionBuilder {

  Widget build(BuildContext context, bool verticalOrientation, List<ButtonConfig> configs);

}

class DefaultActionBuilder implements ActionBuilder {

  Color? Function(BuildContext context) positiveColor = (context) {
    return Theme.of(context).primaryColor;
  };

  Color? Function(BuildContext context) negativeColor = (context) {
    return Theme.of(context).disabledColor;
  };

  @override
  Widget build(BuildContext context, bool verticalOrientation, List<ButtonConfig> configs) {
    var buttonList = configs.map((config) {
      var defaultColor = config.negative ? negativeColor(context) : positiveColor(context);
      return Padding(
        padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
        child: BorderButton(
            height: 40,
            minWidth: 150,
            color: config.textStyle?.color ?? defaultColor,
            onPressed: config.action,
            child: Text(
              config.name,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            )
        ),
      );
    }).toList();
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: verticalOrientation
      ? Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: buttonList,
      )
      : Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: buttonList.map((button) =>
            Expanded(
              child: Center(
                child: button,
              )
            )
          ).toList()
        ),
    );
  }
}

class DefaultSingleSelectActionBuilder implements ActionBuilder {

  Color? Function(BuildContext context) positiveColor = (context) {
    return Theme.of(context).primaryColor;
  };

  Color? Function(BuildContext context) negativeColor = (context) {
    return Theme.of(context).disabledColor;
  };

  @override
  Widget build(BuildContext context, bool verticalOrientation, List<ButtonConfig> configs) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: configs.map((config) {
          var defaultColor = config.negative ? negativeColor(context) : positiveColor(context);
          var textStyle = config.textStyle ??  TextStyle(fontSize: FrameworkDimens().fontM);
          return TextButton(
              style: TextButton.styleFrom(
                foregroundColor: config.textStyle?.color ?? defaultColor,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero
                ),
                minimumSize: const Size(double.infinity, 40),
                padding: const EdgeInsets.only(top: 12, bottom: 12),
              ),
              onPressed: config.action,
              child: Text(config.name, style: textStyle)
          );
        }).toList()
    );
  }
}

/// 弹窗样式提醒消息构建工具
///
/// @author linxiao
/// @since 2023-11-01
class DialogAlert {

  static String Function() defaultPositiveText = () {
    return "OK";
  };

  static DefaultActionBuilder defaultActionBuilder = DefaultActionBuilder();
  static DefaultSingleSelectActionBuilder defaultSingleSelectActionBuilder = DefaultSingleSelectActionBuilder();

  bool singleSelectStyle = false;
  bool verticalActionOrientation = false;
  bool cancelable = true;
  ActionBuilder? actionBuilder;

  Widget? _title;
  Widget? _content;
  final List<ButtonConfig> _actionConfigs = [];

  void setTitle(String title) {
    _title = Text(title, style: TextStyle(fontSize: FrameworkDimens().fontXL));
  }

  void setMessage(String message) {
    _content = Text(message, style: TextStyle(fontSize: FrameworkDimens().fontM));
  }

  void setContent(Widget content) {
    _content = content;
  }

  /// [negative] 否定样式，显示应用默认的取消按钮样式 <br/>
  /// [actionTextStyle] 指定文字样式，只有单选列表样式和BorderButton样式时才会生效
  void setAction({
    required String actionText,
    required VoidCallback action,
    bool negative = false,
    TextStyle? actionTextStyle,
  }) {
    _actionConfigs.add(ButtonConfig(actionText, action, negative, actionTextStyle));
  }

  Widget getDialogPanel([BuildContext? context]) {
    if (_actionConfigs.isEmpty) {
      setAction(
          actionText: defaultPositiveText(),
          action: () => Get.back()
      );
    }
    return _buildDialogContent(context);
  }

  Future<T?> show<T>([BuildContext? context]) {
    return getDialogPanel(context)
        .showAsCommonDialogContent<T>(context: context, cancelable: cancelable);
  }

  Future<T?> showBottom<T>([BuildContext? context]) {
    return getDialogPanel(context)
        .showAsBottomDialogContent<T>(context: context, cancelable: cancelable);
  }

  Future<T?> showPopup<T>({
    required GlobalKey targetKey,
    BuildContext? context,
    double popupWidth = 160}) {
    singleSelectStyle = true;
    verticalActionOrientation = true;
    return Container(
      width: popupWidth,
      constraints: BoxConstraints(
          minWidth: 40,
          maxWidth: ScreenUtil().screenWidth
      ),
      child: Column(
        children: [
          SizedBox(height: _title != null || _content != null ? 8 : 0),
          Padding(
            padding: EdgeInsets.only(
                left: FrameworkDimens().paddingBoth,
                right: FrameworkDimens().paddingBoth
            ),
            child: _title,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: FrameworkDimens().paddingBoth,
                right: FrameworkDimens().paddingBoth),
            child: _content,
          ),
          SizedBox(height: _title != null || _content != null ? 8 : 0),
          _buildActionButtons(context),
        ],
      ),
    ).showAsPopupWindowContent<T>(
        context: context, targetKey: targetKey, cancelable: cancelable);
  }

  Widget _buildDialogContent(BuildContext? context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: EdgeInsets.only(
              left: FrameworkDimens().paddingBoth,
              right: FrameworkDimens().paddingBoth
          ),
          child: _title,
        ),
        SizedBox(height: _title != null ? 24 : 0),
        _content != null
            ? Container(
          width: double.infinity,
          constraints: BoxConstraints(
              minHeight: 40, maxHeight: ScreenUtil().screenHeight * 0.7),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                left: FrameworkDimens().paddingBoth,
                right: FrameworkDimens().paddingBoth),
            scrollDirection: Axis.vertical,
            child: Center(
              child: _content,
            ),
          ),
        )
            :
        const SizedBox(),
        SizedBox(height: _content != null ? 24 : 0),
        _buildActionButtons(context ?? Get.context!),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext? context) {
    if (_actionConfigs.isEmpty) {
      return const SizedBox();
    }
    if (singleSelectStyle == false) {
      // 有提示文案且按钮小于3个，确认样式, 否则单选样式
      singleSelectStyle = (_title == null && _content == null) || _actionConfigs.length > 2;
    }
    if (verticalActionOrientation == false) {
      verticalActionOrientation = singleSelectStyle;
    }
    var buttonBuilder = actionBuilder ?? (
        singleSelectStyle
            ? defaultSingleSelectActionBuilder
            : defaultActionBuilder
    );
    return buttonBuilder.build(context ?? Get.context!, verticalActionOrientation, _actionConfigs);
  }
}