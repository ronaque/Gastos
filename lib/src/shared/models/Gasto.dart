import 'package:gastos/src/shared/models/Tag.dart';

/// Class representing an expense
/// id: Unique identifier of the expense
/// data: Date on which the expense was incurred
/// quantidade: Amount spent
/// tag: Tag associated with the expense
/// descricao: Description of the expense
/// mode: Payment method (0 - cash, 1 - installment, 2 - subscription)
/// parcelas: Number of installments (if the expense is paid in installments)

class Gasto {
  int id;
  DateTime data;
  double quantidade;
  Tag tag;
  String? descricao;
  int mode;
  int? parcelas;

  Gasto({
    required this.id,
    required this.data,
    required this.quantidade,
    required this.tag,
    this.descricao,
    required this.mode,
    this.parcelas,
  });

  // Converte um objeto Gasto em um Map para persistir no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data.toIso8601String(),
      'quantidade': quantidade,
      'tag_id': tag.id, // Salva o ID da tag associada
      'descricao': descricao,
      'mode': mode,
      'parcelas': parcelas
    };
  }

  // Construtor que converte um Map em um objeto Gasto
  Gasto.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        data = DateTime.parse(map['data']),
        quantidade = map['quantidade'],
        tag = Tag.fromMap({'id': map['tag_id'], 'nome': map['tag_nome']}),
        descricao = map['descricao'], // Agora pode ser nulo
        mode = map['mode'],
        parcelas = map['parcelas'];

  @override
  String toString() {
    return 'Gasto{id: $id, data: $data, quantidade: $quantidade, tag: ${tag.toString()}, descricao: $descricao, mode: $mode, parcelas: $parcelas}';
  }
}
