import 'package:dartz/dartz.dart';
import '../../../../core/errors/failtures.dart';
import '../entities/diagnosis.dart';

abstract class DiagnosisRepository {
  Future<Either<Failure, Diagnosis>> getDiagnosis(Map<String, double> inputData);
  Future<Either<Failure, String>> saveDiagnosis({
    required String doctorId,
    required String patientName,
    required String patientPhoneNumber,
    required List<String> questions,
    required List<double> answers,
    required Diagnosis diagnosis,
  });
}