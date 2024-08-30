import 'package:flutter/material.dart';

class Alerta extends StatelessWidget {
  final String? text;
  final String? action;
  final String? cancel;

  const Alerta({super.key, this.text, this.action, this.cancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Alerta!'),
      content: text != null ? Text(text!) : const Text('Nada a alertar'),
      actions: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          cancel != null
              ? TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(cancel!,
                        style: const TextStyle(color: Colors.red)),
                  ))
              : Container(),
          action != null
              ? TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(action!),
                  ))
              : TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Ok'),
                  )),
        ]),
      ],
    );
  }

  Future<bool> show(BuildContext context) async {
    bool? confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return this;
      },
    );

    return confirmed ?? false;
  }
}
