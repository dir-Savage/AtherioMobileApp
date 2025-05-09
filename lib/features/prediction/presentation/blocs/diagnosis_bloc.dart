import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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

  Future<void> _onSubmitDiagnosis(SubmitDiagnosisEvent event, Emitter<DiagnosisState> emit) async {
    emit(DiagnosisLoading());
    final diagnosisResult = await getDiagnosis.call(event.inputData);
    await diagnosisResult.fold(
          (failure) async => emit(DiagnosisFailure(failure.message)),
          (diagnosis) async {
        final saveResult = await saveDiagnosis.call(SaveDiagnosisParams(
          doctorId: event.doctorId,
          patientName: event.patientName,
          patientPhoneNumber: event.patientPhoneNumber,
          questions: event.questions,
          answers: event.inputData.values.toList(),
          diagnosis: diagnosis,
        ));
        saveResult.fold(
              (failure) => emit(DiagnosisFailure(failure.message)),
              (_) => emit(DiagnosisSuccess(diagnosis)),
        );
      },
    );
  }
}