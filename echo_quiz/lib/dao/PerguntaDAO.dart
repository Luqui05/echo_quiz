import 'dart:math';

import 'package:echo_quiz/config/Conexao.dart';
import 'package:echo_quiz/models/Alternativa.dart';
import 'package:echo_quiz/models/Pergunta.dart';

class PerguntaDAO {
  final String sqlInsert =
      'INSERT INTO pergunta (texto, alternativas, indiceAlternativaCorreta) VALUES (?, ?, ?)';
  final String sqlSelectAll = 'SELECT * FROM pergunta';
  final String sqlDelete = 'DELETE FROM pergunta WHERE id = ?';

  Future<int> salvar(Pergunta pergunta) async {
    final db = await Conexao.get();
    final alternativaStr = pergunta.alternativas.map((a) => a.texto).join(';');
    return await db.rawInsert(sqlInsert, [
      pergunta.texto,
      alternativaStr,
      pergunta.indiceAlternativaCorreta,
    ]);
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
      texto: map['texto'],
      alternativas: alternativas,
      indiceAlternativaCorreta: map['indiceAlternativaCorreta'],
    );
  }
}
