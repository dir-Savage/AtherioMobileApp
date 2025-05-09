import 'package:atherio/core/errors/failtures.dart';
import 'package:atherio/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/const/core_usecase.dart';
import '../repository/auth_repository.dart';

class GetCurrentUser implements UseCase<User, NoParams> {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}