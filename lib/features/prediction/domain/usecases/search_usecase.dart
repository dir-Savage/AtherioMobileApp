import 'package:atherio/core/errors/failtures.dart';
import 'package:atherio/features/prediction/domain/repository/diagnosis_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/const/core_usecase.dart';

class SearchPatients
    implements UseCases<Either<Failure, List<Map<String, dynamic>>>, String> {
  final DiagnosisRepository repository;

  SearchPatients(this.repository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(String query) async {
    return await repository.searchPatients(query);
  }
}
