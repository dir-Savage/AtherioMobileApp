import 'package:atherio/core/errors/failtures.dart';
import 'package:atherio/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/const/core_usecase.dart';

class ResetPassword implements UseCase<void, String> {
  final AuthRepository repository;

  ResetPassword(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.resetPassword(params);
  }
}