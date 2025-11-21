class ServerException implements Exception {
  final String message;
  const ServerException({this.message = 'Server Error'});
}

class CacheException implements Exception {}

class AuthException implements Exception {
  final String message;
  const AuthException({this.message = 'Authentication Failed'});
}

class TransactionException implements Exception {
  final String message;
  const TransactionException({this.message = 'Transaction Failed'});
}
