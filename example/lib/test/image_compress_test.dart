import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_uni_kit/alerts/toast_alert.dart';
import 'package:flutter_uni_kit/common/image_compress.dart';
import 'package:flutter_uni_kit/dialogs/image_picker_dialog.dart';
import 'package:flutter_uni_kit/permission/permission_functions.dart';
import 'package:flutter_uni_kit/widgets/border_button.dart';
import 'package:flutter_uni_kit/widgets/input_widget.dart';
import 'package:example/themes/app_colors.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;

/// flutter组件交互功能测试页面
///
/// @author linxiao
/// @since 2023-11-01
class ImageCompressTestPage extends StatefulWidget {
  const ImageCompressTestPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ImageCompressTestPageState();
  }
}

class _ImageCompressTestPageState extends State<ImageCompressTestPage> with WidgetsBindingObserver {

  final limitSizeController = TextEditingController();
  final targetWidthController = TextEditingController();
  final targetHeightController = TextEditingController();
  final targetQualityController = TextEditingController();
  final minWidthController = TextEditingController();
  final minHeightController = TextEditingController();
  final minQualityController = TextEditingController();

  final imageBytes = Uint8List(0).obs;
  final compressedInfo = "".obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    limitSizeController.text = (1024 * 500).toString();
    targetWidthController.text = 0.toString();
    targetHeightController.text = 0.toString();
    targetQualityController.text = 0.toString();
    minWidthController.text = 1280.toString();
    minHeightController.text = 720.toString();
    minQualityController.text = 50.toString();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        InputWidget(
          labelText: "limit size(B)",
          controller: limitSizeController,
          showClearButton: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
        Row(
          children: [
            Expanded(
              child: InputWidget(
                labelText: "minWidth",
                controller: minWidthController,
                showClearButton: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            Expanded(
              child: InputWidget(
                labelText: "minHeight",
                controller: minHeightController,
                showClearButton: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            Expanded(
              child: InputWidget(
                labelText: "minQuality",
                controller: minQualityController,
                showClearButton: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: InputWidget(
                labelText: "targetWidth",
                controller: targetWidthController,
                showClearButton: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            Expanded(
              child: InputWidget(
                labelText: "targetHeight",
                controller: targetHeightController,
                showClearButton: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            Expanded(
              child: InputWidget(
                labelText: "targetQuality",
                controller: targetQualityController,
                showClearButton: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          color: Colors.grey,
          height: ScreenUtil().screenWidth,
          child: InkWell(
            onTap: () {
              ImagePickerDialog()
              ..setImagePickCallback((file, result, exception) {
                if (file != null) {
                  testImageCompress(file);
                }
              })
              ..show();
            },
            child: Center(
              child: Obx(() => imageBytes.value.isEmpty
                ? const Text("Select Picture")
                : Image.memory(imageBytes.value),
              ),
            ),
          ),
        ),
        Obx(() => Text(compressedInfo.value)),
        const SizedBox(height: 10),
        Obx(() => imageBytes.value.isEmpty
            ? const SizedBox()
            : BorderButton(
                onPressed: saveImage,
                color: AppColors.main.get(),
                child: const Text("Save to System Gallery"),
            )
        )
      ],
    );
  }

  Future<void> testImageCompress(XFile imageFile) async {
    EasyLoading.show(status: "compressing", dismissOnTap: false);
    var fileBytes = await imageFile.readAsBytes();
    fileBytes = await ImageCompressHelper.compress(
      fileBytes: fileBytes,
      limitSize: int.tryParse(limitSizeController.text) ?? 1024 * 500,
      targetWidth: int.tryParse(targetWidthController.text) ?? 0,
      targetHeight: int.tryParse(targetHeightController.text) ?? 0,
      targetQuality: int.tryParse(targetQualityController.text) ?? 0,
      minWidth: int.tryParse(minWidthController.text) ?? 1,
      minHeight: int.tryParse(minHeightController.text) ?? 1,
      minQuality: int.tryParse(minQualityController.text) ?? 5,
    );
    var image = img.decodeImage(fileBytes);
    if (image != null) {
      compressedInfo.value = "Compressed result params: \n"
          "width = ${image.width}\n"
          "height = ${image.height}\n"
          "size = ${fileBytes.lengthInBytes}B";
    }
    imageBytes.value = fileBytes;
    EasyLoading.dismiss();
  }

  void saveImage() async {
    var hasPermission = await requestGalleryPermission();
    if (!hasPermission) {
      toastAlert("no permission");
      return;
    }
    try {
      await Gal.putImageBytes(imageBytes.value);
      toastAlert("success");
    } on GalException catch (e) {
      toastAlert("failed: ${e.type.message}");
    }
  }
}
