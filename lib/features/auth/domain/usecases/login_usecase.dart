import 'package:atherio/core/errors/failtures.dart';
import 'package:atherio/features/auth/domain/entities/user_entity.dart';
import 'package:atherio/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/const/core_usecase.dart';


class Login implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  Login(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({
    required this.email,
    required this.password,
  });
}