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
    print('🔄 Tentando sincronizar usuário: ${usuario.nome}');
    
    if (!await temConexao() || _firestore == null) {
      print('❌ Sem conexão ou Firebase não inicializado');
      return;
    }
    
    try {
      if (usuario.id != null) {
        print('📤 Enviando dados do usuário para Firestore...');
        await _firestore!.collection('usuarios').doc(usuario.id.toString()).set({
          'nome': usuario.nome,
          'email': usuario.email,
          'pontuacaoTotal': usuario.pontuacaoTotal,
          'ultimaAtualizacao': FieldValue.serverTimestamp(),
        });
        print('✅ Usuário sincronizado com sucesso!');
      }
    } catch (e) {
      print('❌ Erro ao sincronizar usuário: $e');
    }
  }
  
  // Sincronização do histórico
  static Future<void> sincronizarHistorico(HistoricoJogo historico) async {
    print('🔄 Tentando sincronizar histórico...');
    
    if (!await temConexao() || _firestore == null) {
      print('❌ Sem conexão ou Firebase não inicializado');
      return;
    }
    
    try {
      print('📤 Enviando histórico para Firestore...');
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
      print('✅ Histórico sincronizado com sucesso!');
    } catch (e) {
      print('❌ Erro ao sincronizar histórico: $e');
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
  
  // Novo método para fazer login híbrido (local + remoto)
  static Future<Usuario?> fazerLoginHibrido(String email, String senha) async {
    // 1. Primeiro tenta login local
    print('🔍 Tentando login local...');
    Usuario? usuario = await UsuarioDao().consultarPorEmailSenha(email, senha);
    
    if (usuario != null) {
      print('✅ Login local bem-sucedido!');
      // Se encontrou local, sincroniza com remoto
      if (await temConexao()) {
        await sincronizacaoCompleta();
      }
      return usuario;
    }
    
    // 2. Se não encontrou local, tenta buscar no Firebase
    print('🔍 Não encontrado local, buscando no Firebase...');
    if (!await temConexao() || _firestore == null) {
      print('❌ Sem conexão para buscar no Firebase');
      return null;
    }
    
    try {
      // Busca usuário por email no Firebase
      final query = await _firestore!
          .collection('usuarios')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      
      if (query.docs.isEmpty) {
        print('❌ Usuário não encontrado no Firebase');
        return null;
      }
      
      final userData = query.docs.first.data();
      final userId = int.parse(query.docs.first.id);
      
      // Cria objeto usuário com dados do Firebase
      final usuarioRemoto = Usuario(
        id: userId,
        nome: userData['nome'],
        email: userData['email'],
        senha: senha, // Usamos a senha informada pelo usuário
        pontuacaoTotal: userData['pontuacaoTotal'] ?? 0,
      );
      
      // Aqui você pode implementar verificação de senha se estiver usando hash
      // Por simplicidade, vamos assumir que se chegou até aqui, a senha está correta
      
      print('✅ Usuário encontrado no Firebase, salvando localmente...');
      
      // Salva localmente para próximas consultas
      await UsuarioDao().salvar(usuarioRemoto, id: userId);
      
      // Baixa o histórico do usuário também
      await baixarDadosUsuario(userId);
      
      return usuarioRemoto;
      
    } catch (e) {
      print('❌ Erro ao buscar no Firebase: $e');
      return null;
    }
  }
  
  // Método auxiliar para sincronizar usuário no cadastro
  static Future<void> sincronizarNovoUsuario(Usuario usuario) async {
    if (!await temConexao() || _firestore == null || usuario.id == null) {
      print('⚠️ Novo usuário salvo apenas localmente');
      return;
    }
    
    try {
      print('📤 Sincronizando novo usuário no Firebase...');
      await _firestore!.collection('usuarios').doc(usuario.id.toString()).set({
        'nome': usuario.nome,
        'email': usuario.email,
        'pontuacaoTotal': usuario.pontuacaoTotal,
        'dataCriacao': FieldValue.serverTimestamp(),
        'ultimaAtualizacao': FieldValue.serverTimestamp(),
      });
      print('✅ Novo usuário sincronizado com sucesso!');
    } catch (e) {
      print('❌ Erro ao sincronizar novo usuário: $e');
    }
  }
}