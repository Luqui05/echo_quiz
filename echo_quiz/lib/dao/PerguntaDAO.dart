import 'dart:math';

import 'package:echo_quiz/config/Conexao.dart';
import 'package:echo_quiz/models/Alternativa.dart';
import 'package:echo_quiz/models/Pergunta.dart';

class PerguntaDAO {
  static get inserirPerguntas => [
    "INSERT INTO pergunta (texto, alternativas, indiceAlternativaCorreta) VALUES ('Qual banda gravou a música \"Bohemian Rhapsody\"?', 'Queen;The Beatles;Led Zeppelin;Pink Floyd', 0);",
    "INSERT INTO pergunta (texto, alternativas, indiceAlternativaCorreta) VALUES ('Em que década surgiu o movimento musical \"Grunge\"?', 'Anos 70;Anos 80;Anos 90;Anos 2000', 2);",
    "INSERT INTO pergunta (texto, alternativas, indiceAlternativaCorreta) VALUES ('Qual instrumento Michael Jackson tocava profissionalmente?', 'Piano;Guitarra;Bateria;Nenhum dos anteriores', 3);",
    "INSERT INTO pergunta (texto, alternativas, indiceAlternativaCorreta) VALUES ('Qual o nome do álbum mais vendido de todos os tempos?', 'Thriller;Abbey Road;The Dark Side of the Moon;Back in Black', 0);",
    "INSERT INTO pergunta (texto, alternativas, indiceAlternativaCorreta) VALUES ('Quantas cordas tem um violão tradicional?', '4;5;6;7', 2);",
  ];

  final String sqlInsert =
      'INSERT INTO pergunta (texto, alternativas, indiceAlternativaCorreta) VALUES (?, ?, ?)';
  final String sqlSelectAll = 'SELECT * FROM pergunta';
  final String sqlDelete = 'DELETE FROM pergunta WHERE id = ?';

  Future<int> salvar(Pergunta pergunta) async {
    final db = await Conexao.get();
    final alternativaStr = pergunta.alternativas.map((a) => a.texto).join(';');
    final id = await db.rawInsert(sqlInsert, [
      pergunta.texto,
      alternativaStr,
      pergunta.indiceAlternativaCorreta,
    ]);
    return id;
  }

  Future<List<Pergunta>> consultarTodos() async {
    final db = await Conexao.get();
    final result = await db.rawQuery(sqlSelectAll);
    return result.map((e) => _fromMap(e)).toList();
  }

  Future<int> excluir(int id) async {
    final db = await Conexao.get();
    return await db.rawDelete(sqlDelete, [id]);
  }

  Pergunta _fromMap(Map<String, dynamic> map) {
    final alternativas = (map['alternativas'] as String)
        .split(';')
        .map((t) => Alternativa(texto: t))
        .toList();
    return Pergunta(
      id: map['id'],
      texto: map['texto'],
      alternativas: alternativas,
      indiceAlternativaCorreta: map['indiceAlternativaCorreta'],
    );
  }

  Pergunta fromMapPublic(Map<String, dynamic> map) {
    return _fromMap(map);
  }
}
