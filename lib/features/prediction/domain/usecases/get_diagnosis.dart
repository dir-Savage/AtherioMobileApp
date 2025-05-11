import 'package:atherio/core/errors/failtures.dart';
import 'package:atherio/features/prediction/domain/repository/diagnosis_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/const/core_usecase.dart';
import '../entities/diagnosis.dart';

class GetDiagnosis
    implements UseCases<Either<Failure, Diagnosis>, Map<String, double>> {
  final DiagnosisRepository repository;

  GetDiagnosis(this.repository);

  @override
  Future<Either<Failure, Diagnosis>> call(Map<String, double> params) async {
    return await repository.getDiagnosis(params);
  }
}
