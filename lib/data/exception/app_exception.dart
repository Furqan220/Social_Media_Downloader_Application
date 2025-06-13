class AppExceptions implements Exception {
  final dynamic message;
  final dynamic prefix;

  const AppExceptions([this.message, this.prefix]);

  @override
  String toString() {
    return "${message ?? ''}";
    // return "$prefix ${message ?? ''}";
  }
}

class NoInternetException extends AppExceptions {
  NoInternetException([String? message])
      : super(message, "No Internet Connection");
}

class RequestTimeoutException extends AppExceptions {
  RequestTimeoutException([String? message])
      : super(message,
            "The request took too long to respond. Please try again later.");
}

class FetchDataException extends AppExceptions {
  FetchDataException([String? message])
      : super(message, "Error During Communication");
}

class BadRequestException extends AppExceptions {
  BadRequestException([String? message]) : super(message, "Invalid Request");
}

class UnExpectedError extends AppExceptions {
  UnExpectedError([String? message])
      : super(message,
            "An unexpected error occurred while processing. Please try again later.");
}

class UnauthorizedException extends AppExceptions {
  UnauthorizedException([String? message])
      : super(message, "Unauthorized request");
}

class SessionExpiredException extends AppExceptions {
  SessionExpiredException([String? message])
      : super(message, "Session Expired");
}
