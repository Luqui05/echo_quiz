import 'package:echo_quiz/models/Pergunta.dart';

class Quiz {
  final String titulo;
  final List<Pergunta> perguntas;

  Quiz({
    required this.titulo,
    required this.perguntas,
  });
}
