// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:gastos/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

int globalIndex = 0;

void _nomeChange(String value) {
  if (value.isEmpty) {
    value = '';
  } else {
    value = value;
  }
  print('nome: $value');
  saveNome(value);
}

Future<void> saveNome(String nome) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('nome', nome);
  String? nomeSalvo = prefs.getString('nome');
  print('nome salvo: $nomeSalvo');
}

Future<String> getNome() async {
  final prefs = await SharedPreferences.getInstance();
  String? nomeSalvo = prefs.getString('nome');
  print('nome salvo recuperado: $nomeSalvo');
  if (nomeSalvo == null) {
    return '';
  }
  return nomeSalvo;
}

Widget getNomeTextField() {
  return FutureBuilder(
    future: getNome(),
    builder: (context, AsyncSnapshot<String> snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data!.isEmpty) {
          return TextField(
            onChanged: (value) => _nomeChange(value),
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nome de Usuário',
            ),
          );
        }
        return TextFormField(
          initialValue: snapshot.data,
          onChanged: (value) => _nomeChange(value),
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        );
      } else {
        return TextField(
          onChanged: (value) => _nomeChange(value),
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nome de Usuário',
          ),
        );
      }
    },
  );
}

Widget getDefaultTagsWidgets() {
  List<Widget> tagWidgets = [];
  tagsPadroes.forEach((key, value) {
    final padding =
    Padding(padding: const EdgeInsets.symmetric(horizontal: 5), child: Icon(value));
    tagWidgets.add(padding);
  });
  return Row(children: tagWidgets);
}