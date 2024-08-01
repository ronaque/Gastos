import 'package:flutter/material.dart';
import 'package:gastos/globals.dart';
import 'package:gastos/src/shared/models/Tag.dart';
import 'package:gastos/src/shared/repositories/TagHelper.dart';

class CardTags extends StatefulWidget {
  final void Function(String category) setClicado;
  final String Function() getClicado;

  const CardTags(this.setClicado, this.getClicado, {super.key});

  @override
  State<CardTags> createState() => _CardTagsState();
}

class _CardTagsState extends State<CardTags> {
  TagHelper tagHelper = TagHelper();

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
    List<Tag>? dbTags = await tagHelper.getCustomTags();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(dbTags!.length, (index) {
          final tag = dbTags[index];
          return GestureDetector(
              onTap: () {
                widget.setClicado(tag.nome);
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.width * 0.12,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: getClicadoBoxColor(tag.nome),
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tag.nome.substring(0, 1).toUpperCase() +
                        tag.nome.substring(1),
                    style: TextStyle(
                      fontSize: 16,
                      color: getClicadoTextColor(tag.nome),
                    ),
                  ),
                ),
              ));
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

  getGasolinaIconColor() {
    if (widget.getClicado() == 'gasolina') {
      return const Icon(
        Icons.local_gas_station,
        color: Colors.white,
      );
    } else {
      return const Icon(Icons.local_gas_station);
    }
  }

  getComidaIconColor() {
    if (widget.getClicado() == 'comida') {
      return const Icon(
        Icons.restaurant,
        color: Colors.white,
      );
    } else {
      return const Icon(Icons.restaurant);
    }
  }

  getGastoIconColor() {
    if (widget.getClicado() == 'gasto') {
      return const Icon(
        Icons.paid,
        color: Colors.white,
      );
    } else {
      return const Icon(Icons.paid);
    }
  }

  getClicadoIcon(String tag) {
    if (widget.getClicado() == tag) {
      return Icon(tagsPadroes[tag], color: Colors.white);
    } else {
      return Icon(tagsPadroes[tag]);
    }
  }

  Widget getDefaultTags() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final tagName = tagsPadroes.keys.toList()[index];
        return GestureDetector(
            onTap: () {
              widget.setClicado(tagName);
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.width * 0.12,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: getClicadoBoxColor(tagName),
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: getClicadoIcon(tagName),
              ),
            ));
      }),
    );
  }

  Widget getTags() {
    return Column(
      children: [getDefaultTags(), const SizedBox(height: 16.0), getDBTags()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0), child: getTags());
  }
}
