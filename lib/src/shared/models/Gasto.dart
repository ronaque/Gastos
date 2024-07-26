import 'package:gastos/src/shared/models/Tag.dart';

/// Classe que representa um gasto
///   id: Identificador único do gasto
///   data: Data em que o gasto foi realizado
///   quantidade: Valor do gasto
///   tag: Tag associada ao gasto
///   descricao: Descrição do gasto
///   mode: Modo de pagamento (0 - a vista, 1 - parcelado, 2 - assinatura)
///   parcelas: Número de parcelas (caso o gasto seja parcelado)

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

