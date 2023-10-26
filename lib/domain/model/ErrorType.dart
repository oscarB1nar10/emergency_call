
abstract class ErrorType {
  final String message;

  const ErrorType(this.message);

  @override
  String toString() => message;
}

class BadRequestError extends ErrorType {
  BadRequestError(String message) : super(message);
}

class UnauthorizedError extends ErrorType {
  UnauthorizedError(String message) : super(message);
}

class FetchDataError extends ErrorType {
  FetchDataError(String message) : super(message);
}

class TimeOutError extends ErrorType {
  TimeOutError(String message) : super(message);
}

class None extends ErrorType {
  const None(String message) : super("");
}
