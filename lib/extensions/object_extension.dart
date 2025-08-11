/// 所有对象的扩展方法
extension ObjectExtension<T> on T? {

  dynamic let(void Function(T it) method) {
    if (this != null) {
      method.call(this as T);
    }
  }
}