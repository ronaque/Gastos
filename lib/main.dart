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
            labelColor:
                Colors.black, // Cor do texto da aba ativa (Mês ou Resumo)
            unselectedLabelColor: Colors.grey, // Cor do texto das abas inativas
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Conteúdo da aba "Mês"
                ListView(
                  children: [
                    // Exemplo de registro de movimentação financeira
                    FinanceEntry(amount: -50.0, textOrIcon: 'Popcorn'),
                    FinanceEntry(amount: 100.0, textOrIcon: 'Money'),
                    FinanceEntry(amount: -50.0, textOrIcon: 'Car'),
                    FinanceEntry(amount: 100.0, textOrIcon: 'Food'),
                    FinanceEntry(amount: 100.0, textOrIcon: 'Academia'),
                  ],
                ),

                // Conteúdo da aba "Resumo"
                Center(
                  child: Text('Resumo'),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  border: Border.all(color: Colors.blue, width: 1.0),
                ),
                height: 80.0,
                //width: 200.0,
                margin: EdgeInsets.only(left: 16.0, bottom: 16),
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Saldo: \$1000.00',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Spacer(), // Este widget faz com que o botão seja alinhado à direita.

              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () {
                    // Adicione uma nova transação aqui.
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FinanceEntry extends StatelessWidget {
  final double amount;
  final String textOrIcon;

  FinanceEntry({required this.amount, required this.textOrIcon});

  Widget _buildIconOrText(String textOrIcon) {
    switch (textOrIcon) {
      case 'Popcorn':
        return Icon(Icons.local_dining, color: Colors.blue, size: 30.0);
      case 'Money':
        return Icon(Icons.attach_money, color: Colors.blue, size: 30.0);
      case 'Car':
        return Icon(Icons.directions_car, color: Colors.blue, size: 30.0);
      case 'Food':
        return Icon(Icons.restaurant, color: Colors.blue, size: 30.0);
      default:
        return Text(
          textOrIcon,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 18.0,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color amountColor = amount < 0 ? Colors.red : Colors.green;

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
          Row(
            children: [
              Text(
                '\$${amount.toStringAsFixed(2)}',
                style: TextStyle(color: amountColor),
              ),
              SizedBox(width: 8.0),
              _buildIconOrText(textOrIcon),
            ],
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}
