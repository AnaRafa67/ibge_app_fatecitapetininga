import 'package:flutter/material.dart';
import 'package:ibge_app_testing/telas/telafavorito.dart';
import 'telas/telanoticia.dart';
import 'telas/telaconfig.dart';

void main() {
  runApp(const Aplicativo());
}

class Aplicativo extends StatelessWidget {
  const Aplicativo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IBGEAPP',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const ControladorTelas(title: 'IBGE APP - Trabalho de Graduação'),
    );
  }
}

class ControladorTelas extends StatefulWidget {
  const ControladorTelas({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ControladorTelas> createState() => _ControladorTelasState();
}

class _ControladorTelasState extends State<ControladorTelas> {
  int index = 0;

  List<Widget> telas = <Widget>[
    const TelaNoticias(),
    const TelaFavorito(),
    const Configuracoes()
  ];
  void _onItemChanged(value) {
    setState(() {
      index = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: telas.elementAt(index),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: _onItemChanged,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.black38,
        selectedItemColor: Colors.deepOrangeAccent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Tela principal",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), label: "Favoritos"),
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Configurações"),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
