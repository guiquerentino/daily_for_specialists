import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../domain/models/article_dto.dart';
import '../../../core/ui/daily_text.dart';
import '../bloc/articles_bloc.dart';
import '../bloc/articles_state.dart';

class ArticlesCarousel extends StatefulWidget {
  const ArticlesCarousel({super.key});

  @override
  State<ArticlesCarousel> createState() => _ArticlesCarouselState();
}

class _ArticlesCarouselState extends State<ArticlesCarousel> {
  late final ArticlesBloc _articlesBloc;
  int selectedIndex = 0;
  late Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _articlesBloc = Modular.get<ArticlesBloc>();
    _articlesBloc.load();
    _autoAdvanceArticle();
  }

  void _autoAdvanceArticle() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        if (_articlesBloc.state is ArticlesLoaded) {
          final articles = (_articlesBloc.state as ArticlesLoaded).articles;
          if (articles.isNotEmpty) {
            selectedIndex = (selectedIndex + 1) % articles.length;
          }
        }
      });
    });
  }

  void _handleArticleSwipe(double velocity) {
    setState(() {
      if (_articlesBloc.state is ArticlesLoaded) {
        final articles = (_articlesBloc.state as ArticlesLoaded).articles;
        if (articles.isNotEmpty) {
          if (velocity >= 0) {
            selectedIndex =
                (selectedIndex - 1 + articles.length) % articles.length;
          } else {
            selectedIndex = (selectedIndex + 1) % articles.length;
          }
        }
      }
    });
  }

  GestureDetector _buildArticleContainer(int index, List<ArticleDto> articles) {
    if (articles.isEmpty) return GestureDetector();

    return GestureDetector(
      onTap: () {
        Modular.to.navigate('/articles/details?isFromList=false', arguments: articles[index]);
      },
      onHorizontalDragEnd: (details) {
        _handleArticleSwipe(details.primaryVelocity!);
      },
      child: Container(
        height: 140,
        width: 358,
        decoration: BoxDecoration(
          color: index == 0
              ? const Color.fromRGBO(131, 180, 255, 1)
              : index == 1
              ? const Color.fromRGBO(210, 151, 0, 1)
              : const Color.fromRGBO(158, 181, 103, 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              alignment: Alignment.center,
              height: 150,
              width: 177,
              child: DailyText.text(articles[index].title)
                  .header
                  .small
                  .bold
                  .neutral,
            ),
            Image.asset(
              index == 0
                  ? "assets/article_illustration.png"
                  : index == 1
                  ? "assets/article_illustration2.png"
                  : "assets/article_illustration3.png",
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticlesBloc, ArticlesState>(
      bloc: _articlesBloc,
      builder: (context, state) {
        if (state is ArticlesLoading) {
          return const CircularProgressIndicator();
        } else if (state is ArticlesLoaded) {
          final articles = state.articles;

          if (articles.isEmpty) {
            return Container();
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildArticleContainer(selectedIndex, articles),
                const Gap(9),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < articles.length; i++) ...[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (selectedIndex == i)
                              ? Colors.black87
                              : const Color.fromRGBO(196, 196, 196, 1),
                        ),
                        width: 8,
                        height: 8,
                      ),
                      const Gap(5),
                    ]
                  ],
                ),
              ],
            ),
          );
        } else if (state is ArticlesError) {
          return Text(state.message);
        }

        return const SizedBox.shrink();
      },
    );
  }
}
