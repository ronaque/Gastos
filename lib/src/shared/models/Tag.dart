class Tag {
  int? id; // Pode ser usado como chave primária no banco de dados
  String? nome;

  Tag(this.id, this.nome);

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

