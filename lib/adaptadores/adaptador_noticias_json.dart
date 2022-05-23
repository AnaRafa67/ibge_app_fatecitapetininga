import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ibge_app_testing/classes/noticias.dart';

//default values
String qtd = "10";
String busca = "";
String tipo = "noticias";
late Uri ibgeApi;

List<Noticia> parseNoticias(String noticias) {
  //converte a string recebida para um Map
  final parsed = jsonDecode(noticias)['items'].cast<Map<String, dynamic>>();
  //converte o map em uma lista de noticias
  return parsed.map<Noticia>((json) => Noticia.fromJson(json)).toList();
}

Future<List<Noticia>> fetchNoticias(
    http.Client client, String buscaRecebida, String tipoRecebido) async {
  busca = buscaRecebida;
  tipo = tipoRecebido;
  ibgeApi = Uri(
      scheme: 'https',
      host: 'servicodados.ibge.gov.br',
      path: '/api/v3/noticias/',
      queryParameters: {
        "qtd": qtd,
        "tipo": tipo,
        "busca": Uri.encodeComponent(busca)
      });
  final response = await client.get(ibgeApi);
  return compute(parseNoticias, response.body);
}
