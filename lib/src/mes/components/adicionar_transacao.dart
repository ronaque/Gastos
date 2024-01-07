import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:gastos/src/shared/components/alert_dialog.dart';
import 'package:gastos/src/shared/gasto_utils.dart';
import 'package:gastos/src/shared/models/Gasto.dart';
import 'package:gastos/src/shared/models/Tag.dart';
import 'package:gastos/src/shared/repositories/GastoHelper.dart';
import 'package:gastos/src/shared/repositories/TagHelper.dart';
import 'card_tags.dart';
import 'entrada_saida.dart';

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
  String? _clicado;
  bool? _isIncome;

  void adicionarTransacao() async {
    GastoHelper gastoHelper = GastoHelper();
    if (amountController.text.isEmpty) {
      Alerta('Informe um valor').show(context);
      return null;
    }
    double amount = double.tryParse(amountController.text) ?? 0.0;
    if (getIsIncome() == null){
      Alerta('Informe se é entrada ou saída').show(context);
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
      Alerta('Escolha uma categoria').show(context);
      return null;
    }

    Gasto gasto = await novoGasto(DateTime.now(), amount, tag, descricao);
    await gastoHelper.insertGasto(gasto);

    Navigator.pop(context);
  }

  bool? getIsIncome(){
    return _isIncome;
  }

  void setIsIncome(bool value) {
    _isIncome = value;
  }

  void setClicado(String value) {
    _clicado = value;
  }

  String getClicado() {
    return _clicado ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text('Adicionar Transação', style: Theme.of(context).textTheme.titleLarge),
            ),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: TextFormField(
                controller: descriptionController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    )
                ),
              ),
            ),
            const Text('Categoria'),
            CardTags(setClicado, getClicado),
            const SizedBox(height: 10.0),
            EntradaSaida(setIsIncome, getIsIncome),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                adicionarTransacao();
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}