import 'package:echo_quiz/models/Alternativa.dart';

class Pergunta {
  final String texto;
  String? dica;
  final List<Alternativa> alternativas;
  final int indiceAlternativaCorreta;

  Pergunta({
    required this.texto,
    required this.alternativas,
    required this.indiceAlternativaCorreta,
  });
}
