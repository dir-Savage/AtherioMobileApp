import 'package:atherio/core/errors/failtures.dart';
import 'package:dartz/dartz.dart';
import '../entities/diagnosis.dart';

abstract class DiagnosisRepository {
  Future<Either<Failure, Diagnosis>> getDiagnosis(
      Map<String, double> inputData);
  Future<Either<Failure, String>> saveDiagnosis({
    required String doctorId,
    required String patientName,
    required String patientPhoneNumber,
    required List<String> questions,
    required List<double> answers,
    required Diagnosis diagnosis,
  });
  Future<Either<Failure, List<Map<String, dynamic>>>> searchPatients(
      String query);
  Future<Either<Failure, Map<String, dynamic>>> getCaseById(String caseId);
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllDoctors();
}
