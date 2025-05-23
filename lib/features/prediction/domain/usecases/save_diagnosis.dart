import 'package:atherio/core/errors/failtures.dart';
import 'package:atherio/features/prediction/domain/repository/diagnosis_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/const/core_usecase.dart';
import '../entities/diagnosis.dart';

class SaveDiagnosis
    implements UseCases<Either<Failure, String>, SaveDiagnosisParams> {
  final DiagnosisRepository repository;

  SaveDiagnosis(this.repository);

  @override
  Future<Either<Failure, String>> call(SaveDiagnosisParams params) async {
    return await repository.saveDiagnosis(
      doctorId: params.doctorId,
      patientName: params.patientName,
      patientPhoneNumber: params.patientPhoneNumber,
      questions: params.questions,
      answers: params.answers,
      diagnosis: params.diagnosis,
    );
  }
}

class SaveDiagnosisParams {
  final String doctorId;
  final String patientName;
  final String patientPhoneNumber;
  final List<String> questions;
  final List<double> answers;
  final Diagnosis diagnosis;

  SaveDiagnosisParams({
    required this.doctorId,
    required this.patientName,
    required this.patientPhoneNumber,
    required this.questions,
    required this.answers,
    required this.diagnosis,
  });
}
