class PlaceholderResource {

  static String rectangleImageUrl(int width, int height, [String text = "F"]) {
    return "https://via.placeholder.com/${width}x$height?text=$text";
  }

  static String squareImageUrl(int size, [String text = "F"]) {
    return "https://via.placeholder.com/$size?text=$text";
  }
}
