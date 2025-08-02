class Usuario {
  int? id;
  String nome;
  String email;
  String senha;
  int pontuacaoTotal; // Removido o 'final' para permitir alteração

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.pontuacaoTotal = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'senha': senha,
      'pontuacaoTotal': pontuacaoTotal,
    };
  }

  static Usuario fromMap(Map<String, dynamic> map, {int? id}) {
    return Usuario(
      id: id,
      nome: map['nome'],
      email: map['email'],
      senha: map['senha'],
      pontuacaoTotal: map['pontuacaoTotal'] ?? 0,
    );
  }
}
