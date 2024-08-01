// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:gastos/src/shared/tag_utils.dart';

displayNewTagDialog(BuildContext context, tagController) async {
  String? newTag = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Adicionar Tag'),
        content: TextField(
          textCapitalization: TextCapitalization.sentences,
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
            onPressed: () async {
              if (tagController.text.isNotEmpty) {
                insertTag(await createTag(tagController.text));
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );

  tagController.clear();
}