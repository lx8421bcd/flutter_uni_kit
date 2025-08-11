extension StringExtension on String? {

  String? prefix(int count) {
    if (this == null) {
      return this;
    }
    if (this!.length < count) {
      return this;
    }
    return this!.substring(0, count);
  }

  /// contain the start
  String? suffix(int count) {
    if (this == null) {
      return this;
    }
    if (this!.length < count) {
      return this;
    }
    var start = this!.length - count;
    return this!.substring(start);
  }

  bool isNullOrEmpty() {
    return this == null || this!.isEmpty;
  }

  bool isNotNullOrEmpty() {
    return this != null && this!.isNotEmpty;
  }

  /// 获取文件路径字符串的文件扩展名
  String getExtName({bool withDot = true}) {
    if (this == null) {
      return "";
    }
    int extStart = this!.lastIndexOf(".");
    if (extStart < 0 || extStart >= this!.length - 1) {
      return "";
    }
    return this!.substring(extStart + (withDot ? 0 : 1), this!.length);
  }

  bool get isEmail {
    return this != null && this!.isNotEmpty &&
        RegExp(r"^[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:\w(?:[\w-]*\w)?\.)+\w(?:[\w-]*\w)?$")
            .hasMatch(this!);
  }

  bool get isDigitsOnly {
    return  this != null && RegExp(r'^[0-9]+$').hasMatch(this!);
  }

}