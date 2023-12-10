import 'package:flutter/material.dart';
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
  late TextEditingController amountController;
  late TextEditingController categoryController;
  String? _clicado;
  bool? _isIncome;

  void adicionarTransacao() async {
    GastoHelper gastoHelper = GastoHelper();
    double amount = double.tryParse(amountController.text) ?? 0.0;
    if (getIsIncome() == false) {
      amount = amount * -1;
    }
    String category = getClicado();

    Tag? tag = await tagHelper.getTagByNome(category);
    if (tag == null) {
      return;
    }

    Gasto gasto = await novoGasto(DateTime.now(), amount, tag);
    gastoHelper.insertGasto(gasto);

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
  void initState() {
    super.initState();
    amountController = TextEditingController();
    categoryController = TextEditingController();
  }

  @override
  void dispose() {
    amountController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Adicionar Transação', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16.0),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Valor'),
          ),
          const SizedBox(height: 16.0),
          const Text('Categoria'),
          CardTags(setClicado, getClicado),
          const SizedBox(height: 16.0),
          EntradaSaida(setIsIncome, getIsIncome),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              adicionarTransacao();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}