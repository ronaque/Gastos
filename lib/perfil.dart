import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastos/theme.dart';
import 'package:image_picker/image_picker.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _salarioController = TextEditingController();
  File? _image;
  List<Widget> tags = [Icon(Icons.local_gas_station), Icon(Icons.restaurant), Icon(Icons.paid)];

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

  Widget getTagsWidgets(){
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
                      getTagsWidgets(),
                    ],
                  )
              ),
            ],
          ),
        ));
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
