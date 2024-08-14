class UnableToContinueException implements Exception {
  final String message;

  UnableToContinueException(this.message);

  @override
  String toString() {
    return 'UnableToContinueException: $message';
  }
}
