import 'package:bloc/bloc.dart';
import 'package:gastos/src/pagamento/blocs/pagamento_state.dart';

class PagamentoCubit extends Cubit<PagamentoState> {
  PagamentoCubit() : super(PagamentoState());

  void changePagamento(int pagamento) {
    emit(state.copyWith(pagamento: pagamento));
  }

  void checkPagamento(int pagamento) {
    if (state.pagamento == pagamento) {
      emit(state.copyWith(pagamento: -1));
    } else {
      emit(state.copyWith(pagamento: pagamento));
    }
  }

  void changeParcelas(int parcelas) {
    emit(state.copyWith(parcelas: parcelas));
  }

  void changeDropdownValue(String dropdownValue) {
    emit(state.copyWith(dropdownValue: dropdownValue));
  }
}
