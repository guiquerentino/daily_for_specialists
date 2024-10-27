import '../../../domain/models/emotion_count_dto.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  List<EmotionCountDto> emotionCount;

  HomeLoaded({
    required this.emotionCount
  });

}

final class HomeError extends HomeState {
  String message;

  HomeError({
    required this.message
  });
}