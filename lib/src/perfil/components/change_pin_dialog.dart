import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> savePin(String pin) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('pin', pin);
  print('PIN salvo: $pin');
}

displayChangePinDialog(BuildContext context, _pinController) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Alterar PIN'),
        content: Container(
          height: 150,
          child: Column(
            children: [
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration:
                InputDecoration(labelText: 'Novo PIN (4 dígitos)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_pinController.text.length == 4) {
                    savePin(_pinController.text);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('O PIN deve ter 4 dígitos.'),
                      ),
                    );
                  }
                },
                child: Text('Salvar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}