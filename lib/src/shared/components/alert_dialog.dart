import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Alerta extends StatelessWidget{
  final String text;

  const Alerta(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Alerta!'),
      content: Text(text),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('Ok'),
          )
        ),
      ],
    );
  }

  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return this;
      },
    );
  }

}