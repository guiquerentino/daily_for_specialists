import '../../../domain/models/article_dto.dart';

sealed class ArticlesState {}

final class ArticlesInitial extends ArticlesState {}

final class ArticlesLoading extends ArticlesState {}

final class ArticlesLoaded extends ArticlesState {
  final List<ArticleDto> articles;

  ArticlesLoaded({
    required this.articles
  });
}

final class ArticlesError extends ArticlesState {
  final String message;

  ArticlesError({
    required this.message
  });

}
