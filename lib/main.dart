import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:gastos/perfil.dart';
import 'package:gastos/theme.dart';
import 'package:gastos/resumo.dart';
import 'package:gastos/mes.dart';
import 'package:gastos/login.dart';
import 'package:gastos/store/imageUtils.dart';

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

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  File? _imageFile;
  Image? image;
  List<FinanceEntry> transactions = [];
  late TabController _tabController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var resultImage = await loadImage(_imageFile, image);
      setState(() {
        image = resultImage;
      });
    });
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _abrirPerfil() async {
    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => Perfil()));

    if (result != null) {
      var resultImage = await loadImage(_imageFile, image);
      setState(() {
        image = resultImage;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  CircleAvatar defaultAvatar() {
    return const CircleAvatar(
        radius: 64, backgroundImage: AssetImage("images/user.png"));
  }

  CircleAvatar profileAvatar() {
    if (image == null) {
      return const CircleAvatar(
          radius: 64, backgroundImage: AssetImage("images/user.png"));
    }
    return CircleAvatar(radius: 64, backgroundImage: image?.image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(
              Icons.attach_money,
              color: Colors.white,
            ),
            SizedBox(
                width: 8.0), // Adicione algum espaço entre o ícone e o texto
            Text(
              'MobiFin',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: image != null ? profileAvatar() : defaultAvatar(),
            onPressed: _abrirPerfil,
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                child: Row(
                  children: [
                    SizedBox(width: 35),
                    Text(_getMonth()),
                    SizedBox(width: 5),
                    Icon(Icons.calendar_month),
                  ],
                )
              ),
              const Tab(
                  child: Row(
                children: [
                  SizedBox(width: 35),
                  Text('Resumo'),
                  SizedBox(width: 5),
                  Icon(Icons.summarize),
                ],
              )),
            ],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                returnMesDisplay(context),
                returnResumoDisplay(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _getMonth() {
  DateTime now = DateTime.now();
  return '${_getMonthName(now.month)}';
}

String _getMonthName(int month) {
  switch (month) {
    case 1:
      return 'Janeiro';
    case 2:
      return 'Fevereiro';
    case 3:
      return 'Março';
    case 4:
      return 'Abril';
    case 5:
      return 'Maio';
    case 6:
      return 'Junho';
    case 7:
      return 'Julho';
    case 8:
      return 'Agosto';
    case 9:
      return 'Setembro';
    case 10:
      return 'Outubro';
    case 11:
      return 'Novembro';
    case 12:
      return 'Dezembro';
    default:
      return '';
  }
}


