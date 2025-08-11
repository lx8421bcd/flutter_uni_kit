import 'package:cached_network_image/cached_network_image.dart';

class FPCachedNetworkImage extends CachedNetworkImage {

  static String? getCacheKey(String url) {
    try {
      var uri = Uri.parse(url);
      return "${uri.scheme}://${uri.host}${uri.path}";
    } catch (_) {
      return null;
    }
  }

  FPCachedNetworkImage({
    super.key,
    required String imageUrl,
    super.httpHeaders,
    super.imageBuilder,
    super.placeholder,
    super.progressIndicatorBuilder,
    super.errorWidget,
    super.fadeOutDuration = const Duration(milliseconds: 200),
    super.fadeOutCurve,
    super.fadeInDuration = const Duration(milliseconds: 200),
    super.fadeInCurve,
    super.width,
    super.height,
    super.fit,
    super.alignment,
    super.repeat,
    super.matchTextDirection = false,
    super.cacheManager,
    super.useOldImageOnUrlChange = false,
    super.color,
    super.filterQuality,
    super.colorBlendMode,
    super.placeholderFadeInDuration,
    super.memCacheWidth,
    super.memCacheHeight,
    super.maxWidthDiskCache,
    super.maxHeightDiskCache,
    super.errorListener,
    super.imageRenderMethodForWeb,
  }) : super(imageUrl: imageUrl, cacheKey: getCacheKey(imageUrl));
}
