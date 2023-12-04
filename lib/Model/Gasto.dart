import 'package:gastos/Model/Tag.dart';

class Gasto {
  int? id; // Pode ser usado como chave primária no banco de dados
  DateTime? date;
  int? quantity;
  Tag? tag;

  Gasto({this.id, this.date, this.quantity, this.tag});

  // Converte um objeto Gasto em um Map para persistir no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'quantity': quantity,
      'tag_id': tag?.id, // Salva o ID da tag associada
    };
  }

  // Construtor que converte um Map em um objeto Gasto
  Gasto.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    date = DateTime.parse(map['date']);
    quantity = map['quantity'];
    tag = Tag.fromMap({'id': map['tag_id'], 'name': map['tag_name']});
  }
}
