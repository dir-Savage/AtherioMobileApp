import 'package:atherio/core/errors/network_info.dart';
import 'package:atherio/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:atherio/features/auth/domain/repository/auth_repository.dart';
import 'package:atherio/features/auth/domain/usecases/forget_pwd.dart';
import 'package:atherio/features/auth/domain/usecases/login_usecase.dart';
import 'package:atherio/features/auth/domain/usecases/reg_usecase.dart';
import 'package:atherio/features/auth/domain/usecases/reset_pwd.dart';
import 'package:atherio/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:atherio/features/prediction/data/datasource/diagnosis_local_data_source.dart';
import 'package:atherio/features/prediction/data/datasource/diagnosis_remote_data_source.dart';
import 'package:atherio/features/prediction/data/repositories/diagnosis_repository_impl.dart';
import 'package:atherio/features/prediction/domain/repository/diagnosis_repository.dart';
import 'package:atherio/features/prediction/domain/usecases/get_diagnosis.dart';
import 'package:atherio/features/prediction/domain/usecases/save_diagnosis.dart';
import 'package:atherio/features/prediction/presentation/blocs/diagnosis_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Network
  getIt.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  // Firebase
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Dio
  getIt.registerLazySingleton<Dio>(() => Dio());

  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
      firebaseAuth: getIt(),
      firestore: getIt(),
    ),
  );
  getIt.registerLazySingleton<DiagnosisRemoteDataSource>(
        () => DiagnosisRemoteDataSourceImpl(dio: getIt()),
  );
  getIt.registerLazySingleton<DiagnosisLocalDataSource>(
        () => DiagnosisLocalDataSourceImpl(firestore: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  getIt.registerLazySingleton<DiagnosisRepository>(
        () => DiagnosisRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => Register(getIt()));
  getIt.registerLazySingleton(() => Login(getIt()));
  getIt.registerLazySingleton(() => ForgotPassword(getIt()));
  getIt.registerLazySingleton(() => ResetPassword(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUser(getIt()));
  getIt.registerLazySingleton(() => GetDiagnosis(getIt()));
  getIt.registerLazySingleton(() => SaveDiagnosis(getIt()));

  // Blocs
  getIt.registerFactory(() => AuthBloc(
    register: getIt(),
    login: getIt(),
    forgotPassword: getIt(),
    resetPassword: getIt(),
    getCurrentUser: getIt(),
  ));
  getIt.registerFactory(() => DiagnosisBloc(
    getDiagnosis: getIt(),
    saveDiagnosis: getIt(),
  ));
}