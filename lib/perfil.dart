import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastos/theme.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _salarioController = TextEditingController();

  void _nomeChange(String value) {
    if (value.isEmpty) {
      return;
    }

    _nomeController.text = value;
  }

  void _salarioChange(String value) {
    if (value.isEmpty) {
      return;
    }

    _salarioController.text = value;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: AppTheme().getAppTheme(),
        child: Scaffold(
          appBar: AppBar(
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                  child: Text("Controle de Finanças"),
                )
              ],
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("imagem")
                      // CircleAvatar(
                      //     radius: 100,
                      //     backgroundImage:
                      //         AssetImage("assets/images/perfil.jpg"),
                      //
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          width: 250,
                          child: TextField(
                            onChanged: (value) => _nomeChange(value),
                            keyboardType: TextInputType.name,
                            controller: _nomeController,
                            decoration: const InputDecoration(
                                labelText: "Nome do Usuário",
                                border: const OutlineInputBorder()),
                          )),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          width: 250,
                          child: TextField(
                            onChanged: (value) => _salarioChange(value),
                            keyboardType: TextInputType.number,
                            controller: _salarioController,
                            decoration: const InputDecoration(
                                labelText: "Salário",
                                border: const OutlineInputBorder()),
                          )),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Tags"),
                    ],
                  )),
            ],
          ),
        ));
  }
}
