import 'package:flutter/material.dart';
import 'package:gastos/src/shared/models/Gasto.dart';
import 'package:gastos/src/shared/repositories/GastoHelper.dart';
import 'components/adicionar_transacao.dart';
import 'mes_module.dart';

Widget returnMesDisplay(context) {
  return const Mes();
}

class Mes extends StatefulWidget {
  const Mes({super.key});

  @override
  _MesState createState() => _MesState();
}

class _MesState extends State<Mes> {
  GastoHelper gastoHelper = GastoHelper();
  Widget transactionsList = buildTransactionList([]);

  void adicionarTransacao() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const AdicionarTransacaoModal();
      },
    );
    var listGastos = await gastoHelper.getGastosDoMes(DateTime.now().year, DateTime.now().month);
    setState(() {
      transactionsList = buildTransactionList(listGastos!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          adicionarTransacao();
        },
        backgroundColor: const Color(0xB02196F3),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<List<Gasto>?>(
      future: gastoHelper.getGastosDoMes(DateTime.now().year, DateTime.now().month), // financeManager.loadTransactions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return buildEmptyState();
        } else {
          transactionsList = buildTransactionList(snapshot.data!);
          return transactionsList;
        }
      },
    );
  }
}