import 'package:atherio/core/errors/failtures.dart';
import 'package:atherio/core/errors/network_info.dart';
import 'package:atherio/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:atherio/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/const/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> register(String firstName, String lastName, String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.register(firstName, lastName, email, password);
        return Right(user);
      } on EmailAlreadyInUseException {
        return Left(EmailAlreadyInUseFailure(AppStrings.unexpectedError));
      } on ServerException {
        return Left(ServerFailure(AppStrings.unexpectedError));
      }
    }
    return Left(ServerFailure('No internet connection'));
  }

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.login(email, password);
        return Right(user);
      } on InvalidEmailAndPasswordCombinationException {
        return Left(InvalidEmailAndPasswordFailure(AppStrings.unexpectedError));
      } on ServerException {
        return Left(ServerFailure(AppStrings.unexpectedError));
      }
    }
    return Left(ServerFailure('No internet connection'));
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.forgotPassword(email);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure(AppStrings.unexpectedError));
      }
    }
    return Left(ServerFailure('No internet connection'));
  }

  @override
  Future<Either<Failure, void>> resetPassword(String newPassword) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resetPassword(newPassword);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure(AppStrings.unexpectedError));
      }
    }
    return Left(ServerFailure('No internet connection'));
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.getCurrentUser();
        return Right(user);
      } on UserNotLoggedInException {
        return Left(UserNotLoggedInFailure(AppStrings.unexpectedError));
      } on ServerException {
        return Left(ServerFailure(AppStrings.unexpectedError));
      }
    }
    return Left(ServerFailure('No internet connection'));
  }
}