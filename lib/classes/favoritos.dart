class Favorito {
  final String titulo;
  final String introducao;
  final String link;
  final String imglink;

  const Favorito({
    required this.titulo,
    required this.introducao,
    required this.link,
    required this.imglink,
  });

  factory Favorito.fromJson(Map<String, dynamic> item) {
    return Favorito(
        titulo: item['titulo'] as String,
        introducao: item['introducao'] as String,
        link: item['link'] as String,
        imglink: item['imglink'] as String);
  }

  static Map<String, dynamic> toMap(Favorito favorito) => {
        "titulo": favorito.titulo,
        "introducao": favorito.introducao,
        "link": favorito.link,
        "imglink": favorito.imglink
      };
}
