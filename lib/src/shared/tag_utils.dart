import 'package:gastos/src/shared/models/Tag.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Tag> novaTag(String nome) async {
  final prefs = await SharedPreferences.getInstance();
  int? id = prefs.getInt('tag_id');
  if (id == null) {
    id = 0;
  } else {
    id++;
  }
  prefs.setInt('tag_id', id);
  return Tag(id, nome);
}