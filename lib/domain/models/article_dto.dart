import 'package:intl/intl.dart';

class ArticleDto {
  int? id;
  String title;
  String text;
  String autor;
  String bannerURL;
  String minutesToRead;
  String category;
  DateTime createdAt;

  ArticleDto(
      {this.id,
      required this.title,
      required this.text,
      required this.autor,
      required this.bannerURL,
      required this.minutesToRead,
      required this.category,
      required this.createdAt});

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'text': text,
        'autor': autor,
        'bannerURL': bannerURL,
        'minutesToRead': minutesToRead,
        'category': category,
        'createdAt': DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(createdAt)
      };

  static ArticleDto fromJson(Map<String, dynamic> json) => ArticleDto(
      title: json['title'],
      text: json['text'],
      autor: json['autor'],
      bannerURL: json['bannerURL'],
      minutesToRead: json['minutesToRead'],
      category: json['category'],
      createdAt: DateTime.parse(json['createdAt'].toString()));


  static List<ArticleDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ArticleDto.fromJson(json)).toList();
  }

}
