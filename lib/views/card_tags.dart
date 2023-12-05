import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastos/Model/Tag.dart';
import 'package:gastos/ModelHelper/DatabaseHelper.dart';

class CardTags extends StatefulWidget{
  final void Function(String category) setClicado;
  final String Function() getClicado;

  const CardTags(this.setClicado, this.getClicado);

  @override
  State<CardTags> createState() => _CardTagsState();
}

class _CardTagsState extends State<CardTags>{
  DatabaseHelper databaseHelper = DatabaseHelper();

  getClicadoBoxColor(String tag) {
    if (widget.getClicado() == tag) {
      return Colors.blue;
    } else {
      return Colors.white;
    }
  }

  getClicadoTextColor(String tag) {
    if (widget.getClicado() == tag) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  Future<Widget> getDBTagsTexts() async {
    List<Tag> dbTags = await databaseHelper.getAllTags();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(dbTags.length, (index) {
          final tag = dbTags[index];
          return GestureDetector(
            onTap: (){
              widget.setClicado(tag.name ?? '');
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.width * 0.12,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: getClicadoBoxColor(tag.name!),
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                  ),
                child: Text(
                    tag.name!.substring(0, 1).toUpperCase() + tag.name!.substring(1),
                    style: TextStyle(
                        fontSize: 16,
                        color: getClicadoTextColor(tag.name!),
                    ),
                ),
              ),
            )
          );
        }),
      ),
    );
  }

  Widget getDBTags() {
    return FutureBuilder(
      future: getDBTagsTexts(),
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
    return Padding(padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.width * 0.05, 0, 0),
        child: getDBTags());
  }
}