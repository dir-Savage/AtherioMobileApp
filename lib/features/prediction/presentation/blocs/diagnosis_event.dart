part of 'diagnosis_bloc.dart';

abstract class DiagnosisEvent extends Equatable {
  const DiagnosisEvent();

  @override
  List<Object> get props => [];
}

class SubmitDiagnosisEvent extends DiagnosisEvent {
  final String doctorId;
  final String patientName;
  final String patientPhoneNumber;
  final Map<String, double> inputData;
  final List<String> questions;

  const SubmitDiagnosisEvent({
    required this.doctorId,
    required this.patientName,
    required this.patientPhoneNumber,
    required this.inputData,
    required this.questions,
  });

  @override
  List<Object> get props =>
      [doctorId, patientName, patientPhoneNumber, inputData, questions];
}
