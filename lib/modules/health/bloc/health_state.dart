import '../../../domain/models/patient_dto.dart';

sealed class HealthState {}

class HealthInitial extends HealthState {}

class HealthLoading extends HealthState {}

class HealthLoaded extends HealthState {
  final PatientDto patient;

  HealthLoaded({required this.patient});
}

class HealthError extends HealthState {
  final String message;

  HealthError({required this.message});
}
