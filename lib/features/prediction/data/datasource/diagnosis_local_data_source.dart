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

  Future<List<Map<String, dynamic>>> searchPatients(String query);

  Future<Map<String, dynamic>> getCaseById(String caseId);

  Future<List<Map<String, dynamic>>> getAllDoctors();
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
      // Validate inputs
      if (patientName.isEmpty || patientPhoneNumber.isEmpty) {
        throw ServerException();
      }
      if (answers.length < 7) {
        throw ServerException();
      }

      // Extract age from answers (index 6)
      final patientAge = answers[6].toInt();
      if (patientAge < 0) {
        throw ServerException();
      }

      // Start a Firestore batch
      final batch = firestore.batch();

      // Handle patient
      final patientQuery = await firestore
          .collection('patients')
          .where('phoneNumber', isEqualTo: patientPhoneNumber)
          .limit(1)
          .get();

      String patientId;
      if (patientQuery.docs.isEmpty) {
        final patientDoc = firestore.collection('patients').doc();
        patientId = patientDoc.id;
        batch.set(patientDoc, {
          'name': patientName,
          'phoneNumber': patientPhoneNumber,
          'age': patientAge,
          'cases': [],
          'createdAt': Timestamp.fromDate(DateTime.now()),
        });
      } else {
        patientId = patientQuery.docs.first.id;
        final patientDoc = firestore.collection('patients').doc(patientId);
        batch.update(patientDoc, {
          'name': patientName,
          'age': patientAge,
        });
      }

      // Create case
      final caseDoc = firestore.collection('cases').doc();
      final caseData = {
        'doctorId': doctorId,
        'patientId': patientId,
        'patientName': patientName,
        'patientPhoneNumber': patientPhoneNumber,
        'patientAge': patientAge,
        'questions': questions,
        'answers': answers,
        'primaryClassification': diagnosis.primaryClassification,
        'specificDiagnosis': diagnosis.specificDiagnosis,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      };
      batch.set(caseDoc, caseData);
      debugPrint('Prepared case: ${caseDoc.id}');

      // Update patient's cases
      final patientDoc = firestore.collection('patients').doc(patientId);
      batch.update(patientDoc, {
        'cases': FieldValue.arrayUnion([caseDoc.id]),
      });

      // Update doctor's list1
      final userDoc = firestore.collection('users').doc(doctorId);
      batch.update(userDoc, {
        'list1': FieldValue.arrayUnion([caseDoc.id]),
      });

      // Commit batch
      await batch.commit();
      debugPrint('Batch committed for caseId: ${caseDoc.id}');

      return caseDoc.id;
    } catch (e, stackTrace) {
      debugPrint('Error saving to Firestore: $e\n$stackTrace');
      throw ServerException();
    }
  }

  @override
  Future<List<Map<String, dynamic>>> searchPatients(String query) async {
    try {
      if (query.isEmpty) {
        return [];
      }

      final nameQuery = await firestore
          .collection('patients')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      final phoneQuery = await firestore
          .collection('patients')
          .where('phoneNumber', isEqualTo: query)
          .get();

      final results = <String, Map<String, dynamic>>{};
      for (var doc in nameQuery.docs) {
        results[doc.id] = {
          'id': doc.id,
          'name': doc['name'] as String,
          'phoneNumber': doc['phoneNumber'] as String,
          'age': doc.data().containsKey('age') ? doc['age'] as int : 0,
          'cases': List<String>.from(doc['cases'] ?? []),
          'createdAt': (doc['createdAt'] as Timestamp).toDate(),
        };
      }
      for (var doc in phoneQuery.docs) {
        results[doc.id] = {
          'id': doc.id,
          'name': doc['name'] as String,
          'phoneNumber': doc['phoneNumber'] as String,
          'age': doc.data().containsKey('age') ? doc['age'] as int : 0,
          'cases': List<String>.from(doc['cases'] ?? []),
          'createdAt': (doc['createdAt'] as Timestamp).toDate(),
        };
      }

      debugPrint('Search results: ${results.values.toList()}');
      return results.values.toList();
    } catch (e, stackTrace) {
      debugPrint('Error searching patients: $e\n$stackTrace');
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getCaseById(String caseId) async {
    try {
      if (caseId.isEmpty) {
        throw ServerException();
      }
      final caseDoc = await firestore.collection('cases').doc(caseId).get();
      if (!caseDoc.exists) {
        throw ServerException();
      }

      final data = caseDoc.data()!;
      return {
        'id': caseDoc.id,
        'doctorId': data['doctorId'] as String? ?? '',
        'patientId': data['patientId'] as String? ?? '',
        'patientName': data['patientName'] as String? ?? '',
        'patientPhoneNumber': data['patientPhoneNumber'] as String? ?? '',
        'patientAge': data['patientAge'] as int? ??
            (data['answers']?.length > 6 ? data['answers'][6].toInt() : 0),
        'questions': List<String>.from(data['questions'] ?? []),
        'answers': List<double>.from(data['answers'] ?? []),
        'primaryClassification': data['primaryClassification'] as String? ?? '',
        'specificDiagnosis': data['specificDiagnosis'] as String? ?? '',
        'createdAt':
            (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      };
    } catch (e, stackTrace) {
      debugPrint('Error fetching case $caseId: $e\n$stackTrace');
      throw ServerException();
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllDoctors() async {
    try {
      final querySnapshot = await firestore.collection('users').get();
      final doctors = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'firstName': data['firstName'] as String? ?? '',
          'lastName': data['lastName'] as String? ?? '',
          'email': data['email'] as String? ?? '',
          'list1': List<String>.from(data['list1'] ?? []),
          'list2': List<String>.from(data['list2'] ?? []),
          'createdAt':
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        };
      }).toList();

      debugPrint('Fetched doctors: $doctors');
      return doctors;
    } catch (e, stackTrace) {
      debugPrint('Error fetching doctors: $e\n$stackTrace');
      throw ServerException();
    }
  }
}
