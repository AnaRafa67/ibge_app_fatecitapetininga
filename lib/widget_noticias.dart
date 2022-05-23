import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CardNoticias extends StatelessWidget {
  const CardNoticias({
    Key? key,
    required this.imagelink,
    required this.titulo,
    required this.resumo,
    required this.noticialink,
  }) : super(key: key);

  final String imagelink; //link da imagem fornecida pela noticia
  final String titulo; //titulo da noticia
  final String resumo; //descrição da noticia
  final String noticialink; //link da noticia

  launchURL(String url) async {
    Uri link = Uri.parse(url);

    if (await canLaunchUrl(link)) {
      await launchUrl(link, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  imagelink,
                  fit: BoxFit.cover,
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  titulo,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(resumo),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        launchURL(noticialink);
                      },
                      icon: const Icon(Icons.open_in_browser)),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.bookmark)),
                  IconButton(
                      onPressed: () {
                        Share.share(noticialink.toString());
                      },
                      icon: const Icon(Icons.share))
                ],
              )
            ],
          )),
    );
  }
}
