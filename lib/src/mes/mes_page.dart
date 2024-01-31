import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos/src/mes/blocs/mes_cubit.dart';
import 'package:gastos/src/mes/blocs/mes_state.dart';
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
  MesCubit mesCubit = MesCubit();

  @override
  void initState() {
    data = widget.data;
    mesCubit.changeGastos(data);
    super.initState();
  }

  Widget buildTransactionList() {
    return Stack(
      children: [
        _buildTransactionListView(),
        buildSaldoContainer(),
      ],
    );
  }

  Widget _buildTransactionListView() {
    return BlocBuilder<MesCubit, MesState>(
      bloc: mesCubit,
      builder: (context, state) {
        return Expanded(
          child: ListView.builder(
              itemCount: state.gastos.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      print('state ${state.index_open}');
                      mesCubit.checkIndex(index);
                      print('state ${state.index_open}');
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
                                        '${state.gastos[index].data!.day}',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      Text(
                                        '${retornarMesAbreviado(state.gastos[index].data!.month)}',
                                        style: const TextStyle(
                                          fontSize: 10.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 12.0),
                                  getCategoryTextOrIcon(state.gastos[index].tag!),
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
                                    '${state.gastos[index].descricao}',
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
                                      'R\$${state.gastos[index].quantidade?.abs().toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: state.gastos[index].quantidade! < 0 ? Colors.red : Colors.green,
                                        fontSize: 17.0,
                                      ),
                                    ),
                                  ),
                                  index == state.index_open ? Padding(
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
                                            excluirGasto(state.gastos[index], context, mesCubit, data);
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTransactionListView(),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(0, 2),
                  blurRadius: 6.0,
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Row(
                    children: [
                      SizedBox(width: 16.0),
                      Container(
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
                        padding: const EdgeInsets.all(16.0),
                        child: getSaldoTexto(),
                      ),
                    ],
                  )
                ),
                Expanded(
                    flex: 3,
                    child: FloatingActionButton(
                  onPressed: () {
                    adicionarTransacao(mesCubit, data, context);
                  },
                  backgroundColor: const Color(0xB02196F3),
                  child: const Icon(Icons.add),
                )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}