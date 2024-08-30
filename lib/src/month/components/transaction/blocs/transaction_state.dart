class PagamentoState {
  final int pagamento; // 0 - a vista, 1 - parcelado, 2 - assinatura

  final int parcelas;

  final String dropdownValue;

  PagamentoState({
    this.pagamento = -1,
    this.parcelas = 2,
    this.dropdownValue = '2x',
  });

  PagamentoState copyWith({
    int? pagamento,
    int? parcelas,
    String? dropdownValue,
  }) {
    return PagamentoState(
      pagamento: pagamento ?? this.pagamento,
      parcelas: parcelas ?? this.parcelas,
      dropdownValue: dropdownValue ?? this.dropdownValue,
    );
  }
}