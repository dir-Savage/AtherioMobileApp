import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/diagnosis_model.dart';

abstract class DiagnosisLocalDataSource {
  Future<String> saveDiagnosis({
    required String doctorId,
    required String patientName,
    required String patientPhoneNumber,
    required List<String> questions,
    required List<double> answers,
    required DiagnosisModel diagnosis,
  });
}

class DiagnosisLocalDataSourceImpl implements DiagnosisLocalDataSource {
  final FirebaseFirestore firestore;

  DiagnosisLocalDataSourceImpl({required this.firestore});

  @override
  Future<String> saveDiagnosis({
    required String doctorId,
    required String patientName,
    required String patientPhoneNumber,
    required List<String> questions,
    required List<double> answers,
    required DiagnosisModel diagnosis,
  }) async {
    try {
      final caseDoc = firestore.collection('cases').doc();
      final timestamp = DateTime.now();

      final caseData = {
        'doctorId': doctorId,
        'patientName': patientName,
        'patientPhoneNumber': patientPhoneNumber,
        'questions': questions,
        'answers': answers,
        'primaryClassification': diagnosis.primaryClassification,
        'specificDiagnosis': diagnosis.specificDiagnosis,
        'createdAt': Timestamp.fromDate(timestamp),
      };

      await caseDoc.set(caseData);
      debugPrint('Saved case to Firestore: ${caseDoc.id}');

      final userDoc = firestore.collection('users').doc(doctorId);
      await userDoc.set({
        'list1': FieldValue.arrayUnion([caseDoc.id]),
      }, SetOptions(merge: true));
      debugPrint(
          'Updated users list1 for doctorId: $doctorId with caseId: ${caseDoc.id}');

      return caseDoc.id;
    } catch (e, stackTrace) {
      debugPrint('Error saving to Firestore: $e\n$stackTrace');
      throw ServerException();
    }
  }
}
