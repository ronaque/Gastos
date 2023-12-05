import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Image?> loadImage(var _imageFile, var image) async {
  try {
    print('loadImage');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? testeImage = prefs.getString('test_image');
    if (testeImage == null) {
      print('testeImage null');
      return null;
    } else {
      String filePath = '$testeImage';
      print('testeImage: $testeImage');
      _imageFile = File(filePath);
      return Image.file(_imageFile!);
    }
  } catch (e) {
    print('Erro ao carregar a imagem: $e');
    return null;
  }
}