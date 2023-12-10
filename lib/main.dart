import 'package:flutter/material.dart';
import 'package:gastos/src/home/home_page.dart';
import 'package:gastos/theme.dart';
import 'package:gastos/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: MyApp(), theme: AppTheme().getAppTheme()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login', // Defina a tela de login como rota inicial
      routes: {
        '/login': (context) => LoginPage(),
        '/main': (context) => Home(),
      },
    );
  }
}


