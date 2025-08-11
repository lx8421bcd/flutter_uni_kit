

typedef MessageParser<T> = String Function(T e);

class ErrorMessageHandler {

  static final ErrorMessageHandler _instance = ErrorMessageHandler._internal();
  factory ErrorMessageHandler() => _instance;

  final _messageParsers = <Type, dynamic>{};

  ErrorMessageHandler._internal();

  String getMessage(dynamic e) {
    var parser = _messageParsers[e.runtimeType];
    if (parser != null) {
      return parser.call(e);
    }
    return e.toString();
  }

  void addExceptionParser<T extends Exception>(MessageParser<T> parser) {
    _messageParsers[T] = parser;
  }
  void addErrorParser<T extends Error>(MessageParser<T> parser) {
    _messageParsers[T] = parser;
  }
}

extension ExceptionExtension on Exception {

  String getMessage() {
    return ErrorMessageHandler().getMessage(this);
  }
}

extension ErrorExtension on Error {

  String getMessage() {
    return ErrorMessageHandler().getMessage(this);
  }

}