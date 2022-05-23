import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ibge_app_testing/adaptadores/adaptador_noticias_json.dart';
import 'package:ibge_app_testing/adaptadores/adaptador_favoritos_sp.dart';
import 'package:ibge_app_testing/classes/favoritos.dart';
import 'package:ibge_app_testing/classes/noticias.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ListaNoticias extends StatelessWidget {
  const ListaNoticias({Key? key, required this.noticias}) : super(key: key);
  final List<Noticia> noticias;

  salvarFavorito(Noticia item) async {
    SharedPreferences prefsInstance = await SharedPreferences.getInstance();
    Favorito favorito = Favorito.fromJson(item.toJson());
    salvarFavoritos(prefsInstance, favorito);
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
    // ignore: sized_box_for_whitespace
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: noticias.length,
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
                        noticias[index].imglink,
                        fit: BoxFit.cover,
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        noticias[index].titulo,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(noticias[index].introducao),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              launchURL(noticias[index].link);
                            },
                            icon: const Icon(Icons.open_in_browser)),
                        IconButton(
                            onPressed: () {
                              salvarFavorito(noticias[index]);
                            },
                            icon: const Icon(Icons.bookmark)),
                        IconButton(
                            onPressed: () {
                              Share.share(noticias[index].link);
                            },
                            icon: const Icon(Icons.share))
                      ],
                    )
                  ],
                )),
          );
        });
  }
}

class TelaNoticias extends StatefulWidget {
  const TelaNoticias({Key? key}) : super(key: key);

  @override
  State<TelaNoticias> createState() => _TelaNoticiasState();
}

class _TelaNoticiasState extends State<TelaNoticias> {
  late SharedPreferences sp;
  TextEditingController tec = TextEditingController();
  String txtBusca = "";
  String txtTipo = "release";

  buscar() {
    setState(() {
      txtBusca = tec.text;
      tec.text = "";
    });
  }

  obterTipo() async {
    sp = await SharedPreferences.getInstance();
    if (sp.getString("tipo") == null) {
      sp.setString("tipo", "release");
    } else {
      setState(() {
        txtTipo = sp.getString("tipo")!;
      });
    }
  }

  @override
  void dispose() {
    tec.dispose();
    super.dispose();
  }

  @override
  void initState() {
    obterTipo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Noticia>>(
        future: fetchNoticias(http.Client(), txtBusca, txtTipo),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasError) {
            return const Center(child: Text("Error no fetch!"));
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            Size size = MediaQuery.of(context).size;
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 75,
                    width: size.width,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: size.width * 0.7,
                          child: TextField(
                            controller: tec,
                            maxLines: 1,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              buscar();
                            },
                            icon: const Icon(Icons.search))
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                      child: SizedBox(
                          width: size.width,
                          height: size.height - 211,
                          child: ListaNoticias(noticias: snapshot.data!))),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
