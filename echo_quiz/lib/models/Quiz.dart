import 'package:echo_quiz/models/Pergunta.dart';

class Quiz {
  final int? id;
  final String titulo;
  final List<Pergunta> perguntas;

  Quiz({
    this.id,
    required this.titulo,
    required this.perguntas,
  });
}
