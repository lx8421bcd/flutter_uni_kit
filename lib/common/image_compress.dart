import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart';

enum ImageCompressPriority {
  /// 在[ImageCompressHelper.compress]传入此参数时优先缩小图片尺寸，
  size,
  /// 在[ImageCompressHelper.compress]传入此参数时优先降低图片质量，
  quality
}

class ImageCompressHelper {
  ImageCompressHelper._internal();

  /// 从图片尺寸和图像质量两个方面复合压缩图片
  /// [priority] - 压缩参数优先级, 为[ImageCompressPriority.size]时优先缩小图片尺寸，为[ImageCompressPriority.quality]时优先降低图片质量
  /// [targetWidth] - 指定宽度，设定此参数后输出图片将直接指定为此宽度，不会逐级尝试缩小，注意设定宽度不会超过图片本身的宽度
  /// [targetHeight] - 指定高度，逻辑同[targetHeight]
  /// [minWidth] - 最小宽度，压缩尺寸超过此尺寸时不会继续缩小
  /// [minHeight] - 最小高度，逻辑同[minWidth]
  /// [targetQuality] - 目标质量，设定此值后，不会尝试逐级降低
  /// [minQuality] - 最低质量，超过此值后不会尝试继续降低质量
  ///
  /// 注意，如果尺寸和质量均已达到最低值后图片仍超过限制大小，此方法将会直接输出超限图片
  /// @return jpeg格式图片的[Unit8List]对象
  static Future<Uint8List> compress({
    required Uint8List fileBytes,
    required int limitSize,
    ImageCompressPriority priority = ImageCompressPriority.size,
    int targetWidth = 0,
    int targetHeight = 0,
    int targetQuality = 0,
    int minWidth = 1,
    int minHeight = 1,
    int minQuality = 5,
  }) async {
    var compressResult = fileBytes;
    if (targetWidth > 0 && targetHeight > 0) {
      priority = ImageCompressPriority.size; // 如果指定了宽高则优先处理宽高
    }
    else if (targetQuality > 0) {
      priority = ImageCompressPriority.quality; // 只指定了图片质量优先处理质量
    }
    if (priority == ImageCompressPriority.size) {
      compressResult = await compressBySize(
        fileBytes: fileBytes,
        limitSize: limitSize,
        targetWidth: targetWidth,
        targetHeight: targetHeight,
        minWidth: minWidth,
        minHeight: minHeight,
      );
      compressResult = await compressByQuality(
        fileBytes: compressResult,
        limitSize: limitSize,
        targetQuality: targetQuality,
        minQuality: minQuality,
      );
    }
    else {
      compressResult = await compressByQuality(
        fileBytes: fileBytes,
        limitSize: limitSize,
        targetQuality: targetQuality,
        minQuality: minQuality,
      );
      compressResult = await compressBySize(
        fileBytes: compressResult,
        limitSize: limitSize,
        targetWidth: targetWidth,
        targetHeight: targetHeight,
        minWidth: minWidth,
        minHeight: minHeight,
      );
    }
    return compressResult;
  }

  /// 通过逐级缩小尺寸压缩图片至指定大小。
  /// 一级10%，最后一级5%，如果调整到5%还无法达到指定大小，则直接返回5%大小的图片
  static Future<Uint8List> compressBySize({
    required Uint8List fileBytes,
    required int limitSize,
    int targetWidth = 0,
    int targetHeight = 0,
    int minWidth = 1,
    int minHeight = 1,
  }) async {
    if (fileBytes.lengthInBytes <= limitSize) {
      return fileBytes;
    }
    var image = decodeImage(fileBytes);
    if (image == null) {
      return fileBytes;
    }
    if (targetWidth > 0 && targetHeight > 0) {
      return await FlutterImageCompress.compressWithList(
          fileBytes,
          minWidth: targetWidth,
          minHeight: targetHeight,
          format: CompressFormat.jpeg
      );
    }
    double scale = 1.1;
    do {
      scale = scale > 0.1 ? scale - 0.1 : scale - 0.05;
      int width = max((image.width * scale).toInt(), minWidth);
      int height = max((image.height * scale).toInt(), minHeight);
      fileBytes = await FlutterImageCompress.compressWithList(
        fileBytes,
        minWidth: width,
        minHeight: height,
        format: CompressFormat.jpeg
      );
      print(
        "compressed by size result: "
        "width = $width, height = $height, size = ${fileBytes.lengthInBytes}"
      );
      if (scale <= 0.05) {
        break;
      }
      if (width <= minWidth || height <= minHeight) {
        break;
      }
    } while(fileBytes.lengthInBytes > limitSize);

    return fileBytes;
  }

  /// 通过降低质量逐级压缩图片至指定大小。
  /// 95起步，一次降低5，如果降低到最低（默认5）仍不能达到指定大小则直接返回。
  static Future<Uint8List> compressByQuality({
    required Uint8List fileBytes,
    required int limitSize,
    int targetQuality = 0,
    int minQuality = 5,
  }) async {
    if (fileBytes.lengthInBytes <= limitSize) {
      return fileBytes;
    }
    var image = decodeImage(fileBytes);
    if (image == null) {
      return fileBytes;
    }
    if (targetQuality > 0) {
      return await FlutterImageCompress.compressWithList(
          fileBytes,
          minWidth: image.width,
          minHeight: image.height,
          quality: max(minQuality, targetQuality),
          format: CompressFormat.jpeg
      );
    }
    int quality = 100;
    do {
      quality -= 5;
      fileBytes = await FlutterImageCompress.compressWithList(
          fileBytes,
          minWidth: image.width,
          minHeight: image.height,
          quality: quality,
          format: CompressFormat.jpeg
      );
      print(
        "compressed by quality result: "
        "quality = $quality, size = ${fileBytes.lengthInBytes}"
      );
      if (quality <= minQuality) {
        break;
      }
    } while(fileBytes.lengthInBytes > limitSize);

    return fileBytes;
  }

}