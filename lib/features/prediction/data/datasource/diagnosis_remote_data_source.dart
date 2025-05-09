import 'package:dio/dio.dart';
import '../../../../core/const/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/diagnosis_model.dart';

abstract class DiagnosisRemoteDataSource {
  Future<DiagnosisModel> getDiagnosis(Map<String, double> inputData);
}

class DiagnosisRemoteDataSourceImpl implements DiagnosisRemoteDataSource {
  final Dio dio;

  DiagnosisRemoteDataSourceImpl({required this.dio});

  @override
  Future<DiagnosisModel> getDiagnosis(Map<String, double> inputData) async {
    try {
      final response = await dio.post(
        '${AppStrings.apiBaseUrl}/predict',
        data: inputData,
      );

      if (response.statusCode == 200) {
        return DiagnosisModel.fromJson(response.data);
      } else if (response.statusCode == 400) {
        throw InvalidInputException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}