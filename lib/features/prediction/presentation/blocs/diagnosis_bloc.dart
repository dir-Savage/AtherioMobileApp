import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/diagnosis.dart';
import '../../domain/usecases/get_diagnosis.dart';
import '../../domain/usecases/save_diagnosis.dart';
part 'diagnosis_event.dart';
part 'diagnosis_state.dart';

class DiagnosisBloc extends Bloc<DiagnosisEvent, DiagnosisState> {
  final GetDiagnosis getDiagnosis;
  final SaveDiagnosis saveDiagnosis;

  DiagnosisBloc({
    required this.getDiagnosis,
    required this.saveDiagnosis,
  }) : super(DiagnosisInitial()) {
    on<SubmitDiagnosisEvent>(_onSubmitDiagnosis);
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
      debugPrint('Validated inputData: $validatedInputData');

      debugPrint('Calling getDiagnosis with inputData: $validatedInputData');
      final diagnosisResult = await getDiagnosis.call(validatedInputData);
      await diagnosisResult.fold(
        (failure) async {
          debugPrint('getDiagnosis failed: ${failure.message}');
          emit(DiagnosisFailure('API error: ${failure.message}'));
        },
        (diagnosis) async {
          final answers = validatedInputData.values.toList();
          debugPrint('Calling saveDiagnosis with answers: $answers');
          final saveResult = await saveDiagnosis.call(SaveDiagnosisParams(
            doctorId: event.doctorId,
            patientName: event.patientName,
            patientPhoneNumber: event.patientPhoneNumber,
            questions: event.questions,
            answers: answers,
            diagnosis: diagnosis,
          ));
          saveResult.fold(
            (failure) {
              debugPrint('saveDiagnosis failed: ${failure.message}');
              emit(DiagnosisFailure('Save error: ${failure.message}'));
            },
            (caseId) {
              debugPrint('saveDiagnosis succeeded, caseId: $caseId');
              emit(DiagnosisSuccess(diagnosis));
            },
          );
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Unexpected error in _onSubmitDiagnosis: $e\n$stackTrace');
      emit(DiagnosisFailure('Unexpected error: $e'));
    }
  }
}
