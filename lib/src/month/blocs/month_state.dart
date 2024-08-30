import 'package:gastos/src/shared/models/Gasto.dart';

class MesState {
  final int index_open;

  final List<Gasto> gastos;

  final double saldo;

  MesState({
    this.index_open = -1,
    this.gastos = const <Gasto>[],
    this.saldo = 0.0,
  });

  MesState copyWith({
    int? index_open,
    List<Gasto>? gastos,
    double? saldo,
  }) {
    return MesState(
      index_open: index_open ?? this.index_open,
      gastos: gastos ?? this.gastos,
      saldo: saldo ?? this.saldo,
    );
  }
}
