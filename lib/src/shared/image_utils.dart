import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Image?> loadImage(var imageFile, var image) async {
  try {
    print('loadImage');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? testeImage = prefs.getString('test_image');
    if (testeImage == null) {
      print('testeImage null');
      return null;
    } else {
      String filePath = testeImage;
      print('testeImage: $testeImage');
      imageFile = File(filePath);
      return Image.file(imageFile!);
    }
  } catch (e) {
    print('Erro ao carregar a imagem: $e');
    return null;
  }
}

CircleAvatar defaultAvatar(context) {
  return CircleAvatar(
      radius: MediaQuery.of(context).size.width * 0.18, backgroundImage: const AssetImage("images/user.png"));
}

CircleAvatar profileAvatar(Image? image, context) {
  if (image == null) {
    return CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.18, backgroundImage: const AssetImage("images/user.png"));
  }
  return CircleAvatar(radius: MediaQuery.of(context).size.width * 0.18, backgroundImage: image.image);
}