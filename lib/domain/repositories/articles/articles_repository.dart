import 'package:daily_for_specialists/domain/models/article_dto.dart';

abstract interface class ArticlesRepository {

  Future<List<ArticleDto>> fetchLastThreeArticles();

}