import 'package:flutter/material.dart';

class NamedFormItem<T> {

  final T? Function() getter;
  final void Function(T) setter;

  NamedFormItem({
    required this.getter,
    required this.setter
  });

}

class AppForm {

  final formKey = GlobalKey<FormState>();

  final _namedFields = <String, NamedFormItem>{};

  void setNamedFields(String name, NamedFormItem? formItem) {
    if (formItem != null) {
      _namedFields[name] = formItem;
    }
    else {
      _namedFields.remove(name);
    }
  }

  bool validate() {
    return formKey.currentState?.validate() ?? false;
  }

  dynamic getFieldValue(String name) {
    return _namedFields[name]?.getter.call();
  }

  void setFieldValue(String name, dynamic value) {
    _namedFields[name]?.setter.call(value);
  }

  Map<String, dynamic> getFieldsValue() {
    var nestedMap = <String, dynamic>{};
    for (final entry in _namedFields.entries) {
      final keys = entry.key.split('.');
      var nestedEntry = nestedMap;
      for (int i = 0; i < keys.length; i++) {
        final currentKey = keys[i];
        if (i == keys.length - 1) {
          nestedEntry[currentKey] = entry.value.getter.call();
          continue;
        }
        if (!nestedEntry.containsKey(currentKey) || nestedEntry[currentKey] is! Map<String, dynamic>) {
          nestedEntry[currentKey] = <String, dynamic>{};
        }
        nestedEntry = nestedEntry[currentKey] as Map<String, dynamic>;
      }
    }
    return nestedMap;
  }

  void setFieldsValue(Map<String, dynamic> values) {
    void flatten(Map<String, dynamic> currentMap, String currentKey) {
      for (final entry in currentMap.entries) {
        final newKey = currentKey.isEmpty ? entry.key : '$currentKey.${entry.key}';
        if (entry.value is Map<String, dynamic>) {
          flatten(entry.value as Map<String, dynamic>, newKey);
        } else {
          _namedFields[newKey] = entry.value;
        }
      }
    }

    flatten(_namedFields, '');
  }
}