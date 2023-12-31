import 'package:flutter/material.dart';
import 'package:gastos/src/shared/models/Tag.dart';
import 'package:gastos/src/shared/repositories/TagHelper.dart';
import 'package:gastos/src/shared/tag_utils.dart';

void adicionarTag(String newTagName) async {
  TagHelper tagHelper = TagHelper();
  Tag newTag = await novaTag(newTagName);
  tagHelper.insertTag(newTag);
}

displayNewTagDialog(BuildContext context, tagController) async {
  String? newTag = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Adicionar Tag'),
        content: TextField(
          controller: tagController,
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
              if (tagController.text.isNotEmpty) {
                adicionarTag(tagController.text);
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );

  print('sai do dialogo');
  print('newTag: $tagController');
  tagController.clear();
}