import 'package:echo_quiz/config/Conexao.dart';
import 'package:echo_quiz/models/HistoricoJogo.dart';

class HistoricoJogoDAO {
  final String sqlInsert = '''
    INSERT INTO historicoJogo (idUsuario, idQuiz, dataJogo, perguntasRespondidas, acertos, erros, pontosObtidos) 
    VALUES (?, ?, ?, ?, ?, ?, ?)
  ''';
  
  final String sqlSelectAll = 'SELECT * FROM historicoJogo ORDER BY dataJogo DESC';
  final String sqlSelectByUsuario = 'SELECT * FROM historicoJogo WHERE idUsuario = ? ORDER BY dataJogo DESC';

  Future<int> inserir(HistoricoJogo historico) async {
    final db = await Conexao.get();
    return await db.rawInsert(sqlInsert, [
      historico.idUsuario,
      historico.idQuiz,
      historico.dataJogo.toIso8601String(),
      historico.perguntasRespondidas,
      historico.acertos,
      historico.erros,
      historico.pontosObtidos,
    ]);
  }

  Future<List<HistoricoJogo>> consultarTodos() async {
    final db = await Conexao.get();
    final result = await db.rawQuery(sqlSelectAll);
    return result.map((e) => _fromMap(e)).toList();
  }

  Future<List<HistoricoJogo>> consultarPorUsuario(int idUsuario) async {
    final db = await Conexao.get();
    final result = await db.rawQuery(sqlSelectByUsuario, [idUsuario]);
    return result.map((e) => _fromMap(e)).toList();
  }

  HistoricoJogo _fromMap(Map<String, dynamic> map) {
    return HistoricoJogo(
      id: map['id'],
      idUsuario: map['idUsuario'],
      idQuiz: map['idQuiz'],
      dataJogo: DateTime.parse(map['dataJogo']),
      perguntasRespondidas: map['perguntasRespondidas'],
      acertos: map['acertos'],
      erros: map['erros'],
      pontosObtidos: map['pontosObtidos'],
    );
  }
}