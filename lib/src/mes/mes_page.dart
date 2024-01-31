import 'package:flutter/material.dart';
import 'package:gastos/src/shared/data_utils.dart';
import 'package:gastos/src/shared/models/Gasto.dart';
import 'package:gastos/src/shared/repositories/GastoHelper.dart';
import 'components/adicionar_transacao.dart';
import 'mes_module.dart';
import 'package:intl/intl.dart';

class Mes extends StatefulWidget {
  final DateTime data;
  const Mes(this.data, {super.key});

  @override
  _MesState createState() => _MesState();
}

class _MesState extends State<Mes> {
  late DateTime data;
  GastoHelper gastoHelper = GastoHelper();
  Widget transactionsList = Container();
  List? toggled;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var listGastos = await gastoHelper.getGastosDoMes(DateFormat('y').format(data), DateFormat('MM').format(data));
      setState(() {
        toggled = List.generate(listGastos!.length, (index) => false);
      });
    });
    data = widget.data;
    super.initState();
  }

  Widget buildTransactionList(List<Gasto> transactions) {
    return Stack(
      children: [
        _buildTransactionListView(transactions),
        buildSaldoContainer(),
      ],
    );
  }

  Widget _buildTransactionListView(List<Gasto> gastos) {
    return Expanded(
      child: ListView.builder(
          itemCount: gastos.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  for (int i = 0; i < toggled!.length; i++) {
                    if (i != index) {
                      toggled?[i] = false;
                    } else {
                      toggled?[i] = !toggled![i];
                    }
                  }
                  setState(() {});
                  print('teste $index');
                },
                child: Container(
                  padding: const EdgeInsets.all(18.0),
                  decoration: const BoxDecoration(
                    border: BorderDirectional(bottom: BorderSide(color: Color(0xfffefefe), width: 2)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(width: 8.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${gastos[index].data!.day}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Text(
                                    '${retornarMesAbreviado(gastos[index].data!.month)}',
                                    style: const TextStyle(
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12.0),
                              getCategoryTextOrIcon(gastos[index].tag!),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 4,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            scrollDirection: Axis.horizontal,
                            child: Text(
                                '${gastos[index].descricao}',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                )
                            ),
                          )
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                          flex: 3,
                          child: Column (
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  'R\$${gastos[index].quantidade?.abs().toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: gastos[index].quantidade! < 0 ? Colors.red : Colors.green,
                                    fontSize: 17.0,
                                  ),
                                ),
                              ),
                              toggled?[index] == true ? Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        print('Editar');
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                                        child: Icon(Icons.edit, color: Colors.blue, size: 22.0),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        excluirGasto(gastos[index], context);
                                        print('Excluir');
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                                        child: Icon(Icons.delete, color: Colors.red, size: 22.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ) : Container(),
                            ],
                          )
                      ),
                    ],
                  ),
                )
            );
          }
      ),
    );
  }

  void adicionarTransacao() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const AdicionarTransacaoModal();
      },
    );
    var listGastos = await gastoHelper.getGastosDoMes(DateFormat('y').format(data), DateFormat('MM').format(data));
    toggled = List.generate(listGastos!.length, (index) => false);
    setState(() {
      transactionsList = buildTransactionList(listGastos);
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
      future: gastoHelper.getGastosDoMes(DateFormat('y').format(data), DateFormat('MM').format(data)), // financeManager.loadTransactions(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return buildEmptyState();
        } else {
          // toggled = List.generate(snapshot.data!.length, (index) => false);
          transactionsList = buildTransactionList(snapshot.data!);
          return transactionsList;
        }
      },
    );
  }
}