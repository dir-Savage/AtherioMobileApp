import 'package:atherio/core/errors/failtures.dart';
import 'package:atherio/features/auth/domain/entities/user_entity.dart';
import 'package:atherio/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/const/core_usecase.dart';


class Register implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  Register(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(
      params.firstName,
      params.lastName,
      params.email,
      params.password,
    );
  }
}

class RegisterParams {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  RegisterParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });
}