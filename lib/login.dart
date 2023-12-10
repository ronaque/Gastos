import 'package:flutter/material.dart';
import 'package:gastos/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController pinController = TextEditingController();

  LoginPage({super.key});

  Future<void> authenticateUser(String enteredPin, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? savedPin = prefs.getString('pin');

    if (savedPin == null) {
      // Se a senha nunca foi alterada, aceitar a senha padrão "0000"
      if (enteredPin == '0000') {
        // Navegar para a tela principal
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Senha inválida
        showInvalidPinDialog(context);
      }
    } else {
      // Senha já foi alterada, verificar com a senha salva
      if (enteredPin == savedPin) {
        // Senha válida, navegar para a tela principal
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Senha inválida
        showInvalidPinDialog(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.attach_money,
                size: 64.0,
                color: AppTheme().blueColors[500],
              ),
              const SizedBox(height: 20.0),
              const Text(
                'MobiFin',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50.0),
              TextField(
                controller: pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'PIN (4 dígitos)',
                ),
              ),
              const SizedBox(height: 50.0),
              ElevatedButton(
                onPressed: () {
                  authenticateUser(pinController.text, context);
                },
                child: const SizedBox(
                  width: double.infinity, // Largura máxima possível
                  child: Center(
                    child: Text('Entrar'),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  _exibirModalInfoPIN(context);
                },
                child: const Text(
                  'Não tem um PIN?',
                  style: TextStyle(
                    color: Colors.blue, // ou a cor desejada
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showInvalidPinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: const Text('PIN inválido. Tente novamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _exibirModalInfoPIN(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Informação sobre o PIN'),
          content: const Text(
            'Se você nunca alterou seu PIN, o valor padrão é 0000. '
                'Após desbloquear o app é possível alterar seu PIN na tela de perfil.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}