import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_uni_kit/alerts/toast_alert.dart';
import 'package:flutter_uni_kit/permission/permission_functions.dart';
import 'package:flutter_uni_kit/widgets/fp_cached_network_image.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';

enum ItemType {
  asset,
  file,
  network,
}

class ImageViewerItem {
  ItemType type;
  String value;

  ImageViewerItem(this.type, this.value);

  factory ImageViewerItem.asset(String value) => ImageViewerItem(ItemType.asset, value);

  factory ImageViewerItem.file(String value) => ImageViewerItem(ItemType.file, value);

  factory ImageViewerItem.network(String value) => ImageViewerItem(ItemType.network, value);

}

class ImageSaveResult {
  final bool isSuccess;
  final String? errorMessage;
  final String? path;

  ImageSaveResult({
    required this.isSuccess,
    this.errorMessage,
    this.path
  });
}

///大图浏览页面组件
///
/// @author linxiao
/// @since 2023-12-26
class ImageViewerPage extends StatefulWidget {

  static void Function(ImageSaveResult result) onImageSaveResult = (ImageSaveResult result) {
    if (result.isSuccess) {
      toastAlert("success");
    }
    else {
      toastAlert("failed: ${result.errorMessage}");
    }
  };

  final List<ImageViewerItem> images;
  final int initialIndex;
  final String heroTag;
  final bool showSave;
  final bool showShare;

  const ImageViewerPage({
    super.key,
    required this.images,
    this.initialIndex = 0,
    this.heroTag = "",
    this.showSave = true,
    this.showShare = true,
  });

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {

  PageController pageController = PageController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialIndex);
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.heroTag,
      child: Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: Stack(
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: PhotoViewGallery.builder(
                  pageController: pageController,
                  onPageChanged: (index) {
                    currentIndex = index;
                  },
                  itemCount: widget.images.length,
                  builder: _buildViewerItem,
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 48),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.showSave ? CircleAvatar(
                      backgroundColor: const Color(0x80FFFFFF),
                      child: IconButton(
                        onPressed: () {
                          _saveImage(widget.images[currentIndex]);
                        },
                        icon: const Icon(Icons.download, color: Colors.white)
                      ),
                    ) : const SizedBox(),
                    const SizedBox(width: 12),
                    widget.showShare ? CircleAvatar(
                      backgroundColor: const Color(0x80FFFFFF),
                      child: IconButton(
                        onPressed: () {
                          _shareImage(widget.images[currentIndex]);
                        },
                        icon: const Icon(Icons.share, color: Colors.white)
                      ),
                    ) : const SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildViewerItem(BuildContext context, int index) {
    ImageViewerItem item = widget.images[index];
    ImageProvider? imageProvider;
    switch (item.type) {
      case ItemType.asset:
        imageProvider = AssetImage(item.value);
        break;
      case ItemType.file:
        imageProvider = FileImage(File(item.value));
        break;
      default:
        imageProvider = CachedNetworkImageProvider(item.value,
            cacheKey: FPCachedNetworkImage.getCacheKey(item.value));
    }
    return PhotoViewGalleryPageOptions(
      imageProvider: imageProvider,
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 4,
      // heroAttributes: PhotoViewHeroAttributes(tag: ""),
    );
  }

  void _shareImage(ImageViewerItem item) async {
    File shareFile;
    switch (item.type) {
      case ItemType.asset:
        ByteData bytes = await rootBundle.load(item.value);
        Directory tempDir = await getTemporaryDirectory();
        Directory shareTempFolder = Directory("${tempDir.path}/ImageViewerShareTemp");
        if (shareTempFolder.existsSync()) {
          await shareTempFolder.delete(recursive: true);
        }
        await shareTempFolder.create();
        String sourceFileName = item.value.substring(item.value.lastIndexOf("/") + 1, item.value.length);
        shareFile = File("${shareTempFolder.path}/$sourceFileName");
        await shareFile.create();
        shareFile.writeAsBytesSync(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
        break;
      case ItemType.file:
        shareFile = File(item.value);
        break;
      default:
        shareFile = await DefaultCacheManager().getSingleFile(item.value);
    }
    Share.shareXFiles([XFile(shareFile.path)]);
  }

  void _saveImage(ImageViewerItem item) async {
    var hasPermission = await requestGalleryPermission();
    if (!hasPermission) {
      var result = ImageSaveResult(isSuccess: false, errorMessage: "No permission", path: null);
      ImageViewerPage.onImageSaveResult(result);
      return;
    }
    Uint8List imageBytes;
    switch (item.type) {
      case ItemType.asset:
        ByteData bytes = await rootBundle.load(item.value);
        imageBytes = bytes.buffer.asUint8List();
        break;
      case ItemType.file:
        imageBytes = File(item.value).readAsBytesSync();
        break;
      default:
        var file = await DefaultCacheManager().getSingleFile(item.value);
        imageBytes = file.readAsBytesSync();
    }
    try {
      await Gal.putImageBytes(imageBytes);
      var result = ImageSaveResult(
        isSuccess: true,
        errorMessage: "",
        path: null, // there is no way to get saved path for now in Gal sdk
      );
      ImageViewerPage.onImageSaveResult(result);
    } on GalException catch (e) {
      var result = ImageSaveResult(
        isSuccess: false,
        errorMessage: e.type.message,
        path: null
      );
      ImageViewerPage.onImageSaveResult(result);
    }
  }
}
