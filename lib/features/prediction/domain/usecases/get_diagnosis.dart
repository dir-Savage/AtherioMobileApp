import 'package:dartz/dartz.dart';
import '../../../../core/const/core_usecase.dart';
import '../../../../core/errors/failtures.dart';
import '../entities/diagnosis.dart';
import '../repository/diagnosis_repository.dart';

class GetDiagnosis implements UsCase<Either<Failure, Diagnosis>, Map<String, double>> {
  final DiagnosisRepository repository;

  GetDiagnosis(this.repository);

  @override
  Future<Either<Failure, Diagnosis>> call(Map<String, double> params) async {
    return await repository.getDiagnosis(params);
  }
}