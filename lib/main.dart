import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastos/perfil.dart';
import 'package:gastos/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ;
  //runApp(MaterialApp(home: Home(), theme: AppTheme().getAppTheme()));
  runApp(MaterialApp(home: MyApp(), theme: AppTheme().getAppTheme()));
  //runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login', // Defina a tela de login como rota inicial
      routes: {
        '/login': (context) => LoginPage(),
        '/main': (context) => Home(),
      },
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  List<FinanceEntry> transactions = [];
  List<_ChartData> data = [
    _ChartData('Jan', 12, 15),
    _ChartData('Fev', 15, 30),
    _ChartData('Mar', 30, 6.4),
    _ChartData('Abr', 6.4, 14),
    _ChartData('Mai', 14, 16),
    _ChartData('Jun', 16, 45),
    _ChartData('Jul', 45, 23),
    _ChartData('Ago', 23, 25),
    _ChartData('Set', 25, 10),
    _ChartData('Out', 10, 5),
    _ChartData('Nov', 5, 19),
    _ChartData('Dez', 19, 12),
  ];
  TooltipBehavior _tooltip = TooltipBehavior(enable: true);
  late TabController _tabController;

  void _abrirPerfil() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Perfil()));
  }

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

  void _exibirModalAdicionarTransacao(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AdicionarTransacaoModal(
          onTransacaoSalva: (double amount, String textOrIcon) {
            FinanceEntry novaTransacao = FinanceEntry(
              amount: amount,
              textOrIcon: textOrIcon,
            );
            print('Nova Transação - Valor: $amount, Tag: $textOrIcon');
            setState(() {
              transactions.add(novaTransacao);
            });
            print("TESTE");
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MobiFin'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: _abrirPerfil,
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
                _resumoDisplay(context),
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
                    _exibirModalAdicionarTransacao(context);
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

  _resumoDisplay(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // !! Tabela mensal !!
          Container(
            margin: EdgeInsets.fromLTRB(0, 50, 0, 20),
            decoration:
                BoxDecoration(border: Border.all(color: Color(0xff0D47A1))),
            width: MediaQuery.of(context).size.width * 0.8,
            child: const Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.navigate_before),
                      Text("Julho"),
                      Icon(Icons.navigate_next),
                    ],
                  ),
                ),
                Divider(color: Color(0xff0D47A1)),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: Row(
                    children: <Widget>[Text("Gasto: R\$1000,00")],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: Row(
                    children: <Widget>[Text("Economizado: R\$ 0,00")],
                  ),
                ),
              ],
            ),
          ),
          // !! Gráfico mensal !!
          Container(
            height: MediaQuery.of(context).size.width *
                0.8, // Defina a altura desejada para o PieChart
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: Colors.red,
                    value: 40,
                    title: "Comida",
                    radius: 50,
                  ),
                  PieChartSectionData(
                    color: Colors.blue,
                    value: 60,
                    title: "Bebida",
                    radius: 50,
                  ),
                ],
                centerSpaceRadius: MediaQuery.of(context).size.width * 0.2,
              ),
              swapAnimationCurve: Curves.linear,
              swapAnimationDuration: Duration(milliseconds: 150),
            ),
          ),
          // !! Tabela anual !!
          Container(
            margin: EdgeInsets.fromLTRB(0, 50, 0, 20),
            decoration:
                BoxDecoration(border: Border.all(color: Color(0xff0D47A1))),
            width: MediaQuery.of(context).size.width * 0.8,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(Icons.navigate_before),
                  Text("2023"),
                  Icon(Icons.navigate_next),
                ],
              ),
            ),
          ),
          // !! Gráfico anual !!
          Container(
            height: MediaQuery.of(context).size.width * 0.8,
            width: MediaQuery.of(context).size.width * 0.9,
            child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis:
                    NumericAxis(minimum: 0, maximum: 40, interval: 10),
                tooltipBehavior: _tooltip,
                series: <ChartSeries<_ChartData, String>>[
                  BarSeries<_ChartData, String>(
                      dataSource: data,
                      xValueMapper: (_ChartData data, _) => data.x,
                      yValueMapper: (_ChartData data, _) => data.y,
                      name: 'Gold',
                      color: Colors.greenAccent),
                  BarSeries<_ChartData, String>(
                      dataSource: data,
                      xValueMapper: (_ChartData data, _) => data.x,
                      yValueMapper: (_ChartData data, _) => data.y2,
                      name: 'Gold',
                      color: Colors.redAccent)
                ]),
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

class _ChartData {
  _ChartData(this.x, this.y, this.y2);

  final String x;
  final double y;
  final double y2;
}

class AdicionarTransacaoModal extends StatefulWidget {
  final Function(double amount, String textOrIcon) onTransacaoSalva;

  AdicionarTransacaoModal({required this.onTransacaoSalva});

  @override
  _AdicionarTransacaoModalState createState() =>
      _AdicionarTransacaoModalState();
}

class _AdicionarTransacaoModalState extends State<AdicionarTransacaoModal> {
  late TextEditingController amountController;
  late TextEditingController textOrIconController;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
    textOrIconController = TextEditingController();
  }

  @override
  void dispose() {
    amountController.dispose();
    textOrIconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Adicionar Transação'),
          SizedBox(height: 16.0),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Valor'),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: textOrIconController,
            decoration: InputDecoration(labelText: 'Tag'),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              double amount = double.tryParse(amountController.text) ?? 0.0;
              String textOrIcon = textOrIconController.text ?? 'Popcorn';

              widget.onTransacaoSalva(amount, textOrIcon);
              Navigator.pop(context);
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.attach_money,
                size: 64.0,
                color: AppTheme().blueColors[500],
              ),
              SizedBox(height: 20.0),
              Text(
                'MobiFin',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 10.0),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                ),
              ),
              SizedBox(height: 50.0),
              ElevatedButton(
                onPressed: () {
                  // Quando o botão "Entrar" é pressionado, navegue para a tela principal
                  Navigator.pushReplacementNamed(context, '/main');
                },
                child: Container(
                  width: double.infinity, // Largura máxima possível
                  child: Center(
                    child: Text('Entrar'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
