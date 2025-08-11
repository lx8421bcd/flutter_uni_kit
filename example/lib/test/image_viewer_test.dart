import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_uni_kit/common/log.dart';
import 'package:flutter_uni_kit/dialogs/image_picker_dialog.dart';
import 'package:flutter_uni_kit/widgets/fp_cached_network_image.dart';
import 'package:flutter_uni_kit/widgets/image_viewer.dart';
import 'package:example/generated/assets.gen.dart';
import 'package:get/get.dart';

/// flutter组件交互功能测试页面
///
/// @author linxiao
/// @since 2023-11-01
class ImageViewerTestPage extends StatefulWidget {
  const ImageViewerTestPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ImageViewerTestPageState();
  }
}

class _ImageViewerTestPageState extends State<ImageViewerTestPage> with WidgetsBindingObserver {

  final localImage = "".obs;
  final imageBytes = Uint8List(0).obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
        InkWell(
            child: Hero(
                tag: "test1",
                child: FPCachedNetworkImage(
                    imageUrl:
                        "https://pica.zhimg.com/v2-82307b5de4a6b0dd39f9376e6389e003_r.jpg?source=1def8aca")),
            onTap: () {
              var images = <ImageViewerItem>[];
              images.add(ImageViewerItem.network(
                  "https://pica.zhimg.com/v2-82307b5de4a6b0dd39f9376e6389e003_r.jpg?source=1def8aca"));
              images.add(ImageViewerItem.network(
                  "https://pic1.zhimg.com/v2-a4892e95121c43eb5afb996f0cf8fd03_r.jpg?source=1def8aca"));
              images.add(ImageViewerItem.network(
                  "https://picx.zhimg.com/v2-5e04c974bc003296172a4683827703e9_r.jpg?source=1def8aca"));
              images.add(ImageViewerItem.network(
                  "https://pic1.zhimg.com/70/v2-8214e68e6fa3f3db7b2a2f97bc18a718_1440w.avis?source=172ae18b&biz_tag=Post"));

              Get.to(ImageViewerPage(
                images: images,
                heroTag: "test1",
              ));
            }),
        Obx(() => InkWell(
          child: Hero(
            tag: "test2",
            child: localImage.value.isEmpty ? AppAssets.images.loadingNoPicture.image() : Image.file(File(localImage.value)),
          ),
          onTap: () {
            var images = <ImageViewerItem>[];
            images.add(ImageViewerItem.file(localImage.value));
            images.add(ImageViewerItem.asset(AppAssets.images.loadingNoPicture.path));
            Get.to(ImageViewerPage(images: images, heroTag: "test2",));
          },
          onDoubleTap: () {
            selectImage();
          },
        )),
      ],
    );
  }

  void selectImage() {
    ImagePickerDialog()
      ..setImagePickCallback((file, result, exception) {
        Log.d("file: ${file?.path}");
        if (file != null) {
          localImage.value = file.path;
        }
      })
      ..show();
  }
}
