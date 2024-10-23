sealed class OnboardingState {}

final class OnboardingInitial extends OnboardingState {}

final class OnboardingProcessing extends OnboardingState {}

final class OnboardingSuccessful extends OnboardingState {}

final class OnboardingError extends OnboardingState {
  final String message;
  final int status;

  OnboardingError({required this.message, required this.status});
}
