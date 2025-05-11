import 'package:atherio/core/errors/network_info.dart';
import 'package:atherio/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:atherio/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:atherio/features/auth/domain/repository/auth_repository.dart';
import 'package:atherio/features/auth/domain/usecases/forget_pwd.dart';
import 'package:atherio/features/auth/domain/usecases/get_current_user.dart';
import 'package:atherio/features/auth/domain/usecases/login_usecase.dart';
import 'package:atherio/features/auth/domain/usecases/reg_usecase.dart';
import 'package:atherio/features/auth/domain/usecases/reset_pwd.dart';
import 'package:atherio/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:atherio/features/prediction/data/datasource/diagnosis_local_data_source.dart';
import 'package:atherio/features/prediction/data/datasource/diagnosis_remote_data_source.dart';
import 'package:atherio/features/prediction/data/repositories/diagnosis_repository_impl.dart';
import 'package:atherio/features/prediction/domain/repository/diagnosis_repository.dart';
import 'package:atherio/features/prediction/domain/usecases/get_all_dactors.dart';
import 'package:atherio/features/prediction/domain/usecases/get_diagnosis.dart';
import 'package:atherio/features/prediction/domain/usecases/save_diagnosis.dart';
import 'package:atherio/features/prediction/domain/usecases/get_case_by_id.dart';
import 'package:atherio/features/prediction/domain/usecases/search_usecase.dart';
import 'package:atherio/features/prediction/presentation/blocs/diagnosis_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
  sl.registerLazySingleton<Dio>(() => Dio());

  // Core
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(sl<InternetConnectionChecker>()));

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  sl.registerLazySingleton<DiagnosisLocalDataSource>(
    () => DiagnosisLocalDataSourceImpl(
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  sl.registerLazySingleton<DiagnosisRemoteDataSource>(
    () => DiagnosisRemoteDataSourceImpl(
      dio: sl<Dio>(),
    ),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  sl.registerLazySingleton<DiagnosisRepository>(
    () => DiagnosisRepositoryImpl(
      remoteDataSource: sl<DiagnosisRemoteDataSource>(),
      localDataSource: sl<DiagnosisLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<Register>(() => Register(sl<AuthRepository>()));
  sl.registerLazySingleton<Login>(() => Login(sl<AuthRepository>()));
  sl.registerLazySingleton<ForgotPassword>(
      () => ForgotPassword(sl<AuthRepository>()));
  sl.registerLazySingleton<ResetPassword>(
      () => ResetPassword(sl<AuthRepository>()));
  sl.registerLazySingleton<GetCurrentUser>(
      () => GetCurrentUser(sl<AuthRepository>()));
  sl.registerLazySingleton<GetDiagnosis>(
      () => GetDiagnosis(sl<DiagnosisRepository>()));
  sl.registerLazySingleton<SaveDiagnosis>(
      () => SaveDiagnosis(sl<DiagnosisRepository>()));
  sl.registerLazySingleton<SearchPatients>(
      () => SearchPatients(sl<DiagnosisRepository>()));
  sl.registerLazySingleton<GetCaseById>(
      () => GetCaseById(sl<DiagnosisRepository>()));
  sl.registerLazySingleton<GetAllDoctors>(
      () => GetAllDoctors(sl<DiagnosisRepository>()));

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

  sl.registerFactory<DiagnosisBloc>(
    () => DiagnosisBloc(
      getDiagnosis: sl<GetDiagnosis>(),
      saveDiagnosis: sl<SaveDiagnosis>(),
      searchPatients: sl<SearchPatients>(),
      getCaseById: sl<GetCaseById>(),
      getAllDoctors: sl<GetAllDoctors>(),
    ),
  );
}
