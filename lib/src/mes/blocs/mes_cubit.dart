import 'package:bloc/bloc.dart';
import 'package:gastos/src/mes/blocs/mes_state.dart';
import 'package:gastos/src/shared/models/Gasto.dart';
import 'package:gastos/src/shared/repositories/GastoHelper.dart';
import 'package:gastos/src/shared/saldo_utils.dart';
import 'package:intl/intl.dart';

class MesCubit extends Cubit<MesState>{
  MesCubit() : super(MesState());

  void checkIndex(int index){
    if (state.index_open == index) {
      index = -1;
    }
    changeIndex(index);
  }

  void changeIndex(int index){
    emit(state.copyWith(index_open: index));
  }

  void setGastos(List<Gasto> gastos){
    emit(state.copyWith(gastos: gastos));
  }

  Future<void> changeGastos(DateTime data) async {
    GastoHelper gastoHelper = GastoHelper();
    var listGastos = await gastoHelper.getGastosDoMes(DateFormat('y').format(data), DateFormat('MM').format(data));
    setGastos(listGastos!);
  }

  Future<void> changeSaldo(DateTime data) async {
    var saldo = await getSaldoByMonth(data);
    emit(state.copyWith(saldo: saldo));
  }
}