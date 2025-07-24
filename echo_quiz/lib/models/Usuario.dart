class Usuario {
  final int? id;
  final String nome;
  final String email;
  final String senha;
  final int pontuacaoTotal;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.pontuacaoTotal,
  });
}
