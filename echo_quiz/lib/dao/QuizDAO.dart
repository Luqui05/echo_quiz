import 'package:echo_quiz/config/Conexao.dart';
import 'package:echo_quiz/dao/PerguntaDAO.dart';
import 'package:echo_quiz/models/Quiz.dart';
import 'package:echo_quiz/models/Pergunta.dart';

class QuizDAO {
  final String sqlInsertQuiz = 'INSERT INTO quiz (titulo) VALUES (?)';
  final String sqlInsertQuizPergunta = 'INSERT INTO quiz_pergunta (idQuiz, idPergunta) VALUES (?, ?)';
  final String sqlSelectAll = '''
    SELECT DISTINCT q.id, q.titulo 
    FROM quiz q
  ''';
  final String sqlSelectPerguntas = '''
    SELECT p.id, p.texto, p.alternativas, p.indiceAlternativaCorreta
    FROM pergunta p
    INNER JOIN quiz_pergunta qp ON p.id = qp.idPergunta
    WHERE qp.idQuiz = ?
  ''';

  Future<int> salvar(Quiz quiz) async {
    final db = await Conexao.get();
    
    final quizId = await db.rawInsert(sqlInsertQuiz, [quiz.titulo]);
    
    for (final pergunta in quiz.perguntas) {
      if (pergunta.id != null) {
        await db.rawInsert(sqlInsertQuizPergunta, [quizId, pergunta.id]);
      }
    }
    
    return quizId;
  }

  Future<List<Quiz>> consultarTodos() async {
    final db = await Conexao.get();
    final result = await db.rawQuery(sqlSelectAll);
    
    List<Quiz> quizzes = [];
    for (final row in result) {
      final perguntas = await _consultarPerguntasDoQuiz(row['id'] as int);
      quizzes.add(Quiz(
        id: row['id'] as int,
        titulo: row['titulo'] as String,
        perguntas: perguntas,
      ));
    }
    
    return quizzes;
  }

  Future<List<Pergunta>> _consultarPerguntasDoQuiz(int quizId) async {
    final db = await Conexao.get();
    final result = await db.rawQuery(sqlSelectPerguntas, [quizId]);
    
    return result.map((row) => PerguntaDAO().fromMapPublic(row)).toList();
  }
}
