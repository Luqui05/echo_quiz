import 'package:echo_quiz/config/Conexao.dart';
import 'package:echo_quiz/models/Usuario.dart';

class UsuarioDao {
  static get inserirUsuario => [
    "INSERT INTO usuario (nome, email, senha, pontuacaoTotal) VALUES ('Usuário Teste', 'teste@echoquiz.com', '123456', 0);",
  ];

  final String sqlInsert =
      'INSERT INTO usuario (nome, email, senha, pontuacaoTotal) VALUES (?, ?, ?, ?)';
  final String sqlUpdate =
      'UPDATE usuario SET nome = ?, email = ?, senha = ?, pontuacaoTotal = ? WHERE id = ?';
  final String sqlSelectAll = 'SELECT * FROM usuario';
  final String sqlSelectById = 'SELECT * FROM usuario WHERE id = ?';
  final String sqlSelectByEmailSenha =
      'SELECT * FROM usuario WHERE email = ? AND senha = ?';
  final String sqlDelete = 'DELETE FROM usuario WHERE id = ?';

  Future<int> salvar(Usuario usuario, {int? id}) async {
    final db = await Conexao.get();
    if (id == null) {
      return await db.rawInsert(sqlInsert, [
        usuario.nome,
        usuario.email,
        usuario.senha,
        usuario.pontuacaoTotal,
      ]);
    } else {
      return await db.rawUpdate(sqlUpdate, [
        usuario.nome,
        usuario.email,
        usuario.senha,
        usuario.pontuacaoTotal,
        id,
      ]);
    }
  }

  Future<List<Usuario>> consultarTodos() async {
    final db = await Conexao.get();
    final result = await db.rawQuery(sqlSelectAll);
    return result.map((e) => _fromMap(e)).toList();
  }

  Future<Usuario?> consultarPorId(int id) async {
    final db = await Conexao.get();
    final result = await db.rawQuery(sqlSelectById, [id]);
    if (result.isNotEmpty) return _fromMap(result.first);
    return null;
  }

  Future<Usuario?> consultarPorEmailSenha(String email, String senha) async {
    final db = await Conexao.get();
    final result = await db.rawQuery(sqlSelectByEmailSenha, [email, senha]);
    if (result.isNotEmpty) {
      return _fromMap(result.first);
    }
    return null;
  }

  Future<int> excluir(int id) async {
    final db = await Conexao.get();
    return await db.rawDelete(sqlDelete, [id]);
  }

  Usuario _fromMap(Map<String, dynamic> map) {
    return Usuario(
      nome: map['nome'],
      email: map['email'],
      senha: map['senha'],
      pontuacaoTotal: map['pontuacaoTotal'],
    );
  }

  Map<String, dynamic> _toMap(Usuario usuario) {
    return {
      'nome': usuario.nome,
      'email': usuario.email,
      'senha': usuario.senha,
      'pontuacaoTotal': usuario.pontuacaoTotal,
    };
  }
}
