import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastos/views/card_tags.dart';
import 'package:gastos/views/entrada_saida.dart';

class AdicionarTransacaoModal extends StatefulWidget {
  final Function(double amount, String category) onTransacaoSalva;

  AdicionarTransacaoModal({required this.onTransacaoSalva});

  @override
  _AdicionarTransacaoModalState createState() =>
      _AdicionarTransacaoModalState();
}

class _AdicionarTransacaoModalState extends State<AdicionarTransacaoModal> {
  late TextEditingController amountController;
  late TextEditingController categoryController;
  String? _clicado;
  bool? _isIncome = null;

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
          Text('Adicionar Transação'),
          SizedBox(height: 16.0),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Valor'),
          ),
          SizedBox(height: 16.0),
          Text('Categoria'),
          CardTags(setClicado, getClicado),
          SizedBox(height: 16.0),
          EntradaSaida(setIsIncome, getIsIncome),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              double amount = double.tryParse(amountController.text) ?? 0.0;
              if (getIsIncome() == false) {
                amount = amount * -1;
              }
              String category = getClicado();
              widget.onTransacaoSalva(amount, category);
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }
}