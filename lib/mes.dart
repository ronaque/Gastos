import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget returnMesDisplay(context){
  return ListView(
    children: [
      // Exemplo de registro de movimentação financeira
      FinanceEntry(amount: -50.0, textOrIcon: 'Popcorn'),
      FinanceEntry(amount: 100.0, textOrIcon: 'Money'),
      FinanceEntry(amount: -50.0, textOrIcon: 'Car'),
      FinanceEntry(amount: 100.0, textOrIcon: 'Food'),
      FinanceEntry(amount: 100.0, textOrIcon: 'Academia'),
    ],
  );
}

class FinanceEntry extends StatelessWidget {
  final double amount;
  final String textOrIcon;

  FinanceEntry({required this.amount, required this.textOrIcon});

  Widget _buildIconOrText(String textOrIcon) {
    switch (textOrIcon) {
      case 'Popcorn':
        return Icon(Icons.local_dining, color: Colors.blue, size: 30.0);
      case 'Money':
        return Icon(Icons.attach_money, color: Colors.blue, size: 30.0);
      case 'Car':
        return Icon(Icons.directions_car, color: Colors.blue, size: 30.0);
      case 'Food':
        return Icon(Icons.restaurant, color: Colors.blue, size: 30.0);
      default:
        return Text(
          textOrIcon,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 18.0,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color amountColor = amount < 0 ? Colors.red : Colors.green;

    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                '\$${amount.toStringAsFixed(2)}',
                style: TextStyle(color: amountColor),
              ),
              SizedBox(width: 8.0),
              _buildIconOrText(textOrIcon),
            ],
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}