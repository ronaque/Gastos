import 'package:flutter/material.dart';
import 'package:gastos/globals.dart';
import 'package:gastos/src/shared/models/Tag.dart';
import 'package:gastos/src/shared/tag_utils.dart';

class CardTags extends StatefulWidget {
  final void Function(String category) setSelected;
  final String Function() getSelected;

  const CardTags(this.setSelected, this.getSelected, {super.key});

  @override
  State<CardTags> createState() => _CardTagsState();
}

class _CardTagsState extends State<CardTags> {
  getSelectedBoxColor(String tag) {
    if (widget.getSelected() == tag) {
      return Colors.blue;
    } else {
      return Colors.white;
    }
  }

  getSelectedTextColor(String tag) {
    if (widget.getSelected() == tag) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  Future<Widget> _GetCustomTagsTexts() async {
    List<Tag>? dbTags = await getCustomTags();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(dbTags.length, (index) {
          final tag = dbTags[index];
          return GestureDetector(
              onTap: () {
                widget.setSelected(tag.nome);
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.width * 0.12,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: getSelectedBoxColor(tag.nome),
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tag.nome.substring(0, 1).toUpperCase() +
                        tag.nome.substring(1),
                    style: TextStyle(
                      fontSize: 16,
                      color: getSelectedTextColor(tag.nome),
                    ),
                  ),
                ),
              ));
        }),
      ),
    );
  }

  Widget _getCustomTags() {
    return FutureBuilder(
      future: _GetCustomTagsTexts(),
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

  _getSelectedIcon(String tag) {
    if (widget.getSelected() == tag) {
      return Icon(defaultTags[tag], color: Colors.white);
    } else {
      return Icon(defaultTags[tag]);
    }
  }

  Widget getDefaultTags() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final tagName = defaultTags.keys.toList()[index];
        return GestureDetector(
            onTap: () {
              widget.setSelected(tagName);
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.width * 0.12,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: getSelectedBoxColor(tagName),
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _getSelectedIcon(tagName),
              ),
            ));
      }),
    );
  }

  Widget getTags() {
    return Column(
      children: [
        getDefaultTags(),
        const SizedBox(height: 16.0),
        _getCustomTags()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0), child: getTags());
  }
}
