import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastos/src/shared/models/Tag.dart';
import 'package:gastos/src/shared/repositories/DatabaseHelper.dart';
import 'package:gastos/src/shared/repositories/TagHelper.dart';

void adicionarTag(String newTagName) {
  TagHelper tagHelper = TagHelper();
  Tag newTag = Tag(newTagName);
  tagHelper.insertTag(newTag);
}

displayNewTagDialog(BuildContext context, _tagController) async {
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
          decoration:
          const InputDecoration(hintText: 'Digite o nome da nova tag'),
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