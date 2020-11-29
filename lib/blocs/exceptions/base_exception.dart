class BaseException implements Exception {
  final String message;

  BaseException(this.message);

  @override
  String toString() {
    // TODO: implement toString
    return message;
  }
}