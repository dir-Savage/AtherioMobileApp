abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class EmailAlreadyInUseFailure extends Failure {
  EmailAlreadyInUseFailure(String message) : super(message);
}

class InvalidEmailAndPasswordFailure extends Failure {
  InvalidEmailAndPasswordFailure(String message) : super(message);
}

class UserNotLoggedInFailure extends Failure {
  UserNotLoggedInFailure(String message) : super(message);
}

class InvalidInputFailure extends Failure {
  InvalidInputFailure(String message) : super(message);
}
