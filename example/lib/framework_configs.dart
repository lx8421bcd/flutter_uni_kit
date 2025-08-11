import 'package:example/themes/app_colors.dart';
import 'package:example/generated/l10n.dart';
import 'package:example/themes/dimens.dart';
import 'package:example/themes/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uni_kit/alerts/dialog_alert.dart';
import 'package:flutter_uni_kit/permission/permission_functions.dart';
import 'package:flutter_uni_kit/theme/framework_colors.dart';
import 'package:flutter_uni_kit/theme/framework_dimens.dart';
import 'package:flutter_uni_kit/widgets/app_check_box.dart';
import 'package:flutter_uni_kit/widgets/border_button.dart';
import 'package:flutter_uni_kit/widgets/color_button.dart';
import 'package:flutter_uni_kit/widgets/gradient_button.dart';
import 'package:flutter_uni_kit/widgets/input_widget.dart';
import 'package:flutter_uni_kit/widgets/navigation_bar.dart';
import 'package:flutter_uni_kit/widgets/setting_item.dart';
import 'package:flutter_uni_kit/widgets/shadow_card.dart';
import 'package:flutter_uni_kit/widgets/wheel_datetime_picker_panel.dart';

void initFrameworkConfigs() {
  /// Framework全局配置初始化
  FrameworkColors.instance = FrameworkColorsEx();
  FrameworkDimens.instance = FrameworkDimensEx();

  /// Permission 全局配置
  PermissionRestrictedHint.title = () => AppLocalizations().attention;
  // PermissionRestrictedHint.defaultHint = () => AppLocalizations().alertPermissionPermanentlyDenied;
  // PermissionRestrictedHint.goSettings = () => AppLocalizations().actionGoSettings;
  PermissionRestrictedHint.cancel = () => AppLocalizations().cancel;

  /// ShadowCard配置
  ShadowCard.defaultForegroundColor = (BuildContext context) {
    return AppColors.colorButtonForeground.get();
  };
  ShadowCard.defaultForegroundColor = (BuildContext context) {
    return Colors.black.withAlpha(20);
  };

  /// GradientButton 配置
  GradientButton.defaultBorderRadius = BorderRadius.circular(GlobalDimens.submitButtonRadius);
  GradientButton.defaultEnabledGradient = (BuildContext context) {
    return actionButtonEnabled;
  };
  GradientButton.defaultDisabledGradient = (BuildContext context) {
    return actionButtonDisabled;
  };

  /// ColorButton配置
  ColorButton.defaultBorderRadius = BorderRadius.circular(GlobalDimens.submitButtonRadius);
  ColorButton.defaultForegroundColor = (BuildContext context) {
    return AppColors.colorButtonForeground.get();
  };
  ColorButton.defaultForegroundColorDisabled = (BuildContext context) {
    return AppColors.colorButtonForegroundDisabled.get();
  };
  ColorButton.defaultBackgroundColor = (BuildContext context) {
    return AppColors.colorButtonBackground.get();
  };
  ColorButton.defaultBackgroundColorDisabled = (BuildContext context) {
    return AppColors.colorButtonBackgroundDisabled.get();
  };

  /// BorderButton配置
  BorderButton.defaultBorderRadius = BorderRadius.circular(GlobalDimens.submitButtonRadius);
  BorderButton.defaultColor = (BuildContext context) {
    return AppColors.textButton.get();
  };
  BorderButton.defaultColorDisabled = (BuildContext context) {
    return AppColors.textButtonDisabled.get();
  };

  /// AppCheckBox配置
  AppCheckBox.defaultCheckboxBuilder = (context, checked) {
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
              : BorderSide(width: 1.0, color: AppColors.divider.get()),
        ),
        fillColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
              ? AppColors.main.get()
              : Colors.transparent,
        ),
      ),
    );
  };

  /// DialogAlert配置
  DialogAlert.defaultPositiveText = () {
    return AppLocalizations().ok;
  };
  DialogAlert.defaultActionBuilder.positiveColor = (BuildContext context) {
    return AppColors.main.get();
  };
  DialogAlert.defaultActionBuilder.negativeColor = (BuildContext context) {
    return AppColors.textNormal.get();
  };
  DialogAlert.defaultSingleSelectActionBuilder.positiveColor = (BuildContext context) {
    return AppColors.main.get();
  };
  DialogAlert.defaultSingleSelectActionBuilder.negativeColor = (BuildContext context) {
    return AppColors.negative.get();
  };

  /// SettingItem配置
  SettingItem.defaultIconColor = (BuildContext context) {
    return AppColors.title.get();
  };
  SettingItem.defaultTitleColor = (BuildContext context) {
    return AppColors.title.get();
  };
  SettingItem.defaultTextColor = (BuildContext context) {
    return AppColors.textNormal.get();
  };
  SettingItem.defaultSwitchColor = (BuildContext context) {
    return AppColors.main.get();
  };
  SettingItem.defaultDividerColor = (BuildContext context) {
    return AppColors.divider.get();
  };
  SettingItem.defaultMinimumHeight = 52;
  SettingItem.defaultShowDivider = true;

  /// ImagePickerDialog配置
  // ImagePickerDialog.openGalleryText = () => AppLocalizations().actionOpenGallery;
  // ImagePickerDialog.openCameraText = () => AppLocalizations().actionOpenCamera;
  //
  /// ImageViewer配置
  // ImageViewerPage.onImageSaveResult = (dynamic result) {
  //   if (result.isSuccess) {
  //     toastAlert(AppLocalizations().imageSaveSuccess);
  //   }
  //   else {
  //     toastAlert("${AppLocalizations().imageSaveFailed}: ${result.errorMessage}");
  //   }
  // };

  /// AppNavigationBar配置
  AppNavigationBar.defaultTitleColor = (BuildContext context) => AppColors.title.get();

  /// InputWidget配置
  InputWidget.defaultInputConfigs = (BuildContext context) {
    return InputConfigs(
      textStyle: TextStyle(
          color: AppColors.textNormal.get()
      ),
      labelTextStyle: TextStyle(
        color: AppColors.title.get()
      ),
      hintTextStyle: TextStyle(
        color: AppColors.hint.get()
      ),
      prefixTextStyle: TextStyle(
        color: AppColors.title.get()
      ),
      suffixTextStyle: TextStyle(
        color: AppColors.title.get()
      ),
      borderColor: Colors.blue
    );
  };
  // InputWidget.defaultClearButton = (BuildContext context) {
  //   return const Icon(
  //     Icons.cancel,
  //     size: 20,
  //     color: Colors.grey,
  //   );
  // };
  /// LoadingView配置
  // LoadingViewController.defaultLoadingHolder = () {
  //   return NoDataHolder()
  //     ..setIcon(const LogoLoadingWidget())
  //     ..setDescText("");
  // };
  // LoadingViewController.defaultEmptyHolder = () {
  //   return NoDataHolder()
  //     ..setIconAsset(AppAssets.images.loadingNoData.path)
  //     ..setDescText(AppLocalizations().errorNoData);
  // };
  // LoadingViewController.defaultFailedHolder = () {
  //   return NoDataHolder()
  //     ..setIconAsset(AppAssets.images.loadingFailed.path)
  //     ..setDescText(AppLocalizations().errorRequestFailed);
  // };
  // LoadingViewController.defaultNoNetworkHolder = () {
  //   return NoDataHolder()
  //     ..setIconAsset(AppAssets.images.loadingNoNetwork.path)
  //     ..setDescText(AppLocalizations().errorNoNetwork);
  // };
  // LoadingViewController.defaultTimeoutText = () => AppLocalizations().errorTimeout;
  // LoadingViewController.defaultNetworkErrorText = () => AppLocalizations().errorNoNetwork;

  /// WheelDatetimePickerPanel配置
  WheelDatetimePickerPanel.confirmColor = (context) => AppColors.main.get();
  WheelDatetimePickerPanel.cancelColor = (context) => AppColors.textNormal.get();
  WheelDatetimePickerPanel.titleColor = (context) => AppColors.title.get();
  WheelDatetimePickerPanel.dividerColor = (context) => AppColors.divider.get();
  WheelDatetimePickerPanel.confirmText = () => AppLocalizations().confirm;
  WheelDatetimePickerPanel.cancelText = () => AppLocalizations().cancel;

}

/// Framework Widget使用颜色覆盖
class FrameworkColorsEx implements FrameworkColors {

  @override
  Color? Function(BuildContext context) background = (BuildContext context) {
    return AppColors.background.get();
  };

  @override
  Color? Function(BuildContext context) foreground = (BuildContext context) {
    return AppColors.foreground.get();
  };

}

/// Framework Widget使用尺寸值覆盖
class FrameworkDimensEx implements FrameworkDimens {

  @override
  double get fontXXL => GlobalDimens.fontXXL;
  @override
  double get fontXL => GlobalDimens.fontXL;
  @override
  double get fontL => GlobalDimens.fontL;
  @override
  double get fontM => GlobalDimens.fontM;
  @override
  double get fontS => GlobalDimens.fontS;
  @override
  double get fontXS => GlobalDimens.fontXS;
  @override
  double get fontXXS => GlobalDimens.fontXXS;

  @override
  double get navigationBarHeight => GlobalDimens.navigationBarHeight;
  @override
  double get paddingBoth => GlobalDimens.paddingBoth;
  @override
  double get dialogRadius => GlobalDimens.dialogRadius;
  @override
  double get dialogMarginBoth => GlobalDimens.dialogMarginBoth;

}