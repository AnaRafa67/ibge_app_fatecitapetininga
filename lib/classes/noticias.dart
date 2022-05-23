import 'dart:convert';

class Noticia {
  final String titulo;
  final String introducao;
  final String link;
  final String imglink;

  const Noticia({
    required this.titulo,
    required this.introducao,
    required this.link,
    required this.imglink,
  });

  factory Noticia.fromJson(Map<String, dynamic> item) {
    String imageString = item['imagens']; //.replaceAll("\\", "");
    var imageMap = jsonDecode(imageString);
    String imgIntro =
        "http://agenciadenoticias.ibge.gov.br/${imageMap['image_intro']}";
    return Noticia(
      titulo: item['titulo'] as String,
      introducao: item['introducao'] as String,
      link: item['link'] as String,
      imglink: imgIntro,
    );
  }
  Map<String, dynamic> toJson() => {
        "titulo": titulo,
        "introducao": introducao,
        "link": link,
        "imglink": imglink
      };
}
