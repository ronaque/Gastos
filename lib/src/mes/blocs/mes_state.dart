import 'package:gastos/src/shared/models/Gasto.dart';

class MesState{

  final int index_open;

  final List<Gasto> gastos;

  MesState({
    this.index_open = -1,
    this.gastos = const <Gasto>[],
  });

  MesState copyWith({
    int? index_open,
    List<Gasto>? gastos,
  }) {
    return MesState(
      index_open: index_open ?? this.index_open,
      gastos: gastos ?? this.gastos,
    );
  }

}