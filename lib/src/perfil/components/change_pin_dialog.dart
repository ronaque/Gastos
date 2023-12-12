import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> savePin(String pin) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('pin', pin);
  print('PIN salvo: $pin');
}

displayChangePinDialog(BuildContext context, pinController) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Alterar PIN'),
        content: SizedBox(
          height: 150,
          child: Column(
            children: [
              TextField(
                controller: pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration:
                const InputDecoration(labelText: 'Novo PIN (4 dígitos)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (pinController.text.length == 4) {
                    savePin(pinController.text);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('O PIN deve ter 4 dígitos.'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 5,
                ),
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      );
    },
  );
}