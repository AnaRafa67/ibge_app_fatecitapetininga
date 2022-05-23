import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Configuracoes extends StatefulWidget {
  const Configuracoes({Key? key}) : super(key: key);

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  late SharedPreferences sp;
  bool exibirRelease = false;

  obterTipo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.getString("tipo") != null) {
      setState(() {
        var s = sp.getString("tipo");
        if (s == "release") {
          exibirRelease = true;
        }
        if (s == "noticias") {
          exibirRelease = false;
        }
      });
    }
  }

  atualizarTipo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (exibirRelease) {
      sp.setString("tipo", "release");
    } else {
      sp.setString("tipo", "noticias");
    }
  }

  @override
  void initState() {
    obterTipo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            SwitchListTile(
                title: const Text("Exibir Releases"),
                subtitle: const Text(
                    "O aplicativo irá exibir as notícias e releases fornecidos pela API do IBGE Notícias"),
                value: exibirRelease,
                onChanged: (bool value) {
                  setState(() {
                    exibirRelease = value;
                    atualizarTipo();
                  });
                }),
            const Divider(height: 50, thickness: 5),
            const Feedback()
          ],
        ));
  }
}

class Feedback extends StatelessWidget {
  const Feedback({
    Key? key,
  }) : super(key: key);
  static TextEditingController tec = TextEditingController();

  launchEmail() {
    Uri email = Uri(
      scheme: 'mailto',
      path: 'ibgeappteam@fatecitapetininga.com',
      query: 'subject=Feedback&body=${tec.text}',
    );
    launchUrl(email);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(bottom: 16.0),
              child: const Text("Contate-nos via e-mail",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: tec,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: "Insira seu feedback aqui...",
                  border: const OutlineInputBorder(),
                  fillColor: Colors.orange[50],
                  filled: true,
                ),
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(bottom: 16.0),
                child: const Text("Agradecemos pelo contato !")),
            Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextButton(
                    onPressed: () {
                      launchEmail();
                    },
                    child: const Text("Enviar")))
          ],
        ));
  }
}
