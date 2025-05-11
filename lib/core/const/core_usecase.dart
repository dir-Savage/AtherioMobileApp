import 'package:atherio/core/errors/failtures.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}

abstract class UsCase<Type, Params> {
  Future<Type> call(Params params);
}

class NoParam {}

abstract class UseCases<Type, Params> {
  Future<Type> call(Params params);
}
