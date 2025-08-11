// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  static String m0(locale, countryCode) => "当前语言：${locale} 国家代码：${countryCode}";

  static String m1(date, time) => "日期: ${date} 时间: ${time}";

  static String m2(gender) =>
      "${Intl.gender(gender, female: 'Hi 女士!', male: 'Hi 先生!', other: 'Hi!')}";

  static String m3(count) =>
      "${Intl.plural(count, zero: '暂无新消息', one: '您有一条新消息', other: '${count}条新消息未读')}";

  static String m4(role) =>
      "${Intl.select(role, {'admin': 'Hi 管理员!', 'manager': 'Hi 操作者!', 'other': 'Hi 访问者!'})}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "alert": MessageLookupByLibrary.simpleMessage("Alert"),
    "attention": MessageLookupByLibrary.simpleMessage("Attention"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "currentLocalTest": m0,
    "dateTimeTest": m1,
    "genderTest": m2,
    "loading": MessageLookupByLibrary.simpleMessage("Loading"),
    "messageTest": m3,
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "roleTest": m4,
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "submit": MessageLookupByLibrary.simpleMessage("Submit"),
    "switchLocalizationTest": MessageLookupByLibrary.simpleMessage("切换语言"),
    "use": MessageLookupByLibrary.simpleMessage("Use"),
  };
}
