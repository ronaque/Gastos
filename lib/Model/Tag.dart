class Tag {
  int? id; // Pode ser usado como chave primária no banco de dados
  String? name;

  Tag({this.id, this.name});

  // Converte um objeto Tag em um Map para persistir no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Construtor que converte um Map em um objeto Tag
  Tag.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
  }
}
