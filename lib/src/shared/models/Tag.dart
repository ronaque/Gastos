int tag_id = 0;

class Tag {
  int? id; // Pode ser usado como chave primária no banco de dados
  String? nome;

  Tag(this.nome) : this.id = tag_id++;

  // Converte um objeto Tag em um Map para persistir no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
    };
  }

  // Construtor que converte um Map em um objeto Tag
  Tag.fromMap(Map<String, dynamic> map) {
    id = map['id'] ?? 0;
    nome = map['nome'];
  }
}
