import 'package:echo_quiz/dao/UsuarioDAO.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class Conexao {
  static Database? _db;

  static get criarTabelas => [
    """
    CREATE TABLE usuario (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      senha TEXT NOT NULL,
      pontuacaoTotal INTEGER NOT NULL DEFAULT 0
    );
  """,
  ];

  static Future<Database> get() async {
    if (_db != null) return _db!;
    try {
      if (identical(0, 0.0)) {
        databaseFactory = databaseFactoryFfiWeb;
      }
      var path = join(await getDatabasesPath(), 'echo_quiz.db');
      await deleteDatabase(path);
      _db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          for (var sql in criarTabelas) {
            await db.execute(sql);
          }
          for (var sql in UsuarioDao.inserirUsuario) {
            await db.execute(sql);
          }
        },
      );
      return _db!;
    } catch (e) {
      rethrow;
    }
  }
}
