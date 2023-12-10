import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastos/src/shared/models/Tag.dart';
import 'package:gastos/src/shared/repositories/DatabaseHelper.dart';

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

  getGasolinaIconColor(){
    if(widget.getClicado() == 'gasolina'){
      return Icon(Icons.local_gas_station, color: Colors.white,);
    }else{
      return Icon(Icons.local_gas_station);
    }
  }
  getComidaIconColor(){
    if(widget.getClicado() == 'comida'){
      return Icon(Icons.restaurant, color: Colors.white,);
    }else{
      return Icon(Icons.restaurant);
    }
  }

  getGastoIconColor(){
    if(widget.getClicado() == 'gasto'){
      return Icon(Icons.paid, color: Colors.white,);
    }else{
      return Icon(Icons.paid);
    }
  }


  Widget getDefaultTags(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (){
          widget.setClicado('gasolina');
          setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.width * 0.12,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: getClicadoBoxColor('gasolina'),
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: getGasolinaIconColor(),
            ),
          )
        ),
        GestureDetector(
            onTap: (){
              widget.setClicado('comida');
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.width * 0.12,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: getClicadoBoxColor('comida'),
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: getComidaIconColor(),
              ),
            )
        ),
        GestureDetector(
            onTap: (){
              widget.setClicado('gasto');
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.width * 0.12,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: getClicadoBoxColor('gasto'),
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: getGastoIconColor(),
              ),
            )
        ),
      ],
    );
  }

  Widget getTags() {
    return Column(
      children: [
        getDefaultTags(),
        SizedBox(height: 16.0),
        getDBTags()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.width * 0.05, 0, 0),
        child: getTags());
  }
}