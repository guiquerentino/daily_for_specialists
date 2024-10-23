
import 'dart:convert';

import 'package:daily_for_specialists/core/http/http_client.dart';
import 'package:daily_for_specialists/domain/models/article_dto.dart';
import 'package:dio/dio.dart';

import 'articles_repository.dart';

class ArticlesRepositoryImpl implements ArticlesRepository {
  final HttpClient _httpClient;
  final String lastThreeArticlesPath = 'article';
  ArticlesRepositoryImpl(this._httpClient);

  @override
  Future<List<ArticleDto>> fetchLastThreeArticles() async {
      Response response = await _httpClient.get(lastThreeArticlesPath);

      if(response.statusCode != 200){
        throw Exception("Erro ao verificar últimos artigos");
      }

    return ArticleDto.fromJsonList(response.data);

  }

}