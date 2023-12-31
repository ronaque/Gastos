import 'package:flutter/material.dart';
import 'package:gastos/globals.dart';
import 'package:gastos/src/shared/data_utils.dart';
import 'package:gastos/src/shared/models/Gasto.dart';
import 'package:gastos/src/shared/models/Tag.dart';
import 'package:gastos/src/shared/repositories/GastoHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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
    style: TextStyle(
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget getGastosPositivos() {
  GastoHelper gastoHelper = GastoHelper();
  return FutureBuilder(
    future: gastoHelper.getGastosDoMesComQuantidadePositiva(DateFormat('y').format(DateTime.now()), DateFormat('MM').format(DateTime.now())),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data!.isEmpty) {
          return const Text(
            '\$0.0',
            style: TextStyle(color: Colors.white),
          );
        }
        double gastosTotal = 0;
        for (int i = 0; i < snapshot.data!.length; i++) {
          gastosTotal += snapshot.data![i].quantidade!;
        }
        String strGastosTotal = gastosTotal.toStringAsFixed(2);
        return Text(
          '\$$strGastosTotal',
          style: const TextStyle(color: Colors.green),
        );
      } else {
        return const Text(
          '\$0.0',
          style: TextStyle(color: Colors.white),
        );
      }
    },
  );
}

Widget getGastosNegativos() {
  GastoHelper gastoHelper = GastoHelper();
  return FutureBuilder(
    future: gastoHelper.getGastosDoMesComQuantidadeNegativa(DateFormat('y').format(DateTime.now()), DateFormat('MM').format(DateTime.now())),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data!.isEmpty) {
          return const Text(
            '\$0.0',
            style: TextStyle(color: Colors.white),
          );
        }
        double gastosTotal = 0;
        for (int i = 0; i < snapshot.data!.length; i++) {
          gastosTotal += snapshot.data![i].quantidade!;
        }
        String strGastosTotal = (gastosTotal * -1).toStringAsFixed(2);
        return Text(
          '\$$strGastosTotal',
          style: const TextStyle(color: Colors.red),
        );
      } else {
        return const Text(
          '\$0.0',
          style: TextStyle(color: Colors.white),
        );
      }
    },
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
          padding: const EdgeInsets.all(18.0),
          decoration: const BoxDecoration(
            border: BorderDirectional(bottom: BorderSide(color: Color(0xfffefefe), width: 2)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${transaction.data!.day}',
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          '${retornarMesAbreviado(transaction.data!.month)}',
                          style: const TextStyle(
                            fontSize: 10.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12.0),
                    getCategoryTextOrIcon(transaction.tag!),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    '${transaction.descricao}',
                    style: const TextStyle(
                      fontSize: 14.0,
                    )
                  ),
                )
              ),
              const SizedBox(width: 12.0),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    'R\$${transaction.quantidade?.abs().toStringAsFixed(2)}',
                    style: TextStyle(
                      color: transaction.quantidade! < 0 ? Colors.red : Colors.green,
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ),
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
      // height: 50.0,
      padding: const EdgeInsets.all(16.0),
      child: getSaldoTexto(),
      ) //getSaldoTexto(),
    );
}