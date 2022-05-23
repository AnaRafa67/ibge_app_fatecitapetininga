import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ibge_app_testing/classes/favoritos.dart';

String nomeFavoritos = "favoritos";
List<Favorito>? listaFavoritos;

String encodeList(List<Favorito> lista) => json.encode(
    lista.map<Map<String, dynamic>>((fav) => Favorito.toMap(fav)).toList());

List<Favorito> decodeList(String lista) =>
    ((json.decode(lista) as List<dynamic>)
        .map<Favorito>((item) => Favorito.fromJson(item))
        .toList());

bool existemFavoritos(SharedPreferences prefs) {
  var lista = prefs.getString(nomeFavoritos);
  if (lista != null) {
    return true;
  } else {
    return false;
  }
}

List<Favorito> lerFavoritos(SharedPreferences prefs) {
  List<Favorito> lista = [];
  String? prefsString = prefs.getString(nomeFavoritos);

  if (prefsString != null) {
    lista = decodeList(prefsString);
    return lista;
  }

  return lista;
}

///salvar favoritos no shared preferences
void salvarFavoritos(SharedPreferences prefs, Favorito item) {
  //print("\x1B[31mLer favoritos: \x1B[0m${lerFavoritos(prefs)}");
  if (existemFavoritos(prefs)) {
    List<Favorito> listaFavorito =
        lerFavoritos(prefs); //obtem a lista de favoritos atual
    listaFavorito.add(item); //add a nova string (link)
    prefs.setString(nomeFavoritos,
        encodeList(listaFavorito)); //salva a nova lista no shared preferences
  } else {
    listaFavoritos = [];
    listaFavoritos?.add(item);
    String jsonLista = encodeList(listaFavoritos!);
    prefs.setString(nomeFavoritos, jsonLista);
  }
}

///deletar favoritos na posição fornecida
void removerFavoritos(List<Favorito> lista, SharedPreferences prefs, int i) {
  if (existemFavoritos(prefs)) {
    lista.removeAt(i);
    String json = encodeList(lista);
    prefs.setString(nomeFavoritos, json);
  } else {
    prefs.clear();
  }
}
