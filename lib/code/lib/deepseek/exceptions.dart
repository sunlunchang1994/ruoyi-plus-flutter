/// Base class for API exceptions.
class ApiException implements Exception {
  /// The error message associated with the exception.
  final String message;

  /// Creates an [ApiException] with the given [message].
  ApiException(this.message);
}

/// Exception thrown when a network error occurs.
class NetworkException extends ApiException {
  /// Creates a [NetworkException] with the given [message].
  NetworkException(super.message);
}

/// Exception thrown when the API returns a bad request error.
class BadRequestException extends ApiException {
  /// Creates a [BadRequestException] with the given [message].
  BadRequestException(super.message);
}

/// Exception thrown when the API returns an unauthorized error.
class UnauthorizedException extends ApiException {
  /// Creates an [UnauthorizedException] with the given [message].
  UnauthorizedException(super.message);
}

/// Exception thrown when the API returns a rate limit error.
class RateLimitException extends ApiException {
  /// Creates a [RateLimitException] with the given [message].
  RateLimitException(super.message);
}

/// Exception thrown when the API returns a server error.
class ServerException extends ApiException {
  /// Creates a [ServerException] with the given [message].
  ServerException(super.message);
}

/// Exception thrown when the API returns an insufficient balance error.
class InsufficientBalanceException extends ApiException {
  /// Creates an [InsufficientBalanceException] with the given [message].
  InsufficientBalanceException(super.message);
}
