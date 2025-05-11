import '../../domain/entities/diagnosis.dart';

class DiagnosisModel extends Diagnosis {
  DiagnosisModel({
    required String primaryClassification,
    required String specificDiagnosis,
  }) : super(
          primaryClassification: primaryClassification,
          specificDiagnosis: specificDiagnosis,
        );

  factory DiagnosisModel.fromJson(Map<String, dynamic> json) {
    return DiagnosisModel(
      primaryClassification: json['primary_classification'] as String,
      specificDiagnosis: json['specific_diagnosis'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primary_classification': primaryClassification,
      'specific_diagnosis': specificDiagnosis,
    };
  }
}
