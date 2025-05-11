import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
        'https://db80-156-197-174-251.ngrok-free.app/predict',
        data: inputData,
      );
      debugPrint(
          'API response: ${response.data}, status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return DiagnosisModel.fromJson(response.data);
      } else if (response.statusCode == 400) {
        throw InvalidInputException();
      } else {
        throw ServerException();
      }
    } catch (e, stackTrace) {
      debugPrint('Error in getDiagnosis: $e\n$stackTrace');
      throw ServerException();
    }
  }
}
