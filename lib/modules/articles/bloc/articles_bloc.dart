import 'package:daily_for_specialists/domain/services/articles/articles_service.dart';
import 'package:daily_for_specialists/modules/articles/bloc/articles_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/article_dto.dart';

final class ArticlesBloc extends Cubit<ArticlesState> {
  final ArticlesService _articlesService;

  ArticlesBloc({required ArticlesService articlesService})
      : _articlesService = articlesService,
        super(ArticlesInitial());

  Future<void> load() async {
    emit(ArticlesInitial());
    try {
      emit(ArticlesLoading());

      List<ArticleDto> response = await _articlesService.fetchLastThreeArticles();
      response.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      emit(ArticlesLoaded(articles: response));

    } on Exception catch (s) {
      emit(ArticlesError(message: "Erro ao recuperar notícias"));
    }
  }

}
