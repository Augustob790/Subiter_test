sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'Falha de comunicação com a API.']);
}

final class DataException extends AppException {
  const DataException([super.message = 'Dados inválidos.']);
}
