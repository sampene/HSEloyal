class ServerException implements Exception {
  @override
  String toString() {
    return "A server error occurred.";
  }
}