part of 'diagnosis_bloc.dart';

abstract class DiagnosisState extends Equatable {
  const DiagnosisState();

  @override
  List<Object> get props => [];
}

class DiagnosisInitial extends DiagnosisState {}

class DiagnosisLoading extends DiagnosisState {}

class DiagnosisSuccess extends DiagnosisState {
  final Diagnosis diagnosis;

  const DiagnosisSuccess(this.diagnosis);

  @override
  List<Object> get props => [diagnosis];
}

class DiagnosisFailure extends DiagnosisState {
  final String message;

  const DiagnosisFailure(this.message);

  @override
  List<Object> get props => [message];
}
