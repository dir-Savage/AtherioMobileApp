import 'package:atherio/core/errors/failtures.dart';
import 'package:atherio/features/prediction/domain/repository/diagnosis_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/const/core_usecase.dart';

class GetCaseById
    implements UseCases<Either<Failure, Map<String, dynamic>>, String> {
  final DiagnosisRepository repository;

  GetCaseById(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(String caseId) async {
    return await repository.getCaseById(caseId);
  }
}
