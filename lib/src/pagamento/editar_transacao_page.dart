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

class EditarTransacaoModal extends StatefulWidget {
  final Gasto gasto;
  const EditarTransacaoModal(this.gasto, {super.key});

  @override
  _EditarTransacaoModalState createState() =>
      _EditarTransacaoModalState();
}

class _EditarTransacaoModalState extends State<EditarTransacaoModal> {
  TagHelper tagHelper = TagHelper();
  var amountController = new MoneyMaskedTextController(leftSymbol: 'R\$');
  TextEditingController descriptionController = TextEditingController();
  TextEditingController parcelasController = TextEditingController();
  String? _tagclicada;
  bool? _isIncome;
  OverlayEntry? overlayEntry;
  GlobalKey valorkey = GlobalKey();
  PagamentoCubit pagamentoCubit = PagamentoCubit();
  List<String> parcelas = ['2x', '3x', '4x', '5x', '6x', '7x', '8x', '9x', '10x', '11x', '12x', '+'];
  String dropdownValue = '2x';

  @override
  void initState(){
    amountController.updateValue(widget.gasto.quantidade!);
    descriptionController.text = widget.gasto.descricao!;
    parcelasController.text = widget.gasto.parcelas.toString();
    _tagclicada = widget.gasto.tag!.nome;
    _isIncome = widget.gasto.quantidade! > 0;
    super.initState();
  }

  Future<bool?> editarTransacao(Gasto gasto) async {
    GastoHelper gastoHelper = GastoHelper();

    if (amountController.text.isEmpty) {
      Alerta(text: 'Informe um valor').show(context);
      return false;
    }
    double amount = double.tryParse(amountController.text.replaceRange(0, 2, '').replaceAll('.', '').replaceAll(',', '.')) ?? 0.0;

    String category = getClicado();
    String descricao = descriptionController.text;

    Tag? tag = await tagHelper.getTagByNome(category);
    if (tag == null) {
      // Fazer um alerta para o usuário informando que deve escolher uma tag
      Alerta(text: 'Escolha uma categoria').show(context);
      return false;
    }

    if (getIsIncome() == null){
      Alerta(text: 'Informe se é entrada ou saída').show(context);
      return false;
    }
    if (getIsIncome() == false) {
      amount = amount * -1;
    }

    gasto = Gasto(id: gasto.id, data: gasto.data, quantidade: amount, tag: tag, descricao: descricao, mode: gasto.mode, parcelas: gasto.parcelas);

    // Gasto gasto = await novoGasto(data, amount, tag, descricao, mode, parcelas);
    bool update = await gastoHelper.atualizarGasto(gasto);
    if (!update) {
      Alerta(text: 'Erro ao atualizar gasto').show(context);
      return false;
    }
    print('Gasto atualizado com sucesso: ${gasto.toString()}');

    if (widget.gasto.mode == 0)
      Navigator.pop(context);

    return true;
  }

  void editarParcelas() async {
    List<Gasto> listParcelasGastos = await listarParcelasGasto(widget.gasto);
    listParcelasGastos.forEach((gasto) async {
      editarTransacao(gasto);
    });
    Navigator.pop(context);
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
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Titulo
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text('Editar Transação', style: Theme.of(context).textTheme.titleLarge),
                        ),

                        // Valor
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: TextFormField(
                              key: valorkey,
                              onTap: () {
                                widget.gasto.mode == 1 ? _showOverlay(context, text: 'Informe o valor de cada parcela') : null;
                              },
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.info, color: Color(0xff90CAF9)),
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

                        const SizedBox(height: 10.0),
                        const Text('Categoria'),
                        CardTags(setClicado, getClicado),
                        const SizedBox(height: 10.0),
                        EntradaSaida(setIsIncome, getIsIncome),
                        const SizedBox(height: 10.0),

                        // Botão Salvar
                        ElevatedButton(
                          onPressed: () {
                            widget.gasto.mode == 0 ? editarTransacao(widget.gasto) : null;
                            widget.gasto.mode == 1 ? editarParcelas() : null;
                          },
                          child: const Text('Salvar'),
                        ),
                      ],
                    ),
                  ],
                )
            ),
          );
        }
    );
  }

  void _showOverlay(BuildContext context, {required String text}) {
    RenderBox renderBox = valorkey.currentContext?.findRenderObject() as RenderBox;
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
                color: Color(0xF590CAF9),
              ),
              padding: EdgeInsets.all(10.0),
              child: Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 12.0),
              ),
            ),
          ),
        ),
      ),
    );

    overlayEntry?.remove();
    overlayEntry = newOverlayEntry;

    Overlay.of(context)?.insert(overlayEntry!);

    // Remove the overlay after a certain duration
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry?.remove();
    });
  }
}

