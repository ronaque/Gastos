import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastos/perfil.dart';
import 'package:gastos/theme.dart';

void main() {
  runApp(MaterialApp(home: Home(), theme: AppTheme().getAppTheme()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void _abrirPerfil() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Perfil()));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Theme(
        data: AppTheme().getAppTheme(),
        child: Scaffold(
            appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 8.0,0, 0),
                      child: Text("Controle de Finanças"),
                    ),
                    IconButton(
                        onPressed: _abrirPerfil,
                        icon: Icon(Icons.account_circle_rounded, size: 35)
                    )
                  ],
                ),
              bottom: const TabBar(
                tabs: [
                  Tab(text: "Mês"),
                  Tab(text: "Resumo")
                ],
              ),
              ),
          body: TabBarView(
            children: [
              Text("mes"),
              Text("resumo")
            ],
          ),
            )
    ));
  }
}
