import 'package:atherio/features/prediction/domain/usecases/get_all_dactors.dart';
import 'package:atherio/features/prediction/domain/usecases/search_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/diagnosis.dart';
import '../../domain/usecases/get_diagnosis.dart';
import '../../domain/usecases/save_diagnosis.dart';
import '../../domain/usecases/get_case_by_id.dart';

part 'diagnosis_event.dart';
part 'diagnosis_state.dart';

class DiagnosisBloc extends Bloc<DiagnosisEvent, DiagnosisState> {
  final GetDiagnosis getDiagnosis;
  final SaveDiagnosis saveDiagnosis;
  final SearchPatients searchPatients;
  final GetCaseById getCaseById;
  final GetAllDoctors getAllDoctors;

  DiagnosisBloc({
    required this.getDiagnosis,
    required this.saveDiagnosis,
    required this.searchPatients,
    required this.getCaseById,
    required this.getAllDoctors,
  }) : super(DiagnosisInitial()) {
    on<SubmitDiagnosisEvent>(_onSubmitDiagnosis);
    on<SearchPatientsEvent>(_onSearchPatients);
    on<GetCaseByIdEvent>(_onGetCaseById);
    on<GetAllDoctorsEvent>(_onGetAllDoctors);
    on<SelectPatientEvent>(_onSelectPatient);
  }

  Future<void> _onSubmitDiagnosis(
      SubmitDiagnosisEvent event, Emitter<DiagnosisState> emit) async {
    emit(DiagnosisLoading());
    try {
      const expectedKeys = [
        'Fold change of RAMP (logarithmic scale)',
        'Fold change of FENDRlogarithmic scale)',
        'triglycerides',
        'CKMB',
        'Troponin',
        'BMI',
        'age',
      ];
      final missingKeys = expectedKeys
          .where((key) => !event.inputData.containsKey(key))
          .toList();
      if (missingKeys.isNotEmpty) {
        debugPrint('Missing inputData keys: $missingKeys');
        emit(DiagnosisFailure(
            'Missing required fields: ${missingKeys.join(', ')}'));
        return;
      }

      final validatedInputData = <String, double>{};
      for (var entry in event.inputData.entries) {
        final value =
            entry.value is double ? entry.value : entry.value.toDouble();
        validatedInputData[entry.key] = value;
      }
      if (validatedInputData['age']! < 0) {
        emit(const DiagnosisFailure('Age cannot be negative'));
        return;
      }
      debugPrint('Validated inputData: $validatedInputData');

      final diagnosisResult = await getDiagnosis.call(validatedInputData);
      await diagnosisResult.fold(
        (failure) async {
          debugPrint('getDiagnosis failed: ${failure.message}');
          emit(DiagnosisFailure('API error: ${failure.message}'));
        },
        (diagnosis) async {
          final answers = validatedInputData.values.toList();
          final saveResult = await saveDiagnosis.call(SaveDiagnosisParams(
            doctorId: event.doctorId,
            patientName: event.patientName,
            patientPhoneNumber: event.patientPhoneNumber,
            questions: event.questions,
            answers: answers,
            diagnosis: diagnosis,
          ));
          await saveResult.fold(
            (failure) async {
              debugPrint('saveDiagnosis failed: ${failure.message}');
              emit(DiagnosisFailure(
                  'Failed to save diagnosis: ${failure.message}'));
            },
            (caseId) async {
              debugPrint('saveDiagnosis succeeded, caseId: $caseId');
              // Fetch full case data
              final caseResult = await getCaseById.call(caseId);
              await caseResult.fold(
                (failure) async {
                  debugPrint('getCaseById failed: ${failure.message}');
                  emit(DiagnosisFailure(
                      'Failed to fetch case data: ${failure.message}'));
                },
                (caseData) async {
                  debugPrint('Fetched case data: $caseData');
                  emit(DiagnosisSuccess(
                    diagnosis: diagnosis,
                    caseData: caseData,
                  ));
                },
              );
            },
          );
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Unexpected error in _onSubmitDiagnosis: $e\n$stackTrace');
      emit(
          DiagnosisFailure('Unexpected error during diagnosis submission: $e'));
    }
  }

  Future<void> _onSearchPatients(
      SearchPatientsEvent event, Emitter<DiagnosisState> emit) async {
    try {
      final result = await searchPatients.call(event.query);
      await result.fold(
        (failure) async {
          debugPrint('Search patients failed: ${failure.message}');
          emit(DiagnosisFailure(
              'Failed to search patients: ${failure.message}'));
        },
        (patients) async {
          debugPrint('Search patients succeeded: $patients');
          emit(SearchPatientsSuccess(patients));
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Unexpected error in _onSearchPatients: $e\n$stackTrace');
      emit(DiagnosisFailure('Unexpected error during patient search: $e'));
    }
  }

  Future<void> _onGetCaseById(
      GetCaseByIdEvent event, Emitter<DiagnosisState> emit) async {
    emit(DiagnosisLoading());
    try {
      final result = await getCaseById.call(event.caseId);
      await result.fold(
        (failure) async {
          debugPrint('Get case by ID failed: ${failure.message}');
          emit(DiagnosisFailure('Failed to fetch case: ${failure.message}'));
        },
        (caseData) async {
          debugPrint('Get case by ID succeeded: $caseData');
          emit(GetCaseByIdSuccess(caseData));
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Unexpected error in _onGetCaseById: $e\n$stackTrace');
      emit(DiagnosisFailure('Unexpected error during case fetch: $e'));
    }
  }

  Future<void> _onGetAllDoctors(
      GetAllDoctorsEvent event, Emitter<DiagnosisState> emit) async {
    emit(DiagnosisLoading());
    try {
      final result = await getAllDoctors.call(NoParams());
      await result.fold(
        (failure) async {
          debugPrint('Get all doctors failed: ${failure.message}');
          emit(DiagnosisFailure('Failed to fetch doctors: ${failure.message}'));
        },
        (doctors) async {
          debugPrint('Get all doctors succeeded: $doctors');
          emit(GetAllDoctorsSuccess(doctors));
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Unexpected error in _onGetAllDoctors: $e\n$stackTrace');
      emit(DiagnosisFailure('Unexpected error during doctors fetch: $e'));
    }
  }

  Future<void> _onSelectPatient(
      SelectPatientEvent event, Emitter<DiagnosisState> emit) async {
    try {
      final patientDoc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(event.patientId)
          .get();
      if (patientDoc.exists) {
        final data = patientDoc.data()!;
        emit(PatientSelectedSuccess(
          patientId: patientDoc.id,
          patientName: data['name'] as String? ?? '',
          patientPhoneNumber: data['phoneNumber'] as String? ?? '',
          patientAge: data.containsKey('age') ? data['age'] as int : 0,
        ));
      } else {
        emit(const DiagnosisFailure('Patient not found'));
      }
    } catch (e, stackTrace) {
      debugPrint('Error selecting patient: $e\n$stackTrace');
      emit(DiagnosisFailure('Failed to select patient: $e'));
    }
  }
}
