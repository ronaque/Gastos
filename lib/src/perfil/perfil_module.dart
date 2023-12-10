import 'package:flutter/material.dart';
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

void _salarioChange(String value) {
  if (value.isEmpty) {
    value = '0';
  } else {
    value = value.replaceAll(RegExp(r'[R\$]'), '');
  }
  print('salario: $value');
  saveSalario(value);
}

Future<void> saveSalario(String salario) async {
  final prefs = await SharedPreferences.getInstance();

  if (RegExp(r'^\d+(\.\d+)?$').hasMatch(salario)) {
    prefs.setDouble('salario', double.parse(salario));
    double? salarioSalvo = prefs.getDouble('salario');
    print('salario salvo: $salarioSalvo');
  } else {
    print('Formato de salário inválido');
  }
}

Future<void> saveNome(String nome) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('nome', nome);
  String? nomeSalvo = prefs.getString('nome');
  print('nome salvo: $nomeSalvo');
}

Future<String> getSalario() async {
  final prefs = await SharedPreferences.getInstance();
  double? salarioSalvo = prefs.getDouble('salario');
  print('salario salvo recuperado: $salarioSalvo');
  if (salarioSalvo == null) {
    return '';
  }
  String salarioSalvoString = salarioSalvo.toString();
  return 'R\$$salarioSalvoString';
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

Widget getSalarioTextField() {
  return FutureBuilder(
    future: getSalario(),
    builder: (context, AsyncSnapshot<String> snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data!.isEmpty) {
          return TextField(
            onChanged: (value) => _nomeChange(value),
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Salário',
            ),
          );
        }
        return TextFormField(
          initialValue: snapshot.data,
          onChanged: (value) => _salarioChange(value),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        );
      } else {
        return TextField(
          onChanged: (value) => _nomeChange(value),
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Salário',
          ),
        );
      }
    },
  );
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
  Map<String, Widget> tags = {
    'gasolina' : const Icon(Icons.local_gas_station),
    'comida' : const Icon(Icons.restaurant),
    'gasto' : const Icon(Icons.paid)
  };
  List<Widget> tagWidgets = [];
  for (var tag in tags.values) {
    final padding =
    Padding(padding: const EdgeInsets.symmetric(horizontal: 5), child: tag);
    tagWidgets.add(padding);
  }
  return Row(children: tagWidgets);
}