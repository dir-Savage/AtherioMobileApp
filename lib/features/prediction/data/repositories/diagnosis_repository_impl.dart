import 'package:atherio/core/errors/failtures.dart';
import 'package:atherio/features/prediction/data/datasource/diagnosis_local_data_source.dart';
import 'package:atherio/features/prediction/data/datasource/diagnosis_remote_data_source.dart';
import 'package:atherio/features/prediction/domain/repository/diagnosis_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/const/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/network_info.dart';
import '../../domain/entities/diagnosis.dart';
import '../models/diagnosis_model.dart';

class DiagnosisRepositoryImpl implements DiagnosisRepository {
  final DiagnosisRemoteDataSource remoteDataSource;
  final DiagnosisLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  DiagnosisRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Diagnosis>> getDiagnosis(
      Map<String, double> inputData) async {
    if (await networkInfo.isConnected) {
      try {
        final diagnosis = await remoteDataSource.getDiagnosis(inputData);
        return Right(diagnosis);
      } on InvalidInputException {
        return Left(InvalidInputFailure(AppStrings.unexpectedError));
      } on ServerException {
        return Left(ServerFailure(AppStrings.unexpectedError));
      }
    }
    return Left(ServerFailure('No internet connection'));
  }

  @override
  Future<Either<Failure, String>> saveDiagnosis({
    required String doctorId,
    required String patientName,
    required String patientPhoneNumber,
    required List<String> questions,
    required List<double> answers,
    required Diagnosis diagnosis,
  }) async {
    try {
      final caseId = await localDataSource.saveDiagnosis(
        doctorId: doctorId,
        patientName: patientName,
        patientPhoneNumber: patientPhoneNumber,
        questions: questions,
        answers: answers,
        diagnosis: diagnosis as DiagnosisModel,
      );
      return Right(caseId);
    } on ServerException {
      return Left(ServerFailure(AppStrings.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> searchPatients(
      String query) async {
    try {
      final patients = await localDataSource.searchPatients(query);
      return Right(patients);
    } on ServerException {
      return Left(ServerFailure(AppStrings.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCaseById(
      String caseId) async {
    try {
      final caseData = await localDataSource.getCaseById(caseId);
      return Right(caseData);
    } on ServerException {
      return Left(ServerFailure(AppStrings.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllDoctors() async {
    try {
      final doctors = await localDataSource.getAllDoctors();
      return Right(doctors);
    } on ServerException {
      return Left(ServerFailure(AppStrings.unexpectedError));
    }
  }
}
