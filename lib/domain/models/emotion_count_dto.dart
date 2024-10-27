class EmotionCountDto {
  String ocorrencia;
  int bravo;
  int triste;
  int normal;
  int feliz;
  int muitoFeliz;

  EmotionCountDto(
      {required this.ocorrencia,
      required this.bravo,
      required this.triste,
      required this.normal,
      required this.feliz,
      required this.muitoFeliz});

  Map<String, dynamic> toJson() => {
        'ocorrencia': ocorrencia,
        'bravo': bravo,
        'triste': triste,
        'normal': normal,
        'feliz': feliz,
        'muitoFeliz': muitoFeliz
      };

  static EmotionCountDto fromJson(Map<String, dynamic> json) => EmotionCountDto(
      ocorrencia: json['ocorrencia'],
      bravo: json['bravo'],
      triste: json['triste'],
      normal: json['normal'],
      feliz: json['feliz'],
      muitoFeliz: json['muitoFeliz']);

  static List<EmotionCountDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => EmotionCountDto.fromJson(json)).toList();
  }

}
