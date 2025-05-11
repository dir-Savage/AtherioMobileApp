import 'package:atherio/core/errors/failtures.dart';
import 'package:atherio/features/prediction/domain/repository/diagnosis_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/const/core_usecase.dart';

class GetAllDoctors
    implements UseCases<Either<Failure, List<Map<String, dynamic>>>, NoParams> {
  final DiagnosisRepository repository;

  GetAllDoctors(this.repository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(
      NoParams params) async {
    return await repository.getAllDoctors();
  }
}

class NoParams {}
