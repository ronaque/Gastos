import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos/src/mes/blocs/mes_cubit.dart';
import 'package:gastos/src/mes/blocs/mes_state.dart';
import 'package:gastos/src/shared/data_utils.dart';
import 'package:gastos/src/shared/repositories/GastoHelper.dart';
import 'mes_module.dart';

class Mes extends StatefulWidget {
  final DateTime data;
  const Mes(this.data, {super.key});

  @override
  _MesState createState() => _MesState();
}

class _MesState extends State<Mes> {
  late DateTime date;
  GastoHelper gastoHelper = GastoHelper();
  Widget transactionsList = Container();
  List? toggled;
  MesCubit mesCubit = MesCubit();

  @override
  void initState() {
    date = widget.data;
    mesCubit.changeSaldo(date);
    mesCubit.changeGastos(date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MesCubit, MesState>(
        bloc: mesCubit,
        builder: (context, state) {
          return Scaffold(
            body: Column(
              children: [
                // Transações
                Expanded(
                  child: ListView.builder(
                      itemCount: state.gastos.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              mesCubit.checkIndex(index);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(18.0),
                              decoration: const BoxDecoration(
                                border: BorderDirectional(
                                    bottom: BorderSide(
                                        color: Color(0xfffefefe), width: 2)),
                              ),
                              // Transações
                              child: Row(
                                children: [
                                  // -- Data + Tag
                                  Expanded(
                                    flex: 3,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(width: 8.0),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${state.gastos[index].data.day}',
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              Text(
                                                getShortMonthStr(state
                                                    .gastos[index].data.month),
                                                style: const TextStyle(
                                                  fontSize: 10.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 12.0),
                                          getCategoryTextOrIcon(
                                              state.gastos[index].tag),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // -- Descrição
                                  Expanded(
                                      flex: 4,
                                      child: SingleChildScrollView(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 0, 0, 0),
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                            '${state.gastos[index].descricao}',
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                            )),
                                      )),
                                  const SizedBox(width: 12.0),
                                  // -- Valor
                                  Expanded(
                                      flex: 3,
                                      child: Column(
                                        children: [
                                          // -- Valor Texto
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: state.gastos[index].mode == 1
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'R\$${state.gastos[index].quantidade.abs().toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                          color: state
                                                                      .gastos[
                                                                          index]
                                                                      .quantidade <
                                                                  0
                                                              ? Colors.red
                                                              : Colors.green,
                                                          fontSize: 17.0,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${state.gastos[index].parcelas}x',
                                                        style: const TextStyle(
                                                          fontSize: 11.0,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Text(
                                                    'R\$${state.gastos[index].quantidade.abs().toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                      color: state.gastos[index]
                                                                  .quantidade <
                                                              0
                                                          ? Colors.red
                                                          : Colors.green,
                                                      fontSize: 17.0,
                                                    ),
                                                  ),
                                          ),

                                          // -- Editar/excluir
                                          index == state.index_open
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 10, 0, 0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          updateTransaction(
                                                              state.gastos[
                                                                  index],
                                                              mesCubit,
                                                              date,
                                                              context);
                                                          print('Editar');
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      10.0),
                                                          child: const Icon(
                                                              Icons.edit,
                                                              color:
                                                                  Colors.blue,
                                                              size: 22.0),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          removeGasto(
                                                              state.gastos[
                                                                  index],
                                                              context,
                                                              mesCubit,
                                                              date);
                                                          print('Excluir');
                                                        },
                                                        child: const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10.0),
                                                          child: Icon(
                                                              Icons.delete,
                                                              color: Colors.red,
                                                              size: 22.0),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      )),
                                ],
                              ),
                            ));
                      }),
                ),

                // -- BottomBar
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
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      // -- Saldo
                      Expanded(
                          flex: 7,
                          child: Row(
                            children: [
                              const SizedBox(width: 16.0),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xB02196F3),
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                      color: Colors.blue, width: 1.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x019E9E9E),
                                      offset: Offset(0, 2),
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(16.0),
                                child: getBalanceText(state.saldo),
                              ),
                            ],
                          )),

                      // -- Adicionar Transação
                      Expanded(
                          flex: 3,
                          child: FloatingActionButton(
                            onPressed: () {
                              addTransaction(mesCubit, date, context);
                              // mesCubit.changeGastos(data);
                              // mesCubit.changeSaldo(data);
                            },
                            backgroundColor: const Color(0xB02196F3),
                            child: const Icon(Icons.add),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
