import 'package:flutter_uni_kit/extensions/hive_extension.dart';
import 'package:hive/hive.dart';


/// app全局设置管理
///
/// @author linxiao
/// @since 2023-11-22
class AppSettings {
  AppSettings._internal();

  static const String _settingStorageId = "AppSettings";

  static late Box _settingBox;

  static Future<void> init() async {
    _settingBox = await Hive.openEncryptedBox(_settingStorageId);
  }

  static void set<T>(String key, T value) {
    _settingBox.put(key, value);
    _settingBox.flush();
  }

  static T? get<T>(String key, {T? defaultValue}) {
    return _settingBox.get(key, defaultValue: defaultValue);
  }

  static void clear() {
    _settingBox.clear();
  }

}