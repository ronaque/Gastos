import 'package:flutter/material.dart';
import 'package:gastos/src/home/home_page.dart';
import 'package:gastos/src/month/month_page.dart';
import 'package:gastos/src/resumo/resumo_page.dart';
import 'package:gastos/src/profile/profile_page.dart';
import 'package:gastos/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: const MyApp(),
    theme: AppTheme().getAppTheme(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home', // Defina a tela de login como rota inicial
      routes: {
        '/home': (context) => const Home(),
        '/mes': (context) => Month(DateTime.now()),
        '/perfil': (context) => const Profile(),
        '/resumo': (context) => const Resumo(),
      },
    );
  }
}
