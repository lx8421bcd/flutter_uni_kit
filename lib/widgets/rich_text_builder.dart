import 'package:flutter/material.dart';

class RichTextBuilder {
  TextStyle? textStyle;
  final _splitList = [];

  RichTextBuilder({
    required String source,
    this.textStyle
  }) {
    _splitList.add(source);
  }

  RichTextBuilder setSpan({
    required String replace,
    required InlineSpan span,
    bool replaceAll = true
  }) {
    var newSplitList = [];
    var replaceCompleted = false;
    for (var split in _splitList) {
      var subSplitList = [split];
      if (!replaceCompleted && split is String && split.contains(replace)) {
        subSplitList = split.split(replace)
            .expand((item) => [item, span])
            .toList();
        subSplitList.removeLast();
        subSplitList.removeWhere((item) => item == "");
        if (!replaceAll) {
          subSplitList = subSplitList.sublist(0, subSplitList.indexOf(span) + 1);
          String behind = split.substring(split.indexOf(replace) + replace.length);
          if (behind.isNotEmpty) {
            subSplitList.add(behind);
          }
          replaceCompleted = true;
        }
      }
      newSplitList.addAll(subSplitList);
    }
    _splitList.clear();
    _splitList.addAll(newSplitList);
    return this;
  }

  List<InlineSpan> buildSpanList() {
    var spanList = <InlineSpan>[];
    for (var split in _splitList) {
      if (split is String) {
        spanList.add(TextSpan(
          text: split,
          style: textStyle,
        ));
      }
      else {
        spanList.add(split);
      }
    }
    return spanList;
  }

}