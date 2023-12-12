import 'package:flutter/material.dart';
import 'package:gastos/globals.dart';
import 'package:gastos/src/shared/models/Gasto.dart';
import 'package:gastos/src/shared/models/Tag.dart';
import 'package:gastos/src/shared/repositories/GastoHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<double> getSalario() async {
  GastoHelper gastoHelper = GastoHelper();
  final prefs = await SharedPreferences.getInstance();

  List<Gasto> gastos = await gastoHelper.getAllGastos();
  double gastosTotal = 0;
  for (int i = 0; i < gastos.length; i++) {
    gastosTotal += gastos[i].quantidade!;
  }
  double? salarioSalvo = prefs.getDouble('salario');
  if (salarioSalvo == null) {
    prefs.setDouble('salario', 0);
    return 0 + gastosTotal;
  } else {
    return salarioSalvo + gastosTotal;
  }
}

Widget getSaldoTexto() {
  return FutureBuilder(
    future: getSalario(),
    builder: (context, AsyncSnapshot<double> snapshot) {
      if (snapshot.hasData) {
        return Text(
          'Saldo: \$${snapshot.data}',
          style: const TextStyle(color: Colors.white),
        );
      } else {
        return const Text(
          'Saldo: \$0.0',
          style: TextStyle(color: Colors.white),
        );
      }
    },
  );
}

Widget getCategoryTextOrIcon(Tag tag) {
  String category = tag.nome!;
  var icon = null;
  tagsPadroes.forEach((key, value) {
    if (key == category) {
      icon = Icon(value);
    }
  });
  if (icon != null) {
    return icon;
  }
  return Text(
    category,
    style: const TextStyle(
      color: Colors.blue,
      fontSize: 18.0,
    ),
  );
}


Widget buildEmptyState() {
  return const Column(
    children: [
      SizedBox(height: 20.0),
      Text('Nenhuma transação encontrada.'),
    ],
  );
}

Widget buildTransactionList(List<Gasto> transactions) {
  return Stack(
    children: [
      _buildTransactionListView(transactions),
      _buildSaldoContainer(),
    ],
  );
}

Widget _buildTransactionListView(List<Gasto> gastos) {
  return Expanded(
    child: ListView(
      children: gastos.map((transaction) {
        return Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 2),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Row(
            children: [
              Row(
                children: [
                  Text(
                    'R\$${transaction.quantidade?.abs().toStringAsFixed(2)}',
                    style: TextStyle(
                      color:
                      transaction.quantidade! < 0 ? Colors.red : Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                ],
              ),
              Expanded(child: Container()),
              getCategoryTextOrIcon(transaction.tag!),
            ],
          ),
        );
      }).toList(),
    ),
  );
}

Widget _buildSaldoContainer(){
  return Positioned(
    bottom: 16.0,
    left: 16.0,
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xB02196F3),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.blue, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x019E9E9E),
            offset: Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
      ),
      height: 50.0,
      padding: const EdgeInsets.all(16.0),
      child: getSaldoTexto(),
    ),
  );
}