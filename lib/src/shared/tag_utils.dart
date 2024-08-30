import 'package:gastos/src/shared/models/Tag.dart';
import 'package:gastos/src/shared/repositories/TagHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Tag> createTag(String nome) async {
  final prefs = await SharedPreferences.getInstance();
  int? id = prefs.getInt('tag_id');
  if (id == null) {
    id = 0;
  } else {
    id++;
  }
  prefs.setInt('tag_id', id);
  return Tag(id: id, nome: nome);
}

Future<void> insertTag(Tag tag) async {
  TagHelper tagHelper = TagHelper();
  tagHelper.insertTag(tag);
}

Future<List<Tag>> getAllTags() async {
  TagHelper tagHelper = TagHelper();
  return tagHelper.getAllTags();
}

Future<List<Tag>> getCustomTags() async {
  TagHelper tagHelper = TagHelper();
  return tagHelper.getCustomTags();
}

Future<Tag?> getTagByNome(String nome) async {
  TagHelper tagHelper = TagHelper();
  return tagHelper.getTagByNome(nome);
}

Future<Tag?> getTagById(int tagId) async {
  TagHelper tagHelper = TagHelper();
  return tagHelper.getTagById(tagId);
}

Future<void> deleteTagByName(String nome) async {
  TagHelper tagHelper = TagHelper();
  tagHelper.deleteTagByName(nome);
}
