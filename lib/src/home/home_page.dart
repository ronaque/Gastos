import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gastos/src/mes/mes_page.dart';
import 'package:gastos/src/perfil/perfil_page.dart';
import 'package:gastos/src/resumo/resumo_page.dart';
import 'package:gastos/src/shared/imageUtils.dart';
import 'home_module.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  File? _imageFile;
  Image? image;
  late TabController _tabController;
  Widget mes = Mes();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var resultImage = await loadImage(_imageFile, image);
      setState(() {
        image = resultImage;
      });
    });
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _abrirPerfil() async {
    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const Perfil()));

    if (result != null) {
      var resultImage = await loadImage(_imageFile, image);
      setState(() {
        image = resultImage;
        mes = Mes();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(
              Icons.attach_money,
              color: Colors.white,
            ),
            SizedBox(
                width: 8.0), // Adicione algum espaço entre o ícone e o texto
            Text(
              'MobiFin',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: image != null ? profileAvatar(image, context) : defaultAvatar(context),
            onPressed: _abrirPerfil,
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                  child: Row(
                    children: [
                      const SizedBox(width: 35),
                      Text(getMonth()),
                      const SizedBox(width: 5),
                      const Icon(Icons.calendar_month),
                    ],
                  )
              ),
              const Tab(
                  child: Row(
                    children: [
                      SizedBox(width: 35),
                      Text('Resumo'),
                      SizedBox(width: 5),
                      Icon(Icons.summarize),
                    ],
                  )),
            ],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                mes,
                Resumo(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}