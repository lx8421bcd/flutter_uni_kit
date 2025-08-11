import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_uni_kit/widgets/border_button.dart';
import 'package:example/themes/app_colors.dart';
import 'package:flutter_uni_kit/net/file_download.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

/// 下载测试
///
/// @author linxiao
/// @since 2023-12-29
class DownloadTestPage extends StatefulWidget {
  const DownloadTestPage({super.key});

  @override
  State<DownloadTestPage> createState() => _DownloadTestPageState();
}

class _DownloadTestPageState extends State<DownloadTestPage> {

  final downloadProgress = 0.0.obs;
  final downloadInfo = "".obs;

  FileDownloadTask? downloadTask;

  @override
  Widget build(BuildContext context) {
    initDownloadTask();
    return Obx(() => ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text("download source: ${downloadTask?.downloadUrl}"),
        12.verticalSpace,
        Text("download to: ${downloadTask?.savePath}"),
        12.verticalSpace,
        LinearProgressIndicator(value: downloadProgress.value),
        Text(downloadInfo.value),
        12.verticalSpace,
        Row(
          children: [
            BorderButton(
              onPressed: downloadTask?.status == DownloadStatus.downloading ? null :() {
                downloadTask?.start();
              },
              color: AppColors.main.get(),
              child: const Text("Start"),
            ),
            12.horizontalSpace,
            BorderButton(
              onPressed: () {
                downloadTask?.pause();
              },
              color: AppColors.main.get(),
              child: const Text("Pause"),
            ),
            12.horizontalSpace,
            BorderButton(
              onPressed: () {
                downloadTask?.cancel();
              },
              color: AppColors.negative.get(),
              child: const Text("Cancel"),
            ),
          ],
        ),
        12.verticalSpace,
        BorderButton(
          onPressed: () async {
            downloadTask?.cancel();
            var savePath = await getTemporaryDirectory();
            File cachedFile = File("${savePath.path}/googlechrome.dmg");
            if (cachedFile.existsSync()) {
              cachedFile.deleteSync(recursive: true);
            }
            initDownloadTask();
          },
          color: AppColors.negative.get(),
          child: const Text("Delete downloaded"),
        ),
      ],
    ));
  }

  void initDownloadTask() async {
    var savePath = await getTemporaryDirectory();
    var saveFile = File("${savePath.path}/googlechrome.dmg");
    downloadTask = FileDownloadTask(
        downloadUrl: "https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg",
        savePath: saveFile.path
    )
    ..startCallback = () {
      downloadInfo.value = "pending";
    }
    ..progressCallback = (int received, int total) {
      downloadProgress.value = received/total;
      downloadInfo.value = "downloading $received/$total";
    }
    ..pauseCallback = () {
      downloadInfo.value = "paused";
    }
    ..cancelCallback = () {
      downloadProgress.value = 0;
      downloadInfo.value = "canceled";
    }
    ..successCallback = () {
      downloadInfo.value = "completed";
    }
    ..errorCallback = (e) {
      downloadInfo.value = e.toString();
    };

    // 初始化完毕
    downloadInfo.value = "initialized";
    downloadProgress.value = 0;
  }
}
