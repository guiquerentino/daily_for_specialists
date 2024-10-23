import '../../models/article_dto.dart';

abstract interface class ArticlesService {

  Future<List<ArticleDto>> fetchLastThreeArticles();

}