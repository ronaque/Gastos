import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gastos/Model/Tag.dart';
import 'package:gastos/ModelHelper/DatabaseHelper.dart';

Widget returnMesDisplay(context) {
  return MesScreen();
}

class FinanceEntry {
  final double amount;
  final String category;

  FinanceEntry({required this.amount, required this.category});

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'category': category,
    };
  }

  factory FinanceEntry.fromJson(Map<String, dynamic> json) {
    return FinanceEntry(
      amount: json['amount'],
      category: json['category'],
    );
  }
}

class FinanceManager {
  static const String keyTransactions = 'transactions';

  Future<void> addTransaction(FinanceEntry transaction) async {
    final transactions = await loadTransactions();
    transactions.add(transaction);
    await saveTransactions(transactions);
  }

  Future<List<FinanceEntry>> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getStringList(keyTransactions);

    if (transactionsJson != null) {
      return transactionsJson
          .map((json) => FinanceEntry.fromJson(jsonDecode(json)))
          .toList();
    }

    return [];
  }

  Future<void> saveTransactions(List<FinanceEntry> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = transactions
        .map((transaction) => jsonEncode(transaction.toJson()))
        .toList();
    prefs.setStringList(keyTransactions, transactionsJson);
  }
}

class MesScreen extends StatefulWidget {
  @override
  _MesScreenState createState() => _MesScreenState();
}

class _MesScreenState extends State<MesScreen> {
  final FinanceManager financeManager = FinanceManager();

  Future<double> getSalario() async {
    final prefs = await SharedPreferences.getInstance();
    double? salarioSalvo = prefs.getDouble('salario');
    if (salarioSalvo == null) {
      return 0;
    }
    return salarioSalvo;
  }

  Widget getSaldoTexto() {
    return FutureBuilder(
      future: getSalario(),
      builder: (context, AsyncSnapshot<double> snapshot) {
        if (snapshot.hasData) {
          return Text(
            'Saldo: \$${snapshot.data}',
            style: TextStyle(color: Colors.white),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<List<FinanceEntry>>(
      future: financeManager.loadTransactions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Column(
            children: [
              SizedBox(height: 20.0),
              const Text('Nenhuma transação encontrada.'),
              _buildTransactionList(snapshot.data!),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      border: Border.all(color: Colors.blue, width: 1.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    height: 50.0,
                    //width: 200.0,
                    margin: EdgeInsets.only(left: 16.0, bottom: 16),
                    padding: EdgeInsets.all(16.0),
                    child: getSaldoTexto(),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FloatingActionButton(
                        onPressed: () {
                          _exibirModalAdicionarTransacao(context);
                        },
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        } else {
          return Column(
            children: [
              SizedBox(height: 20.0),
              _buildTransactionList(snapshot.data!),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          border: Border.all(color: Colors.blue, width: 1.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(
                                0,
                                2,
                              ),
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        height: 50.0,
                        margin: EdgeInsets.only(left: 16.0, bottom: 16),
                        padding: EdgeInsets.all(16.0),
                        child: getSaldoTexto(),
                      ),
                      Spacer(),
                      FloatingActionButton(
                        onPressed: () {
                          _exibirModalAdicionarTransacao(context);
                        },
                        child: Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
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

  Widget _buildTransactionList(List<FinanceEntry> transactions) {
    return Column(
      children: transactions.map((transaction) {
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
            children: [
              Row(
                children: [
                  Text(
                    '\$${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: transaction.amount < 0 ? Colors.red : Colors.green,
                    ),
                  ),
                  SizedBox(width: 8.0),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              Text(
                transaction.category,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class AdicionarTransacaoModal extends StatefulWidget {
  final Function(double amount, String category) onTransacaoSalva;

  AdicionarTransacaoModal({required this.onTransacaoSalva});

  @override
  _AdicionarTransacaoModalState createState() =>
      _AdicionarTransacaoModalState();
}

class _AdicionarTransacaoModalState extends State<AdicionarTransacaoModal> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Tag> dbTags = [];
  late TextEditingController amountController;
  late TextEditingController categoryController;
  List<String> categories = [
    'Categoria 1',
    'Categoria 2',
    'Categoria 3'
  ]; // Adicione suas categorias aqui
  String selectedCategory = 'Academia';

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
    categoryController = TextEditingController();
  }

  @override
  void dispose() {
    amountController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  Future<Widget> getDBTagsTexts() async {
    List<Tag> dbTags = await databaseHelper.getAllTags();

    return DropdownButtonFormField<String>(
      value: selectedCategory,
      items: dbTags.map((tag) {
        return DropdownMenuItem<String>(
          value: tag.name,
          child: Text(tag.name.toString()),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          selectedCategory = value ??
              'Academia'; // Define uma categoria padrão caso o valor seja nulo
        });
      },
      decoration: InputDecoration(labelText: 'Categoria'),
    );
  }

  Widget getDBTags() {
    return FutureBuilder(
      future: getDBTagsTexts(),
      builder: (context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return const Text(
            'Erro ao carregar as tags',
            style: TextStyle(color: Colors.black),
          );
        }
      },
    );
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
          getDBTags(),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              double amount = double.tryParse(amountController.text) ?? 0.0;
              String category = categoryController.text;
              widget.onTransacaoSalva(amount, category);
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
