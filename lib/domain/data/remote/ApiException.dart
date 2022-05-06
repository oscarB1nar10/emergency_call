class ApiException implements Exception {
  final _message;
  final _prefix;

  ApiException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends ApiException {
  FetchDataException(String message)
      : super(message, "Error During communication: ");
}

class BadRequestException extends ApiException {
  BadRequestException(String message) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends ApiException {
  UnauthorisedException(String message) : super(message, "Unauthorised: ");
}

class InvalidInputException extends ApiException {
  InvalidInputException(String message) : super(message, "Invalid Input: ");
}
