// import 'package:flutter/material.dart';
// import 'package:flutter_uni_kit/alerts/dialog_alert.dart';
// import 'package:flutter_uni_kit/alerts/toast_alert.dart';
// import 'package:flutter_uni_kit/dialogs/image_picker_dialog.dart';
// import 'package:flutter_uni_kit/extensions/string_extensions.dart';
// import 'package:flutter_uni_kit/permission/permission_functions.dart';
// import 'package:flutter_uni_kit/theme/framework_colors.dart';
// import 'package:flutter_uni_kit/theme/framework_dimens.dart';
// import 'package:flutter_uni_kit/widgets/border_button.dart';
// import 'package:flutter_uni_kit/widgets/color_button.dart';
// import 'package:flutter_uni_kit/widgets/gradient_button.dart';
// import 'package:flutter_uni_kit/widgets/image_viewer.dart';
// import 'package:flutter_uni_kit/widgets/input_widget.dart';
// import 'package:flutter_uni_kit/widgets/loading_view.dart';
// import 'package:flutter_uni_kit/widgets/navigation_bar.dart';
// import 'package:flutter_uni_kit/widgets/setting_item.dart';
// import 'package:flutter_uni_kit/widgets/wheel_datetime_picker_panel.dart';
//
//
// void initFrameworkConfigs() {
//   /// Framework全局配置初始化
//   FrameworkColors.instance = FrameworkColorsEx();
//   FrameworkDimens.instance = FrameworkDimensEx();
//
//   /// Permission 全局配置
//   PermissionRestrictedHint.title = () => AppLocalizations().attention;
//   PermissionRestrictedHint.defaultHint = () => AppLocalizations().alertPermissionPermanentlyDenied;
//   PermissionRestrictedHint.goSettings = () => AppLocalizations().actionGoSettings;
//   PermissionRestrictedHint.cancel = () => AppLocalizations().cancel;
//
//   /// ShadowCard配置
//   ShadowCard.defaultForegroundColor = (BuildContext context) {
//     return AppColors.colorButtonForeground.get();
//   };
//   ShadowCard.defaultForegroundColor = (BuildContext context) {
//     return Colors.black.withAlpha(20);
//   };
//
//   /// GradientButton 配置
//   GradientButton.defaultBorderRadius = BorderRadius.circular(GlobalDimens.submitButtonRadius);
//   GradientButton.defaultEnabledGradient = (BuildContext context) {
//     return const LinearGradient(
//         colors: [Color(0xFF49B2FF), Color(0xFF005DA0)],
//         begin: Alignment.centerLeft,
//         end: Alignment.centerRight
//     );
//   };
//   GradientButton.defaultDisabledGradient = (BuildContext context) {
//     return const LinearGradient(
//         colors: [Color(0x8049B2FF), Color(0x80005DA0)],
//         begin: Alignment.centerLeft,
//         end: Alignment.centerRight
//     );
//   };
//
//   /// ColorButton配置
//   ColorButton.defaultBorderRadius = BorderRadius.circular(GlobalDimens.submitButtonRadius);
//   ColorButton.defaultForegroundColor = (BuildContext context) {
//     return AppColors.colorButtonForeground.get();
//   };
//   ColorButton.defaultForegroundColorDisabled = (BuildContext context) {
//     return AppColors.colorButtonForegroundDisabled.get();
//   };
//   ColorButton.defaultBackgroundColor = (BuildContext context) {
//     return themeColor(context).colorButtonBackground;
//   };
//   ColorButton.defaultBackgroundColorDisabled = (BuildContext context) {
//     return themeColor(context).colorButtonBackgroundDisabled;
//   };
//
//   /// BorderButton配置
//   BorderButton.defaultBorderRadius = BorderRadius.circular(GlobalDimens.submitButtonRadius);
//   BorderButton.defaultColor = (BuildContext context) {
//     return themeColor(context).textButton;
//   };
//   BorderButton.defaultColorDisabled = (BuildContext context) {
//     return themeColor(context).textButtonDisabled;
//   };
//
//   /// DialogAlert配置
//   DialogAlert.defaultPositiveText = () {
//     return AppLocalizations().ok;
//   };
//   DialogAlert.defaultActionBuilder.positiveColor = (BuildContext context) {
//     return AppColors.main.get();
//   };
//   DialogAlert.defaultActionBuilder.negativeColor = (BuildContext context) {
//     return themeColor(context).textNormal;
//   };
//   DialogAlert.defaultSingleSelectActionBuilder.positiveColor = (BuildContext context) {
//     return AppColors.main.get();
//   };
//   DialogAlert.defaultSingleSelectActionBuilder.negativeColor = (BuildContext context) {
//     return AppColors.negative.get();
//   };
//
//   /// SettingItem配置
//   SettingItem.defaultIconColor = (BuildContext context) {
//     return AppColors.title.get();
//   };
//   SettingItem.defaultTitleColor = (BuildContext context) {
//     return AppColors.title.get();
//   };
//   SettingItem.defaultTextColor = (BuildContext context) {
//     return themeColor(context).textNormal;
//   };
//   SettingItem.defaultSwitchColor = (BuildContext context) {
//     return AppColors.main.get();
//   };
//   SettingItem.defaultDividerColor = (BuildContext context) {
//     return themeColor(context).divider;
//   };
//   SettingItem.defaultMinimumHeight = 52;
//   SettingItem.defaultShowDivider = true;
//
//   /// ImagePickerDialog配置
//   ImagePickerDialog.openGalleryText = () => AppLocalizations().actionOpenGallery;
//   ImagePickerDialog.openCameraText = () => AppLocalizations().actionOpenCamera;
//
//   /// ImageViewer配置
//   ImageViewerPage.onImageSaveResult = (String? result) {
//     toastAlert(result.isNotNullOrEmpty() ? AppLocalizations().imageSaveSuccess : AppLocalizations().imageSaveFailed);
//   };
//
//   /// AppNavigationBar配置
//   AppNavigationBar.defaultTitleColor = (BuildContext context) => AppColors.title.get();
//
//   /// InputWidget配置
//   InputWidget.defaultColorConfigs = (BuildContext context) {
//     return InputColorConfigs(
//       labelTextColor: AppColors.title.get(),
//       textColor: themeColor(context).textNormal,
//       hintColor: themeColor(context).hint,
//       prefixTextColor: AppColors.title.get(),
//       suffixTextColor: AppColors.title.get(),
//       dividerColor: themeColor(context).divider,
//     );
//   };
//   // InputWidget.defaultClearButton = (BuildContext context) {
//   //   return const Icon(
//   //     Icons.cancel,
//   //     size: 20,
//   //     color: Colors.grey,
//   //   );
//   // };
//   /// LoadingView配置
//   LoadingViewController.defaultLoadingHolder = () {
//     return NoDataHolder()
//       ..setIcon(const LogoLoadingWidget())
//       ..setDescText("");
//   };
//   LoadingViewController.defaultEmptyHolder = () {
//     return NoDataHolder()
//       ..setIconAsset(AppAssets.images.loadingNoData.path)
//       ..setDescText(AppLocalizations().errorNoData);
//   };
//   LoadingViewController.defaultFailedHolder = () {
//     return NoDataHolder()
//       ..setIconAsset(AppAssets.images.loadingFailed.path)
//       ..setDescText(AppLocalizations().errorRequestFailed);
//   };
//   LoadingViewController.defaultNoNetworkHolder = () {
//     return NoDataHolder()
//       ..setIconAsset(AppAssets.images.loadingNoNetwork.path)
//       ..setDescText(AppLocalizations().errorNoNetwork);
//   };
//   LoadingViewController.defaultTimeoutText = () => AppLocalizations().errorTimeout;
//   LoadingViewController.defaultNetworkErrorText = () => AppLocalizations().errorNoNetwork;
//
//   /// WheelDatetimePickerPanel配置
//   WheelDatetimePickerPanel.confirmColor = (context) => AppColors.main.get();
//   WheelDatetimePickerPanel.cancelColor = (context) => themeColor(context).textNormal;
//   WheelDatetimePickerPanel.titleColor = (context) => AppColors.title.get();
//   WheelDatetimePickerPanel.dividerColor = (context) => themeColor(context).divider;
//   WheelDatetimePickerPanel.confirmText = () => AppLocalizations().confirm;
//   WheelDatetimePickerPanel.cancelText = () => AppLocalizations().cancel;
//
// }
//
// /// Framework Widget使用颜色覆盖
// class FrameworkColorsEx implements FrameworkColors {
//
//   @override
//   Color? Function(BuildContext context) background = (BuildContext context) {
//     return themeColor(context).background;
//   };
//
//   @override
//   Color? Function(BuildContext context) foreground = (BuildContext context) {
//     return AppColors.foreground.get();
//   };
//
// }
//
// /// Framework Widget使用尺寸值覆盖
// class FrameworkDimensEx implements FrameworkDimens {
//
//   @override
//   double get fontXXL => GlobalDimens.fontXXL;
//   @override
//   double get fontXL => GlobalDimens.fontXL;
//   @override
//   double get fontL => GlobalDimens.fontL;
//   @override
//   double get fontM => GlobalDimens.fontM;
//   @override
//   double get fontS => GlobalDimens.fontS;
//   @override
//   double get fontXS => GlobalDimens.fontXS;
//   @override
//   double get fontXXS => GlobalDimens.fontXXS;
//
//   @override
//   double get navigationBarHeight => GlobalDimens.navigationBarHeight;
//   @override
//   double get paddingBoth => GlobalDimens.paddingBoth;
//   @override
//   double get dialogRadius => GlobalDimens.dialogRadius;
//   @override
//   double get dialogMarginBoth => GlobalDimens.dialogMarginBoth;
//
// }