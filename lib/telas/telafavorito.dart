import 'package:flutter/material.dart';
import 'package:ibge_app_testing/adaptadores/adaptador_favoritos_sp.dart';
import 'package:ibge_app_testing/classes/favoritos.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class TelaFavorito extends StatefulWidget {
  const TelaFavorito({Key? key}) : super(key: key);

  @override
  State<TelaFavorito> createState() => _TelaFavoritoState();
}

class _TelaFavoritoState extends State<TelaFavorito> {
  List<Favorito> lista = [];
  SharedPreferences? sp;

  Future<List<Favorito>> readSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return lerFavoritos(prefs);
  }

  delete(List<Favorito> lista, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      removerFavoritos(lista, prefs, index);
    });
  }

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
    return FutureBuilder<Object>(
        future: readSP(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            lista = snapshot.data as List<Favorito>;
            return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: lista.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    lista[index].imglink,
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    lista[index].titulo,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(lista[index].introducao),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          launchURL(lista[index].link);
                                        },
                                        icon:
                                            const Icon(Icons.open_in_browser)),
                                    IconButton(
                                        onPressed: () {
                                          Share.share(lista[index].link);
                                        },
                                        icon: const Icon(Icons.share)),
                                    IconButton(
                                        onPressed: () {
                                          delete(lista, index);
                                        },
                                        icon: const Icon(Icons.delete))
                                  ],
                                )
                              ],
                            )),
                      );
                    }));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
