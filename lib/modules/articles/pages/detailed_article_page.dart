import 'dart:convert';

import 'package:daily_for_specialists/core/constants/route_constants.dart';
import 'package:daily_for_specialists/domain/models/article_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import '../../../core/ui/daily_bottom_navigation_bar.dart';
import '../../../core/ui/daily_drawer.dart';
import '../../../core/ui/daily_text.dart';


class DetailedArticlePage extends StatefulWidget {
  final ArticleDto article;
  final bool isFromList;
  const DetailedArticlePage({super.key, required this.article, required this.isFromList});

  @override
  State<DetailedArticlePage> createState() => _DetailedArticlePageState();
}

class _DetailedArticlePageState extends State<DetailedArticlePage> {

  String _decodeUtf8(String text) {
    return utf8.decode(text.codeUnits);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DailyDrawer(),
      bottomNavigationBar: const DailyBottomNavigationBar(),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 16.0, top: 16.0, right: 16.0, bottom: 0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) {
                    return IconButton(
                      onPressed: () {
                        if(widget.isFromList){
                          Modular.to.navigate(RouteConstants.articlesPage);
                        }else{
                          Modular.to.navigate(RouteConstants.homePage);
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_back_outlined,
                        size: 30,
                      ),
                    );
                  },
                ),
                DailyText.text("VOLTAR").body
              ],
            ),
            Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * .80,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 4.0),
                    blurRadius: 3.0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(widget.isFromList)
                      DailyText.text(_decodeUtf8(widget.article.title)).header.small.bold,
                      if(!widget.isFromList)
                        DailyText.text(widget.article.title).header.small.bold,
                      DailyText.text(
                        DateFormat('dd/MM/yy')
                            .format(widget.article.createdAt),
                      ).body.small,
                      const Divider(),
                      const SizedBox(height: 5),
                      if(widget.isFromList)
                        Text(_decodeUtf8(widget.article.text))
                      else
                        Text(widget.article.text)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
