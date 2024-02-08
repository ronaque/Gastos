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
import 'package:gastos/src/shared/repositories/GastoHelper.dart';
import 'package:gastos/src/shared/repositories/TagHelper.dart';

class AdicionarTransacaoModal extends StatefulWidget {
  const AdicionarTransacaoModal({super.key});

  @override
  _AdicionarTransacaoModalState createState() =>
      _AdicionarTransacaoModalState();
}

class _AdicionarTransacaoModalState extends State<AdicionarTransacaoModal> {
  TagHelper tagHelper = TagHelper();
  var amountController = new MoneyMaskedTextController(leftSymbol: 'R\$');
  TextEditingController descriptionController = TextEditingController();
  TextEditingController parcelasController = TextEditingController();
  String? _tagclicada;
  bool? _isIncome;
  PagamentoCubit pagamentoCubit = PagamentoCubit();
  List<String> parcelas = ['2x', '3x', '4x', '5x', '6x', '7x', '8x', '9x', '10x', '11x', '12x', '+'];
  String dropdownValue = '2x';

  void adicionarTransacao(DateTime data) async {
    GastoHelper gastoHelper = GastoHelper();

    if (amountController.text.isEmpty) {
      Alerta(text: 'Informe um valor').show(context);
      return null;
    }
    double amount = double.tryParse(amountController.text.replaceRange(0, 2, '').replaceAll('.', '').replaceAll(',', '.')) ?? 0.0;
    if (getIsIncome() == null){
      Alerta(text: 'Informe se é entrada ou saída').show(context);
      return null;
    }
    if (getIsIncome() == false) {
      amount = amount * -1;
    }
    String category = getClicado();
    String descricao = descriptionController.text;

    Tag? tag = await tagHelper.getTagByNome(category);
    if (tag == null) {
      // Fazer um alerta para o usuário informando que deve escolher uma tag
      Alerta(text: 'Escolha uma categoria').show(context);
      return null;
    }

    Gasto gasto = await novoGasto(data, amount, tag, descricao);
    await gastoHelper.insertGasto(gasto);

    Navigator.pop(context);
  }

  void adicionarParcelas(int numParcelas) async {

  }

  bool? getIsIncome(){
    return _isIncome;
  }

  void setIsIncome(bool value) {
    _isIncome = value;
  }

  void setClicado(String value) {
    _tagclicada = value;
  }

  String getClicado() {
    return _tagclicada ?? '';
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
                  state.pagamento != -1 ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        state.pagamento == 2 ? Text('Funcionalidade de Assinatura ainda não implementada', style: Theme.of(context).textTheme.titleLarge) : Container(),

                        // Titulo
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text('Adicionar Transação', style: Theme.of(context).textTheme.titleLarge),
                        ),

                        // Valor
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: TextFormField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  )
                              )
                          ),
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
                                )
                            ),
                          ),
                        ),

                        // Parcelas
                        state.pagamento == 1 ? const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: Text('Parcelas'),
                        ) : Container(),
                        state.pagamento == 1 ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Dropdown
                            Expanded(
                              flex: 5,
                              child: DropdownButtonFormField<String>(
                                value: state.dropdownValue,
                                decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(),
                                      )
                                  ),
                                onChanged: (String? value) {
                                  String? auxvalue = value?.replaceAll(RegExp(r'[x]'), '');
                                  int parcelas = int.tryParse(auxvalue!) ?? -1;
                                  pagamentoCubit.changeParcelas(parcelas);
                                  pagamentoCubit.changeDropdownValue(value!);
                                  // print("teste ${state.parcelas}");
                                },
                                items: parcelas.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            state.parcelas == -1 || state.parcelas > 12 ? Expanded(flex: 1, child: SizedBox(width: 10.0)): Container(),
                            // Parcelas > 12
                            state.parcelas == -1 || state.parcelas > 12 ? Expanded(
                              flex: 5,
                              child: TextFormField(
                                controller: parcelasController,
                                keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(),
                                    )
                                ),
                                onFieldSubmitted: (String value) {
                                  int parcelas = int.tryParse(value) ?? -1;
                                  pagamentoCubit.changeParcelas(parcelas);
                                  if (parcelas >= 2 && parcelas <= 12) {
                                    pagamentoCubit.changeDropdownValue('$parcelas' + 'x');
                                  }
                                },
                              ),
                            ) : Container(),
                          ],
                        ) : Container(),

                        const SizedBox(height: 10.0),
                        const Text('Categoria'),
                        CardTags(setClicado, getClicado),
                        const SizedBox(height: 10.0),
                        EntradaSaida(setIsIncome, getIsIncome),
                        const SizedBox(height: 10.0),

                        // Botão Salvar
                        ElevatedButton(
                          onPressed: () {
                            state.pagamento == 0 ? adicionarTransacao(DateTime.now()) : null;
                            state.pagamento == 1 ? adicionarParcelas(state.parcelas) : null;
                          },
                          child: const Text('Salvar'),
                        ),
                      ],
                    ) : Container(),

                  SizedBox(height: 20.0),
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
                            color: state.pagamento == 0 ? Colors.blue : Colors.white,
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "A vista",
                            style: TextStyle(
                              fontSize: 16,
                              color: state.pagamento == 0 ? Colors.white : Colors.black,
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
                            color: state.pagamento == 1 ? Colors.blue : Colors.white,
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Parcelamento",
                            style: TextStyle(
                              fontSize: 16,
                              color: state.pagamento == 1 ? Colors.white : Colors.black,
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
                            color: state.pagamento == 2 ? Colors.blue : Colors.white,
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Assinatura",
                            style: TextStyle(
                              fontSize: 16,
                              color: state.pagamento == 2 ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )
          ),
        );
      }
    );
  }
}

