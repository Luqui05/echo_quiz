import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:echo_quiz/config/firebase/FirebaseConfig.dart';
import 'package:echo_quiz/dao/UsuarioDAO.dart';
import 'package:echo_quiz/dao/HistoricoJogoDAO.dart';
import 'package:echo_quiz/dao/QuizDAO.dart';
import 'package:echo_quiz/models/Usuario.dart';
import 'package:echo_quiz/models/HistoricoJogo.dart';
import 'package:echo_quiz/models/Quiz.dart';
import 'package:echo_quiz/models/Sessao.dart';

class SincronizacaoService {
  static FirebaseFirestore? get _firestore => FirebaseConfig.firestore;
  
  // Verifica se Firebase está disponível
  static bool get isFirebaseAvailable => FirebaseConfig.isInitialized;
  
  // Verifica conectividade
  static Future<bool> temConexao() async {
    if (!isFirebaseAvailable) return false;
    
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
  
  // Sincronização do usuário
  static Future<void> sincronizarUsuario(Usuario usuario) async {
    if (!await temConexao() || _firestore == null) return;
    
    try {
      if (usuario.id != null) {
        await _firestore!.collection('usuarios').doc(usuario.id.toString()).set({
          'nome': usuario.nome,
          'email': usuario.email,
          'pontuacaoTotal': usuario.pontuacaoTotal,
          'ultimaAtualizacao': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Erro ao sincronizar usuário: $e');
    }
  }
  
  // Sincronização do histórico
  static Future<void> sincronizarHistorico(HistoricoJogo historico) async {
    if (!await temConexao() || _firestore == null) return;
    
    try {
      await _firestore!.collection('historicos').add({
        'idUsuario': historico.idUsuario,
        'idQuiz': historico.idQuiz,
        'dataJogo': Timestamp.fromDate(historico.dataJogo),
        'perguntasRespondidas': historico.perguntasRespondidas,
        'acertos': historico.acertos,
        'erros': historico.erros,
        'pontosObtidos': historico.pontosObtidos,
        'sincronizado': true,
      });
    } catch (e) {
      print('Erro ao sincronizar histórico: $e');
    }
  }
  
  // Baixar dados do Firebase
  static Future<void> baixarDadosUsuario(int idUsuario) async {
    if (!await temConexao() || _firestore == null) return;
    
    try {
      // Baixar dados do usuário
      final userDoc = await _firestore!.collection('usuarios').doc(idUsuario.toString()).get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        final usuario = Usuario(
          id: idUsuario,
          nome: data['nome'],
          email: data['email'],
          senha: Sessao.usuario?.senha ?? '',
          pontuacaoTotal: data['pontuacaoTotal'] ?? 0,
        );
        await UsuarioDao().salvar(usuario, id: idUsuario);
      }
      
      // Baixar históricos
      final historicosQuery = await _firestore!
          .collection('historicos')
          .where('idUsuario', isEqualTo: idUsuario)
          .get();
      
      for (final doc in historicosQuery.docs) {
        final data = doc.data();
        final historico = HistoricoJogo(
          id: 0,
          idUsuario: data['idUsuario'],
          idQuiz: data['idQuiz'],
          dataJogo: (data['dataJogo'] as Timestamp).toDate(),
          perguntasRespondidas: data['perguntasRespondidas'],
          acertos: data['acertos'],
          erros: data['erros'],
          pontosObtidos: data['pontosObtidos'],
        );
        
        // Verifica se já existe localmente antes de inserir
        final historicosLocais = await HistoricoJogoDAO().consultarPorUsuario(idUsuario);
        final jaExiste = historicosLocais.any((h) => 
          h.dataJogo == historico.dataJogo && 
          h.idQuiz == historico.idQuiz &&
          h.pontosObtidos == historico.pontosObtidos
        );
        
        if (!jaExiste) {
          await HistoricoJogoDAO().inserir(historico);
        }
      }
    } catch (e) {
      print('Erro ao baixar dados: $e');
    }
  }
  
  // Sincronização completa
  static Future<void> sincronizacaoCompleta() async {
    if (!await temConexao() || !Sessao.usuarioLogado || Sessao.usuario == null) return;
    
    try {
      final usuario = Sessao.usuario!;
      
      // Upload dos dados locais
      await sincronizarUsuario(usuario);
      
      final historicos = await HistoricoJogoDAO().consultarPorUsuario(usuario.id!);
      for (final historico in historicos) {
        await sincronizarHistorico(historico);
      }
      
      // Download de dados remotos
      await baixarDadosUsuario(usuario.id!);
      
    } catch (e) {
      print('Erro na sincronização completa: $e');
    }
  }
}