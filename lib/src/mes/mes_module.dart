import 'package:flutter/material.dart';
import 'package:gastos/src/mes/finance_module.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<double> getSalario() async {
  final prefs = await SharedPreferences.getInstance();
  final transactionsJson = prefs.getStringList('transactions');
  double salarioTmp = 0;
  List<FinanceEntry> transactionsTmp = [];
  if (transactionsJson != null) {
    transactionsTmp = transactionsJson
        .map((json) => FinanceEntry.fromJson(jsonDecode(json)))
        .toList();
  }
  for (int i = 0; i < transactionsTmp.length; i++) {
    salarioTmp = salarioTmp + transactionsTmp[i].amount;
  }
  double? salarioSalvo = prefs.getDouble('salario');
  if (salarioSalvo == null) {
    return 0;
  } else {
    return salarioSalvo + salarioTmp;
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

Widget getCategoryTextOrIcon(String category) {
  if (category == 'gasolina') {
    return const Icon(Icons.local_gas_station);
  } else if (category == 'comida') {
    return const Icon(Icons.restaurant);
  } else if (category == 'gasto') {
    return const Icon(Icons.paid);
  } else {
    return Text(
      category,
      style: const TextStyle(
        color: Colors.blue,
        fontSize: 18.0,
      ),
    );
  }
}

Widget buildEmptyState() {
  return const Column(
    children: [
      SizedBox(height: 20.0),
      Text('Nenhuma transação encontrada.'),
    ],
  );
}

Widget buildTransactionList(List<FinanceEntry> transactions) {
  return Stack(
    children: [
      _buildTransactionListView(transactions),
      _buildSaldoContainer(),
    ],
  );
}

Widget _buildTransactionListView(List<FinanceEntry> transactions) {
  return Expanded(
    child: ListView(
      children: transactions.map((transaction) {
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
                    '\$${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color:
                      transaction.amount < 0 ? Colors.red : Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                ],
              ),
              Expanded(child: Container()),
              getCategoryTextOrIcon(transaction.category),
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