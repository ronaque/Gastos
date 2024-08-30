import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gastos/src/shared/models/Tag.dart';
import 'package:gastos/src/shared/imageUtils.dart';
import 'package:gastos/src/shared/tag_utils.dart';
import 'package:gastos/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'components/new_tag_dialog.dart';
import 'perfil_module.dart';

int globalIndex = 0;

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final TextEditingController _tagController = TextEditingController();
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

  Future<void> _selectImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) {
      return;
    }

    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    globalIndex++;

    await file.saveTo('$appDocumentsPath/minha_imagem$globalIndex.jpg');
    print(
        "Arquivo salvo no path: $appDocumentsPath/minha_imagem$globalIndex.jpg");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'test_image', '$appDocumentsPath/minha_imagem$globalIndex.jpg');

    _imageFile = File(file.path);
    setState(() {
      image = Image.file(_imageFile!);
    });
    return;
  }

  /// Create a Row with the user's custom tags text fields
  Future<Widget> _getCustomTagsTexts(context) async {
    List<Tag> dbTags = await getCustomTags();

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
                    tag.nome.substring(0, 1).toUpperCase() +
                        tag.nome.substring(1),
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    onPressed: () {
                      deleteTagByName(tag.nome);
                      setState(() {});
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  /// Await the custom tags from the database
  Widget _getCustomTags(context) {
    return FutureBuilder(
      future: _getCustomTagsTexts(context),
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
                      padding: EdgeInsets.fromLTRB(
                          0, MediaQuery.of(context).size.width * 0.08, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Stack(children: <Widget>[
                            image != null
                                ? profileAvatar(image, context)
                                : defaultAvatar(context),
                            Positioned(
                              bottom: -10,
                              left: 80,
                              child: IconButton(
                                  onPressed: _selectImage,
                                  icon: const Icon(Icons.add_a_photo)),
                            )
                          ])
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, MediaQuery.of(context).size.width * 0.08, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text("Nome:"),
                          SizedBox(width: 250, child: buildNameTextField()),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, MediaQuery.of(context).size.width * 0.08, 0, 0),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Tags"),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, MediaQuery.of(context).size.width * 0.08, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          getDefaultTagsWidgets(),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, MediaQuery.of(context).size.width * 0.08, 0, 0),
                      child: _getCustomTags(context)),
                  Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, MediaQuery.of(context).size.width * 0.08, 0, 0),
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
                              child:
                                  const Icon(Icons.add, color: Colors.white)),
                        ],
                      )),
                ],
              ),
            )));
  }
}
