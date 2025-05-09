import 'package:atherio/core/errors/network_info.dart';
import 'package:atherio/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:atherio/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:atherio/features/auth/domain/repository/auth_repository.dart';
import 'package:atherio/features/auth/domain/usecases/get_current_user.dart';
import 'package:atherio/features/auth/domain/usecases/login_usecase.dart';
import 'package:atherio/features/auth/domain/usecases/reg_usecase.dart';
import 'package:atherio/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../domain/usecases/forget_pwd.dart';
import '../../domain/usecases/reset_pwd.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker());

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl<InternetConnectionChecker>()));

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<Register>(() => Register(sl<AuthRepository>()));
  sl.registerLazySingleton<Login>(() => Login(sl<AuthRepository>()));
  sl.registerLazySingleton<ForgotPassword>(() => ForgotPassword(sl<AuthRepository>()));
  sl.registerLazySingleton<ResetPassword>(() => ResetPassword(sl<AuthRepository>()));
  sl.registerLazySingleton<GetCurrentUser>(() => GetCurrentUser(sl<AuthRepository>()));

  // Bloc
  sl.registerFactory<AuthBloc>(
        () => AuthBloc(
      register: sl<Register>(),
      login: sl<Login>(),
      forgotPassword: sl<ForgotPassword>(),
      resetPassword: sl<ResetPassword>(),
      getCurrentUser: sl<GetCurrentUser>(),
    ),
  );
}