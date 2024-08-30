import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:gastos/src/pagamento/blocs/pagamento_cubit.dart';
import 'package:gastos/src/pagamento/blocs/pagamento_state.dart';
import 'package:gastos/src/pagamento/components/card_tags.dart';
import 'package:gastos/src/pagamento/components/entrada_saida.dart';
import 'package:gastos/src/shared/components/alert_dialog.dart';
import 'package:gastos/src/shared/gasto_utils.dart';
import 'package:gastos/src/shared/models/Gasto.dart';
import 'package:gastos/src/shared/models/Tag.dart';
import 'package:gastos/src/shared/repositories/TagHelper.dart';
import 'package:gastos/src/shared/tag_utils.dart';

class AdicionarTransacaoModal extends StatefulWidget {
  const AdicionarTransacaoModal({super.key});

  @override
  _AdicionarTransacaoModalState createState() =>
      _AdicionarTransacaoModalState();
}

class _AdicionarTransacaoModalState extends State<AdicionarTransacaoModal> {
  TagHelper tagHelper = TagHelper();
  var amountController = MoneyMaskedTextController(leftSymbol: 'R\$');
  TextEditingController descriptionController = TextEditingController();
  TextEditingController parcelasController = TextEditingController();
  String? _selectedTag;
  bool? _isIncome;
  OverlayEntry? overlayEntry;
  GlobalKey valueGlobalKey = GlobalKey();
  PagamentoCubit pagamentoCubit = PagamentoCubit();
  List<String> parcelas = [
    '2x',
    '3x',
    '4x',
    '5x',
    '6x',
    '7x',
    '8x',
    '9x',
    '10x',
    '11x',
    '12x',
    '+'
  ];
  String dropdownValue = '2x';

  Future<bool> _createGasto(DateTime date, int mode, int parcelas) async {
    if (amountController.text.isEmpty) {
      const Alerta(text: 'Informe um valor').show(context);
      return false;
    }
    double amount = double.tryParse(amountController.text
            .replaceRange(0, 2, '')
            .replaceAll('.', '')
            .replaceAll(',', '.')) ??
        0.0;

    String category = _getSelectedTag();
    String description = descriptionController.text;

    Tag? tag = await getTagByNome(category);
    if (tag == null) {
      // Fazer um alerta para o usuário informando que deve escolher uma tag
      const Alerta(text: 'Escolha uma categoria').show(context);
      return false;
    }

    if (getIsIncome() == null) {
      const Alerta(text: 'Informe se é entrada ou saída').show(context);
      return false;
    }
    if (getIsIncome() == false) {
      amount = amount * -1;
    }

    Gasto gasto =
        await createGasto(date, amount, tag, description, mode, parcelas);
    insertGasto(gasto);
    print('Gasto inserido com sucesso: ${gasto.toString()}');

    if (mode == 0) {
      Navigator.pop(context);
    }

    return true;
  }

  void addParcelas(int numParcelas) async {
    DateTime date = DateTime.now();
    for (int i = 0; i < numParcelas; i++) {
      if (i > 0) {
        int year = date.year;
        int month = date.month + 1;
        if (month > 12) {
          month = month - 12;
          year += 1;
        }
        date = DateTime(year, month, 1);
      }
      bool result = await _createGasto(date, 1, i + 1);
      if (result == false) {
        print("Erro ao adicionar parcela ${i + 1}");
        return;
      }
    }
    Navigator.pop(context);
  }

  bool? getIsIncome() {
    return _isIncome;
  }

  void _setIsIncome(bool value) {
    _isIncome = value;
  }

  void _setSelectedTag(String value) {
    _selectedTag = value;
  }

  String _getSelectedTag() {
    return _selectedTag ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagamentoCubit, PagamentoState>(
        bloc: pagamentoCubit,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Column(
              children: [
                state.pagamento != -1 && state.pagamento != 2
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Titulo
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Text('Adicionar Transação',
                                style: Theme.of(context).textTheme.titleLarge),
                          ),

                          // Valor
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: TextFormField(
                                key: valueGlobalKey,
                                onTap: () {
                                  state.pagamento == 1
                                      ? _showOverlay(context,
                                          text:
                                              'Informe o valor de cada parcela')
                                      : null;
                                },
                                controller: amountController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    suffixIcon: Icon(Icons.info,
                                        color: Color(0xff90CAF9)),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                    ))),
                          ),

                          // Descrição
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: TextFormField(
                              controller: descriptionController,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                  labelText: 'Descrição',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  )),
                            ),
                          ),

                          // Parcelas
                          state.pagamento == 1
                              ? const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                                  child: Text('Parcelas'),
                                )
                              : Container(),
                          state.pagamento == 1
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Dropdown
                                    Expanded(
                                      flex: 5,
                                      child: DropdownButtonFormField<String>(
                                        value: state.dropdownValue,
                                        decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(),
                                            )),
                                        onChanged: (String? value) {
                                          String? auxvalue = value?.replaceAll(
                                              RegExp(r'[x]'), '');
                                          int parcelas =
                                              int.tryParse(auxvalue!) ?? -1;
                                          pagamentoCubit
                                              .changeParcelas(parcelas);
                                          pagamentoCubit
                                              .changeDropdownValue(value!);
                                          // print("teste ${state.parcelas}");
                                        },
                                        items: parcelas
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    state.parcelas == -1 || state.parcelas > 12
                                        ? const Expanded(
                                            flex: 1,
                                            child: SizedBox(width: 10.0))
                                        : Container(),
                                    // Parcelas > 12
                                    state.parcelas == -1 || state.parcelas > 12
                                        ? Expanded(
                                            flex: 5,
                                            child: TextFormField(
                                              controller: parcelasController,
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                  decimal: false,
                                                  signed: false),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              decoration: const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          10, 0, 10, 0),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(),
                                                  )),
                                              onFieldSubmitted: (String value) {
                                                int parcelas =
                                                    int.tryParse(value) ?? -1;
                                                pagamentoCubit
                                                    .changeParcelas(parcelas);
                                                if (parcelas >= 2 &&
                                                    parcelas <= 12) {
                                                  pagamentoCubit
                                                      .changeDropdownValue(
                                                          '$parcelas' 'x');
                                                }
                                              },
                                            ),
                                          )
                                        : Container(),
                                  ],
                                )
                              : Container(),

                          const SizedBox(height: 10.0),
                          const Text('Categoria'),
                          CardTags(_setSelectedTag, _getSelectedTag),
                          const SizedBox(height: 10.0),
                          EntradaSaida(_setIsIncome, getIsIncome),
                          const SizedBox(height: 10.0),

                          // Botão Salvar
                          ElevatedButton(
                            onPressed: () {
                              state.pagamento == 0
                                  ? _createGasto(DateTime.now(), 0, 0)
                                  : null;
                              state.pagamento == 1
                                  ? addParcelas(state.parcelas)
                                  : null;
                            },
                            child: const Text('Salvar'),
                          ),
                        ],
                      )
                    : Container(),

                const SizedBox(height: 20.0),
                // Selecionar pagamento Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Pagamento a vista
                    GestureDetector(
                      onTap: () {
                        pagamentoCubit.checkPagamento(0);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.width * 0.12,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color:
                              state.pagamento == 0 ? Colors.blue : Colors.white,
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "A vista",
                          style: TextStyle(
                            fontSize: 16,
                            color: state.pagamento == 0
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),

                    // Pagamento parcelado
                    GestureDetector(
                      onTap: () {
                        pagamentoCubit.checkPagamento(1);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.width * 0.12,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color:
                              state.pagamento == 1 ? Colors.blue : Colors.white,
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Parcelamento",
                          style: TextStyle(
                            fontSize: 16,
                            color: state.pagamento == 1
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),

                    // Assinatura
                    GestureDetector(
                      onTap: () {
                        pagamentoCubit.checkPagamento(2);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.width * 0.12,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color:
                              state.pagamento == 2 ? Colors.blue : Colors.white,
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Assinatura",
                          style: TextStyle(
                            fontSize: 16,
                            color: state.pagamento == 2
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            )),
          );
        });
  }

  void _showOverlay(BuildContext context, {required String text}) {
    RenderBox renderBox =
        valueGlobalKey.currentContext?.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    print("dx dy ${offset.dx} ${offset.dy}");
    OverlayEntry newOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + 13,
        left: offset.dx,
        width: MediaQuery.of(context).size.width,
        child: Material(
          color: Colors.transparent,
          child: Container(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color(0xF590CAF9),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 12.0),
              ),
            ),
          ),
        ),
      ),
    );

    overlayEntry?.remove();
    overlayEntry = newOverlayEntry;

    Overlay.of(context).insert(overlayEntry!);

    // Remove the overlay after a certain duration
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry?.remove();
    });
  }
}
