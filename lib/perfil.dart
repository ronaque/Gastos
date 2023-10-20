import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastos/theme.dart';

class Perfil extends StatelessWidget {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _salarioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: AppTheme().getAppTheme(),
    child: Scaffold(
      body: Text("oi"),
    )
    );
  }
}