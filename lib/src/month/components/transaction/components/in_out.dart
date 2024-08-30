import 'package:flutter/material.dart';

class InOut extends StatefulWidget {
  final void Function(bool value) setIsIncome;
  final bool? Function() getIsIncome;

  const InOut(this.setIsIncome, this.getIsIncome, {super.key});

  @override
  _InOutState createState() => _InOutState();
}

class _InOutState extends State<InOut> {
  getIsIncomeBoxColor(bool isIncome, Color color) {
    if (widget.getIsIncome() == isIncome) {
      return color;
    } else {
      return Colors.white;
    }
  }

  getIsIncomeTextColor(bool isIncome) {
    if (widget.getIsIncome() == isIncome) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      GestureDetector(
          onTap: () {
            widget.setIsIncome(true);
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.width * 0.12,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: getIsIncomeBoxColor(true, Colors.green),
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Entrada',
                style: TextStyle(
                  fontSize: 16,
                  color: getIsIncomeTextColor(true),
                ),
              ),
            ),
          )),
      GestureDetector(
          onTap: () {
            widget.setIsIncome(false);
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.width * 0.12,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: getIsIncomeBoxColor(false, Colors.red),
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Saida',
                style: TextStyle(
                  fontSize: 16,
                  color: getIsIncomeTextColor(false),
                ),
              ),
            ),
          )),
    ]);
  }
}
