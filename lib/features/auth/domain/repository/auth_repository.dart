import 'package:dartz/dartz.dart';
import '../../../../core/errors/failtures.dart';

import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> register(String firstName, String lastName, String email, String password);
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, void>> resetPassword(String newPassword);
  Future<Either<Failure, User>> getCurrentUser();
}