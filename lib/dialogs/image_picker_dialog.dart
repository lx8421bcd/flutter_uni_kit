import 'package:flutter_uni_kit/permission/permission_functions.dart';
import 'package:flutter_uni_kit/alerts/dialog_alert.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

enum ImagePickResult {
  success,
  canceled,
  noPermission,
  error,
}

typedef ImagePickCallback = void Function(XFile? file, ImagePickResult result, dynamic exception);

/// 基于单选弹窗封装的图片选择Dialog
///
/// @author linxiao
/// @since 2023-12-06
class ImagePickerDialog {

  static String Function() openGalleryText = () {
    return "Gallery";
  };

  static String Function() openCameraText = () {
    return "Camera";
  };

  final DialogAlert _dialogAlert = DialogAlert();
  ImagePickCallback? _callback;

  ImagePickerDialog() {
    _dialogAlert
    ..setAction(
      actionText: openGalleryText(),
      action: () async {
        Get.back();
        await _startImagePicker(ImageSource.gallery);
      }
    )
    ..setAction(
      actionText: openCameraText(),
      action: () async {
        Get.back();
        await _startImagePicker(ImageSource.camera);
      }
    );
  }

  void setImagePickCallback(ImagePickCallback callback) {
    _callback = callback;
  }

  void show() {
    _dialogAlert.showBottom();
  }

  Future<void> _startImagePicker(ImageSource source) async {
    XFile? file;
    ImagePickResult result;
    dynamic exception;
    var hasPermission = source == ImageSource.gallery
        ? await requestGalleryPermission()
        : await requestCameraPermission();
    if (!hasPermission) {
      result = ImagePickResult.noPermission;
      return;
    }
    try {
      file = await ImagePicker().pickImage(source: source);
      result =
          file != null ? ImagePickResult.success : ImagePickResult.canceled;
    } catch (e) {
      e.printError();
      result = ImagePickResult.error;
      exception = e;
    }
    _callback?.call(file, result, exception);
  }


}
