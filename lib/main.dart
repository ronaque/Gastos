import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastos/perfil.dart';
import 'package:gastos/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'resumo.dart';
import 'mes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ;
  //runApp(MaterialApp(home: Home(), theme: AppTheme().getAppTheme()));
  runApp(MaterialApp(home: MyApp(), theme: AppTheme().getAppTheme()));
  //runApp(MyApp());
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
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> loadImage() async {
    try {
      print('loadImage');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? testeImage = prefs.getString('test_image');
      if (testeImage == null) {
        print('testeImage null');
        return;
      } else {
        String filePath = '$testeImage';
        print('testeImage: $testeImage');
        _imageFile = File(filePath);
        setState(() {
          image = Image.file(_imageFile!);
        });
      }
    } catch (e) {
      print('Erro ao carregar a imagem: $e');
    }
  }

  void _abrirPerfil() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Perfil()))
        .then((value) => loadImage());
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

  Future<double> getSalario() async {
    final prefs = await SharedPreferences.getInstance();
    double? salarioSalvo = prefs.getDouble('salario');
    if (salarioSalvo == null) {
      return 0;
    }
    return salarioSalvo;
  }

  Widget getSaldoTexto() {
    return FutureBuilder(
      future: getSalario(),
      builder: (context, AsyncSnapshot<double> snapshot) {
        if (snapshot.hasData) {
          return Text(
            'Saldo: \$${snapshot.data}',
            style: TextStyle(color: Colors.white),
          );
        } else {
          return const Text(
            'Saldo: \$0.0',
            style: TextStyle(color: Colors.white),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
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
              Tab(text: 'Mês'),
              Tab(text: 'Resumo'),
            ],
            labelColor:
                Colors.black, // Cor do texto da aba ativa (Mês ou Resumo)
            unselectedLabelColor: Colors.grey, // Cor do texto das abas inativas
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Conteúdo da aba "Mês"
                //_buildMesContent(context),
                returnMesDisplay(context),

                // Conteúdo da aba "Resumo"
                returnResumoDisplay(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildMesContent(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MesScreen()),
          );
        },
        child: Text('Ir para Mês'),
      ),
    ],
  );
}

class LoginPage extends StatelessWidget {
  final TextEditingController pinController = TextEditingController();

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
              SizedBox(height: 20.0),
              Text(
                'MobiFin',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50.0),
              TextField(
                controller: pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'PIN (4 dígitos)',
                ),
              ),
              SizedBox(height: 50.0),
              ElevatedButton(
                onPressed: () {
                  authenticateUser(pinController.text, context);
                },
                child: Container(
                  width: double.infinity, // Largura máxima possível
                  child: Center(
                    child: Text('Entrar'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> authenticateUser(String enteredPin, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? savedPin = prefs.getString('pin');

    if (savedPin == null) {
      // Se a senha nunca foi alterada, aceitar a senha padrão "0000"
      if (enteredPin == '0000') {
        // Navegar para a tela principal
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        // Senha inválida
        showInvalidPinDialog(context);
      }
    } else {
      // Senha já foi alterada, verificar com a senha salva
      if (enteredPin == savedPin) {
        // Senha válida, navegar para a tela principal
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        // Senha inválida
        showInvalidPinDialog(context);
      }
    }
  }

  void showInvalidPinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro'),
          content: Text('PIN inválido. Tente novamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
