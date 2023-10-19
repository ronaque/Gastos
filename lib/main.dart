import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FinanceApp(),
    );
  }
}

class FinanceApp extends StatefulWidget {
  @override
  _FinanceAppState createState() => _FinanceAppState();
}

class _FinanceAppState extends State<FinanceApp>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MobiFin'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Navegue para a tela de perfil aqui.
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Mês'),
              Tab(text: 'Resumo'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Conteúdo da aba "Mês"
                ListView(
                  children: [
                    // Exemplo de registro de movimentação financeira
                    FinanceEntry(isExpense: true, amount: -50.0),
                    FinanceEntry(isExpense: false, amount: 100.0),
                  ],
                ),

                // Conteúdo da aba "Resumo"
                Center(
                  child: Text('Resumo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FinanceEntry extends StatelessWidget {
  final bool isExpense;
  final double amount;

  FinanceEntry({required this.isExpense, required this.amount});

  @override
  Widget build(BuildContext context) {
    Color amountColor = isExpense ? Colors.red : Colors.green;
    String transactionType = isExpense ? 'Gasto' : 'Ganho';

    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(transactionType),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(color: amountColor),
          ),
        ],
      ),
    );
  }
}
