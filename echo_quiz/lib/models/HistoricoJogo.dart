class HistoricoJogo {
  final int id;
  final int idUsuario;
  final int idQuiz;
  final DateTime dataJogo;
  final int perguntasRespondidas;
  final int acertos;
  final int erros;
  final int pontosObtidos;

  HistoricoJogo({
    required this.id,
    required this.idUsuario,
    required this.idQuiz,
    required this.dataJogo,
    required this.perguntasRespondidas,
    required this.acertos,
    required this.erros,
    required this.pontosObtidos,
  });
}
