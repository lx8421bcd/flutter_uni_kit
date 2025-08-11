import 'dart:convert';
import 'dart:typed_data';

import 'package:hive/hive.dart';

/// Hive扩展方法，用于在创建Box时缓存Box名称，以便提供Box名称遍历方法
///
/// @author linxiao
/// @since 2023-11-23
extension HiveExtension on HiveInterface {

  /// BoxName缓存Box
  Future<Box<String>> get _boxNameCache => openBox<String>("HiveBoxNameCaches");
  /// 加密key缓存Box
  Future<Box<String>> get _encryptKeyCache => openBox<String>("appEncryptKeys");

  /// 删除Box同时删除name缓存
  Future<void> removeRecordedBox(String name) async {
    var nameBox = await _boxNameCache;
    nameBox.delete(name);
    Hive.deleteBoxFromDisk(name);
  }

  /// 获取所有已缓存的Box name
  Future<List<String>> getRecordedBoxNames() async {
    List<String> ret = [];
    var nameBox = await _boxNameCache;
    for (var element in nameBox.keys) {
      ret.add(element);
    }
    return ret;
  }

  /// 获取Hive默认方式的加密key
  Future<Uint8List> getBoxEncryptKey(String name) async {
    var encryptKeyCacheBox = await _encryptKeyCache;
    String? encryptKey = encryptKeyCacheBox.get(name);
    if (encryptKey == null || encryptKey.isEmpty) {
      encryptKey = base64Encode(Hive.generateSecureKey());
      await encryptKeyCacheBox.put(name, encryptKey);
      await encryptKeyCacheBox.flush();
    }
    return base64Decode(encryptKey);
  }

  /// 执行Hive[openBox]的同时缓存Box[name]至全局name缓存中，以便根据name管理Box
  Future<Box<E>> openRecordedBox<E>(
    String name,
  {
    HiveCipher? encryptionCipher,
    KeyComparator keyComparator = defaultKeyComparator,
    CompactionStrategy compactionStrategy = defaultCompactionStrategy,
    bool crashRecovery = true,
    String? path,
    Uint8List? bytes,
    String? collection,
  }) async {
    Box<E> box = await openBox<E>(
        name,
        encryptionCipher: encryptionCipher,
        keyComparator: keyComparator,
        compactionStrategy: compactionStrategy,
        crashRecovery: crashRecovery,
        bytes: bytes,
        collection: collection
    );
    var nameBox = await _boxNameCache;
    nameBox.put(name, name);
    return box;
  }

  /// 执行Hive[openLazyBox]的同时缓存Box[name]至全局name缓存中，以便根据name管理Box
  Future<LazyBox<E>> openRecordedLazyBox<E>(
    String name,
  {
    HiveCipher? encryptionCipher,
    KeyComparator keyComparator = defaultKeyComparator,
    CompactionStrategy compactionStrategy = defaultCompactionStrategy,
    bool crashRecovery = true,
    String? path,
    String? collection,
  }) async {
    LazyBox<E> box = await openLazyBox<E>(
        name,
        encryptionCipher: encryptionCipher,
        keyComparator: keyComparator,
        compactionStrategy: compactionStrategy,
        crashRecovery: crashRecovery,
        collection: collection
    );
    var nameBox = await _boxNameCache;
    nameBox.put(name, name);
    return box;
  }

  /// 使用Hive默认加密方式生成加密Box，同时缓存加密key
  Future<Box<E>> openEncryptedBox<E>(
    String name,
  {
    KeyComparator keyComparator = defaultKeyComparator,
    CompactionStrategy compactionStrategy = defaultCompactionStrategy,
    bool crashRecovery = true,
    String? path,
    Uint8List? bytes,
    String? collection,
  }) async {
    var encryptKey = await getBoxEncryptKey(name);
    var encryptCipher = HiveAesCipher(encryptKey);
    return openRecordedBox<E>(
        name,
        encryptionCipher: encryptCipher,
        keyComparator: keyComparator,
        compactionStrategy: compactionStrategy,
        crashRecovery: crashRecovery,
        bytes: bytes,
        collection: collection
    );
  }

  /// 使用Hive默认加密方式生成加密Box，同时缓存加密key
  Future<LazyBox<E>> openEncryptedLazyBox<E>(
    String name,
  {
    KeyComparator keyComparator = defaultKeyComparator,
    CompactionStrategy compactionStrategy = defaultCompactionStrategy,
    bool crashRecovery = true,
    String? path,
    Uint8List? bytes,
    String? collection,
  }) async {
    var encryptKey = await getBoxEncryptKey(name);
    var encryptCipher = HiveAesCipher(encryptKey);
    return openRecordedLazyBox<E>(
        name,
        encryptionCipher: encryptCipher,
        keyComparator: keyComparator,
        compactionStrategy: compactionStrategy,
        crashRecovery: crashRecovery,
        collection: collection
    );
  }

}

/// Efficient default implementation to compare keys
int defaultKeyComparator(dynamic k1, dynamic k2) {
  if (k1 is int) {
    if (k2 is int) {
      if (k1 > k2) {
        return 1;
      } else if (k1 < k2) {
        return -1;
      } else {
        return 0;
      }
    } else {
      return -1;
    }
  } else if (k2 is String) {
    return (k1 as String).compareTo(k2);
  } else {
    return 1;
  }
}

const _deletedRatio = 0.15;
const _deletedThreshold = 60;

/// Default compaction strategy compacts if 15% of total values and at least 60
/// values have been deleted
bool defaultCompactionStrategy(int entries, int deletedEntries) {
  return deletedEntries > _deletedThreshold &&
      deletedEntries / entries > _deletedRatio;
}
