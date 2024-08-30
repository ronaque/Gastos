/// Class representing a tag
/// id: Unique identifier of the tag
/// nome: Name of the tag

class Tag {
  int id; // Pode ser usado como chave primária no banco de dados
  String nome;

  Tag({required this.id, required this.nome});

  // Converts a Tag object into a Map to persist in the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
    };
  }

  // Constructor that converts a Map into a Tag object
  Tag.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? 0,
        nome = map['nome'];

  @override
  String toString() {
    return 'Tag{id: $id, nome: $nome}';
  }
}
