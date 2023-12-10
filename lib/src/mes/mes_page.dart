import 'package:flutter/material.dart';
import 'package:gastos/src/mes/finance_module.dart';
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
  final FinanceManager financeManager = FinanceManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _exibirModalAdicionarTransacao(context);
        },
        backgroundColor: const Color(0xB02196F3),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<List<FinanceEntry>>(
      future: financeManager.loadTransactions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return buildEmptyState();
        } else {
          return buildTransactionList(snapshot.data!);
        }
      },
    );
  }

  void _exibirModalAdicionarTransacao(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AdicionarTransacaoModal(
          onTransacaoSalva: (double amount, String category) async {
            FinanceEntry novaTransacao =
                FinanceEntry(amount: amount, category: category);
            await financeManager.addTransaction(novaTransacao);
            Navigator.pop(context);

            setState(() {});
          },
        );
      },
    );
  }
}