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

class SearchPatientsSuccess extends DiagnosisState {
  final List<Map<String, dynamic>> patients;

  const SearchPatientsSuccess(this.patients);

  @override
  List<Object> get props => [patients];
}

class GetCaseByIdSuccess extends DiagnosisState {
  final Map<String, dynamic> caseData;

  const GetCaseByIdSuccess(this.caseData);

  @override
  List<Object> get props => [caseData];
}

class GetAllDoctorsSuccess extends DiagnosisState {
  final List<Map<String, dynamic>> doctors;

  const GetAllDoctorsSuccess(this.doctors);

  @override
  List<Object> get props => [doctors];
}

class PatientSelectedSuccess extends DiagnosisState {
  final String patientId;
  final String patientName;
  final String patientPhoneNumber;
  final int patientAge;

  const PatientSelectedSuccess({
    required this.patientId,
    required this.patientName,
    required this.patientPhoneNumber,
    required this.patientAge,
  });

  @override
  List<Object> get props =>
      [patientId, patientName, patientPhoneNumber, patientAge];
}
