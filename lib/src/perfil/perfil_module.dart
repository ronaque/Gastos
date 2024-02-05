import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:gastos/globals.dart';
import 'package:gastos/src/shared/saldo_utils.dart';
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
    value = value.replaceAll(RegExp(r'[,]'), '.');
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

Future<double> getSalarioDouble() async {
  final prefs = await SharedPreferences.getInstance();
  double? salarioSalvo = prefs.getDouble('salario');
  if (salarioSalvo == null) {
    return 0;
  }

  return salarioSalvo;
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
            controller: MoneyMaskedTextController(
                leftSymbol: 'R\$',
                initialValue: 0.0
            ),
            onChanged: (value) => _salarioChange(value),
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Salário',
            ),
          );
        }
        return TextFormField(
          // initialValue: snapshot.data,
          controller: MoneyMaskedTextController(
              leftSymbol: 'R\$',
              initialValue: double.parse(snapshot.data!.replaceAll(RegExp(r'[R\$]'), ''))
          ),
          onChanged: (value) => _salarioChange(value),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        );
      } else {
        return TextField(
          controller: MoneyMaskedTextController(
              leftSymbol: 'R\$',
              initialValue: 0.0
          ),
          onChanged: (value) => _salarioChange(value),
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
  List<Widget> tagWidgets = [];
  tagsPadroes.forEach((key, value) {
    final padding =
    Padding(padding: const EdgeInsets.symmetric(horizontal: 5), child: Icon(value));
    tagWidgets.add(padding);
  });
  return Row(children: tagWidgets);
}