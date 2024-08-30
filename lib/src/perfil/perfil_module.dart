// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:gastos/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

void _updateName(String value) {
  if (value.isEmpty) {
    value = '';
  } else {
    value = value;
  }
  print('nome: $value');
  _storeName(value);
}

Future<void> _storeName(String nome) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('nome', nome);
  String? nomeSalvo = prefs.getString('nome');
  print('nome salvo: $nomeSalvo');
}

Future<String> _fetchName() async {
  final prefs = await SharedPreferences.getInstance();
  String? savedName = prefs.getString('nome');
  print('nome salvo recuperado: $savedName');
  if (savedName == null) {
    return '';
  }
  return savedName;
}

Widget buildNameTextField() {
  return FutureBuilder(
    future: _fetchName(),
    builder: (context, AsyncSnapshot<String> snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data!.isEmpty) {
          return TextField(
            onChanged: (value) => _updateName(value),
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nome de Usuário',
            ),
          );
        }
        return TextFormField(
          initialValue: snapshot.data,
          onChanged: (value) => _updateName(value),
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        );
      } else {
        return TextField(
          onChanged: (value) => _updateName(value),
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

/// Get the default tags Icons as Padding Widgets
Widget getDefaultTagsWidgets() {
  List<Widget> tagWidgets = [];
  defaultTags.forEach((key, value) {
    final padding = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5), child: Icon(value));
    tagWidgets.add(padding);
  });
  return Row(children: tagWidgets);
}
