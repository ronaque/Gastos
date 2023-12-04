import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastos/Model/Tag.dart';
import 'package:gastos/ModelHelper/DatabaseHelper.dart';
import 'package:gastos/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  TextEditingController _tagController = TextEditingController();
  TextEditingController _pinController = TextEditingController();
  File? _imageFile;
  Image? image;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Widget> tags = [
    Icon(Icons.local_gas_station),
    Icon(Icons.restaurant),
    Icon(Icons.paid)
  ];
  // List<Tag> newTags = [];

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  void _nomeChange(String value) {
    if (value.isEmpty) {
      value = '';
    } else {
      value = value;
    }
    print('nome: $value');
    saveNome(value);
  }

  void _salarioChange(String value) {
    if (value.isEmpty) {
      value = '0';
    } else {
      value = value.replaceAll(RegExp(r'[R\$]'), '');
    }
    print('salario: $value');
    saveSalario(value);
  }

  _displayChangePinDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alterar PIN'),
          content: Container(
            height: 150, // Ajuste a altura conforme necessário
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
                    elevation: 5, // Adiciona sombra
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('pin', pin);
    print('PIN salvo: $pin');
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

  Future<void> _selecionarImagem() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) {
      return;
    }

    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;

    await file.saveTo('$appDocumentsPath/minha_imagem.jpg');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('test_image', '$appDocumentsPath/minha_imagem.jpg');

    _imageFile = File(file.path);
    setState(() {
      image = Image.file(_imageFile!);
    });
    return;
  }

  Future<void> saveSalario(String salario) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('salario', double.parse(salario));
    double? salarioSalvo = prefs.getDouble('salario');
    print('salario salvo: $salarioSalvo');
  }

  Future<void> saveNome(String nome) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('nome', nome);
    String? nomeSalvo = prefs.getString('nome');
    print('nome salvo: $nomeSalvo');
  }

  Future<String> getSalario() async {
    final prefs = await SharedPreferences.getInstance();
    double? salarioSalvo = prefs.getDouble('salario');
    print('salario salvo recuperado: $salarioSalvo');
    if (salarioSalvo == null) {
      return 'R\$0.0';
    }
    String salarioSalvoString = salarioSalvo.toString();
    return 'R\$$salarioSalvoString';
  }

  Future<String> getNome() async {
    final prefs = await SharedPreferences.getInstance();
    String? nomeSalvo = prefs.getString('nome');
    print('nome salvo recuperado: $nomeSalvo');
    if (nomeSalvo == null) {
      return 'Nome do Usuário';
    }
    return nomeSalvo;
  }

  Widget getSalarioTextField() {
    return FutureBuilder(
      future: getSalario(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return TextFormField(
            initialValue: snapshot.data,
            onChanged: (value) => _salarioChange(value),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(border: OutlineInputBorder()),
          );
        } else {
          return const Text(
            'Saldo: \$0.0',
            style: TextStyle(color: Colors.black),
          );
        }
      },
    );
  }

  Widget getNomeTextField() {
    return FutureBuilder(
      future: getNome(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return TextFormField(
            initialValue: snapshot.data,
            onChanged: (value) => _nomeChange(value),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(border: OutlineInputBorder()),
          );
        } else {
          return const Text(
            'Saldo: \$0.0',
            style: TextStyle(color: Colors.black),
          );
        }
      },
    );
  }

  Widget getDefaultTagsWidgets() {
    List<Widget> tagWidgets = [];
    for (var tag in tags) {
      final padding =
          Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: tag);
      tagWidgets.add(padding);
    }
    return Row(children: tagWidgets);
  }

  Future<Widget> getDBTagsTexts() async {
    List<Widget> tagWidgets = [];
    List<Tag> dbTags = await databaseHelper.getAllTags();
    for (var tag in dbTags) {
      final padding = Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            tag.name!.substring(0, 1).toUpperCase() + tag.name!.substring(1),
            style: TextStyle(
                fontSize: 16), // Ajuste o tamanho da fonte conforme desejado
          ),
        ),
      );
      tagWidgets.add(padding);
      print("tag $tag");
    }
    return Row(children: tagWidgets);
  }

  Widget getDBTags() {
    return FutureBuilder(
      future: getDBTagsTexts(),
      builder: (context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return const Text(
            'Saldo: \$0.0',
            style: TextStyle(color: Colors.black),
          );
        }
      },
    );
  }

  void adicionarTag(String newTagName) {
    Tag newTag = Tag(name: newTagName);
    databaseHelper.insertTag(newTag);
    // setState(() {
    //   newTags.add(newTag);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: AppTheme().getAppTheme(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                  child: Text("MobiFin"),
                )
              ],
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Stack(children: <Widget>[
                        image != null ? profileAvatar() : defaultAvatar(),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                              onPressed: _selecionarImagem,
                              icon: const Icon(Icons.add_a_photo)),
                        )
                      ])
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Nome:"),
                      SizedBox(width: 250, child: getNomeTextField()),
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Salário:"),
                      SizedBox(
                        width: 250,
                        child: getSalarioTextField(),
                      ),
                    ],
                  )),
              const Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Tags"),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      getDefaultTagsWidgets(),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                          onPressed: () {
                            _displayNewTagDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            elevation: 5, // Adiciona sombra
                          ),
                          child: const Icon(Icons.add, color: Colors.white)),
                      getDBTags(),
                    ],
                  )
              ),
              ElevatedButton(
                onPressed: () {
                  _displayChangePinDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  backgroundColor: Colors.blue,
                  elevation: 5, // Adiciona sombra
                ),
                child: Text('Alterar PIN', style: TextStyle(color: Colors.white),
                  ),
              ),
            ],
          ),
        ));
  }

  _displayNewTagDialog(BuildContext context) async {
    String? newTag = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Tag'),
          content: TextField(
            controller: _tagController,
            onChanged: (value) {
              // Você pode adicionar validações ou manipular o valor conforme necessário
            },
            decoration: const InputDecoration(hintText: 'Digite o nome da nova tag'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () {
                if (_tagController.text.isNotEmpty) {
                  adicionarTag(_tagController.text);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    print('sai do dialogo');
    print('newTag: $_tagController');
    _tagController.clear();
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
}
