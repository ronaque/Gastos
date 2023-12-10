import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastos/src/shared/models/Tag.dart';
import 'package:gastos/src/shared/repositories/DatabaseHelper.dart';
import 'package:gastos/src/shared/imageUtils.dart';
import 'package:gastos/src/shared/repositories/TagHelper.dart';
import 'package:gastos/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'components/new_tag_dialog.dart';
import 'components/change_pin_dialog.dart';
import 'perfil_module.dart';

int globalIndex = 0;

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  TextEditingController _tagController = TextEditingController();
  TextEditingController _pinController = TextEditingController();
  File? _imageFile;
  Image? image;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var resultImage = await loadImage(_imageFile, image);
      setState(() {
        image = resultImage;
      });
    });
    super.initState();
  }

  Future<void> _selecionarImagem() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) {
      return;
    }

    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    globalIndex++;

    await file.saveTo('$appDocumentsPath/minha_imagem$globalIndex.jpg');
    print("Arquivo salvo no path: $appDocumentsPath/minha_imagem$globalIndex.jpg");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('test_image', '$appDocumentsPath/minha_imagem$globalIndex.jpg');

    _imageFile = File(file.path);
    setState(() {
      image = Image.file(_imageFile!);
    });
    return;
  }

  Future<Widget> getDBTagsTexts(context) async {
    TagHelper tagHelper = TagHelper();
    List<Tag> dbTags = await tagHelper.getAllTags();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(dbTags.length, (index) {
          final tag = dbTags[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              height: MediaQuery.of(context).size.width * 0.12,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    tag.nome!.substring(0, 1).toUpperCase() +
                        tag.nome!.substring(1),
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    onPressed: () {
                      tagHelper.deleteTagByName(tag.nome!);
                      setState(() {});
                    },
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget getDBTags(context) {
    return FutureBuilder(
      future: getDBTagsTexts(context),
      builder: (context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return const Text(
            'Erro ao carregar as tags',
            style: TextStyle(color: Colors.black),
          );
        }
      },
    );
  }

  void _sair() {
    Navigator.pushReplacementNamed(context, '/login');
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
          body: WillPopScope(
            onWillPop: () async {
              Navigator.pop(context, "updateImage");
              return true;
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.width * 0.05, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Stack(children: <Widget>[
                          image != null ? profileAvatar(image, context) : defaultAvatar(context),
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
                    padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.width * 0.05, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Nome:"),
                        SizedBox(width: 250, child: getNomeTextField()),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.width * 0.05, 0, 0),
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
                Padding(
                    padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.width * 0.05, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Tags"),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.width * 0.05, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        getDefaultTagsWidgets(),
                      ],
                    )
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.width * 0.05, 0, 0),
                    child: getDBTags(context)
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.width * 0.05, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                displayNewTagDialog(context, _tagController);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              elevation: 5,
                            ),
                            child: const Icon(Icons.add, color: Colors.white)),
                      ],
                    )
                ),
                ElevatedButton(
                  onPressed: () {
                    displayChangePinDialog(context, _pinController);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    backgroundColor: Colors.blue,
                    elevation: 5,
                  ),
                  child: Text('Alterar PIN', style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _sair();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    elevation: 5,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.logout, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ));
  }

}
