import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastos/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _salarioController = TextEditingController();
  TextEditingController _tagController = TextEditingController();
  File? _image;
  List<Widget> tags = [Icon(Icons.local_gas_station), Icon(Icons.restaurant), Icon(Icons.paid)];
  List<String> newTags = [];

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
    print('salario: $value');
    saveSalario(value);
  }

  Future _selecionarImagem() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) {
      return;
    }

    setState(() {
      _image = File(file.path);
    });
    return null;
  }

  Future<void> saveSalario(String salario) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('salario', double.parse(_salarioController.text));
    double? salarioSalvo = prefs.getDouble('salario');
    print('salario salvo: $salarioSalvo');
  }

  Widget getDefaultTagsWidgets(){
    List<Widget> tagWidgets = [];
    for (var tag in tags) {
      final padding = Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: tag
      );
      tagWidgets.add(padding);
    }
    return Row(children: tagWidgets);
  }

  Widget getNewTagsWidgets(){
    List<Widget> tagWidgets = [];
    for (var tag in newTags) {
      final padding = Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            tag.substring(0, 1).toUpperCase() + tag.substring(1),
            style: TextStyle(fontSize: 16), // Ajuste o tamanho da fonte conforme desejado
          ),
        ),
      );
      tagWidgets.add(padding);
      print("tag $tag");
    }
    return Row(children: tagWidgets);
  }

  void adicionarTag(String newTag){
    setState(() {
      newTags.add(newTag);
    });
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
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Stack(children: <Widget>[
                        _image != null ? profileAvatar() : defaultAvatar(),
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
                                border: OutlineInputBorder()),
                          )),
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
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
                                  border: OutlineInputBorder(),
                                  prefixStyle: TextStyle(color: Colors.black),
                                  prefixText: "R\$ "))),
                    ],
                  )),
              const Padding(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Tags"),
                    ],
                  )
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      getDefaultTagsWidgets(),
                    ],
                  )
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                          onPressed: () {
                            _displayDialog(context);
                          },
                          child: const Icon(Icons.add, color: Color(0xff0D47A1))
                      ),
                      getNewTagsWidgets(),
                    ],
                  )
              ),
            ],
          ),
        ));
  }

  _displayDialog(BuildContext context) async {
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
            decoration: const InputDecoration(hintText: 'Digite a nova tag'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () {
                if (_tagController.text.isNotEmpty) {
                  setState(() {
                    newTags.add( _tagController.text);
                  });
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
    return CircleAvatar(
        radius: 64, backgroundImage: FileImage(_image!));
  }

}
