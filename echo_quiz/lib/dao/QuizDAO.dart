import 'package:echo_quiz/config/Conexao.dart';
import 'package:echo_quiz/models/Quiz.dart';

class QuizDAO {
  final String sqlInsert =
      'INSERT INTO quiz (titulo, perguntasIds) VALUES (?, ?)';
  final String sqlSelectAll = 'SELECT * FROM quiz';
  final String sqlDelete = 'DELETE FROM quiz WHERE id = ?';

  Future<int> salvar(Quiz quiz) async {
    final db = await Conexao.get();
    final perguntasIds = quiz.perguntas.map((p) => p.hashCode).join(';');
    return await db.rawInsert(sqlInsert, [quiz.titulo, perguntasIds]);
  }

  Future<List<Quiz>> consultarTodos() async {
    final db = await Conexao.get();
    final result = await db.rawQuery(sqlSelectAll);
    return result.map((e) => _fromMap(e)).toList();
  }

  Quiz _fromMap(Map<String, dynamic> map) {
    return Quiz(
      id: map['id'],
      titulo: map['titulo'],
      perguntas: [], // Implementar busca das perguntas por IDs
    );
  }
}
