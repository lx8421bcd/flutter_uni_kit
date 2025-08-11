import 'dart:convert';

/// 判断类型[S]是否为[T]的子类
bool isSubtype<S, T> () => <S> [] is List<T>;

/// 是否为json字符串
bool isJsonString(String str) {
  try {
    jsonDecode(str);
  } catch (e) {
    return false;
  }
  return true;
}