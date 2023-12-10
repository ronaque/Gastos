import 'package:gastos/src/shared/models/Tag.dart';

class Gasto {
  int? id; // Pode ser usado como chave primária no banco de dados
  DateTime? data;
  double? quantidade;
  Tag? tag;

  Gasto(this.id, this.data, this.quantidade, this.tag);

  // Converte um objeto Gasto em um Map para persistir no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data?.toIso8601String(),
      'quantidade': quantidade,
      'tag_id': tag?.id, // Salva o ID da tag associada
    };
  }

  // Construtor que converte um Map em um objeto Gasto
  Gasto.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    data = DateTime.parse(map['data']);
    quantidade = map['quantidade'];
    tag = Tag.fromMap({'id': map['tag_id'], 'nome': map['tag_nome']});
  }
}

