import 'package:atherio/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/const/core_usecase.dart';
import '../../../../core/errors/failtures.dart';

class ForgotPassword implements UseCase<void, String> {
  final AuthRepository repository;

  ForgotPassword(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.forgotPassword(params);
  }
}