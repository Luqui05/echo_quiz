import 'package:echo_quiz/models/Quiz.dart';
import 'package:echo_quiz/models/Usuario.dart';

class HistoricoJogo {
  final Usuario usuario;
  final Quiz quiz;
  final DateTime dataJogo;
  final int perguntasRespondidas;
  final int acertos;
  final int erros;
  final int pontosObtidos;

  HistoricoJogo({
    required this.usuario,
    required this.quiz,
    required this.dataJogo,
    required this.perguntasRespondidas,
    required this.acertos,
    required this.erros,
    required this.pontosObtidos,
  });
}
