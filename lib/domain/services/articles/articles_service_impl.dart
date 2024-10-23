import 'package:daily_for_specialists/domain/models/article_dto.dart';
import 'package:daily_for_specialists/domain/repositories/articles/articles_repository.dart';
import 'package:daily_for_specialists/domain/services/articles/articles_service.dart';

class ArticlesServiceImpl implements ArticlesService {
  final ArticlesRepository _articlesRepository;

  ArticlesServiceImpl(this._articlesRepository);

  @override
  Future<List<ArticleDto>> fetchLastThreeArticles() async {
    return await _articlesRepository.fetchLastThreeArticles();
  }

}