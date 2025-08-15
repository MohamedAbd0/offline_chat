class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException(this.message, {this.code, this.originalError});

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.originalError});
}

class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.code, super.originalError});
}

class ValidationException extends AppException {
  const ValidationException(super.message, {super.code, super.originalError});
}

class OllamaException extends AppException {
  const OllamaException(super.message, {super.code, super.originalError});
}

class ConnectionRefusedException extends NetworkException {
  const ConnectionRefusedException()
    : super('Unable to connect to Ollama server');
}

class OllamaVersionException extends OllamaException {
  const OllamaVersionException() : super('Requires newer Ollama version');
}

class StreamingCancelledException extends AppException {
  const StreamingCancelledException() : super('Streaming was cancelled');
}
