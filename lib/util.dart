import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TagListScreen(),
    );
  }
}

class TagListScreen extends StatefulWidget {
  @override
  _TagListScreenState createState() => _TagListScreenState();
}

class _TagListScreenState extends State<TagListScreen> {
  List<String> tags = ['Tag 1', 'Tag 2', 'Tag 3']; // Sua lista de tags

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tags'),
      ),
      body: ListView.builder(
        itemCount: tags.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tags[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _displayDialog(BuildContext context) async {
    String? newTag = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Tag'),
          content: TextField(
            onChanged: (value) {
              // Você pode adicionar validações ou manipular o valor conforme necessário
            },
            decoration: InputDecoration(hintText: 'Digite a nova tag'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Adicionar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    if (newTag != null) {
      setState(() {
        tags.add(newTag);
      });
    }
  }
}
