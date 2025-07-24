import 'package:echo_quiz/dao/HistoricoJogoDAO.dart';
import 'package:echo_quiz/models/HistoricoJogo.dart';

class EstatisticasService {
  static Future<Map<String, dynamic>> obterEstatisticasUsuario(int idUsuario) async {
    final historicos = await HistoricoJogoDAO().consultarPorUsuario(idUsuario);
    
    if (historicos.isEmpty) {
      return {
        'totalJogos': 0,
        'pontuacaoTotal': 0,
        'mediaAcertos': 0.0,
        'melhorDesempenho': 0.0,
        'jogosUltimos7Dias': <HistoricoJogo>[],
        'evolucaoPontuacao': <Map<String, dynamic>>[],
        'desempenhoPorQuiz': <Map<String, dynamic>>[],
      };
    }

    final totalJogos = historicos.length;
    final pontuacaoTotal = historicos.fold<int>(0, (sum, h) => sum + h.pontosObtidos);
    final totalPerguntas = historicos.fold<int>(0, (sum, h) => sum + h.perguntasRespondidas);
    final totalAcertos = historicos.fold<int>(0, (sum, h) => sum + h.acertos);
    final mediaAcertos = totalPerguntas > 0 ? (totalAcertos / totalPerguntas) * 100 : 0.0;
    
    final melhorJogo = historicos.reduce((a, b) => 
      (a.acertos / a.perguntasRespondidas) > (b.acertos / b.perguntasRespondidas) ? a : b);
    final melhorDesempenho = (melhorJogo.acertos / melhorJogo.perguntasRespondidas) * 100;

    final agora = DateTime.now();
    final seteDiasAtras = agora.subtract(const Duration(days: 7));
    final jogosUltimos7Dias = historicos.where((h) => h.dataJogo.isAfter(seteDiasAtras)).toList();

    final evolucaoPontuacao = _calcularEvolucaoPontuacao(historicos);
    final desempenhoPorQuiz = _calcularDesempenhoPorQuiz(historicos);

    return {
      'totalJogos': totalJogos,
      'pontuacaoTotal': pontuacaoTotal,
      'mediaAcertos': mediaAcertos,
      'melhorDesempenho': melhorDesempenho,
      'jogosUltimos7Dias': jogosUltimos7Dias,
      'evolucaoPontuacao': evolucaoPontuacao,
      'desempenhoPorQuiz': desempenhoPorQuiz,
    };
  }

  static List<Map<String, dynamic>> _calcularEvolucaoPontuacao(List<HistoricoJogo> historicos) {
    historicos.sort((a, b) => a.dataJogo.compareTo(b.dataJogo));
    
    int pontuacaoAcumulada = 0;
    return historicos.map((h) {
      pontuacaoAcumulada += h.pontosObtidos;
      return {
        'data': h.dataJogo,
        'pontuacao': pontuacaoAcumulada,
        'jogo': historicos.indexOf(h) + 1,
      };
    }).toList();
  }

  static List<Map<String, dynamic>> _calcularDesempenhoPorQuiz(List<HistoricoJogo> historicos) {
    final Map<int, List<HistoricoJogo>> porQuiz = {};
    
    for (final h in historicos) {
      porQuiz[h.idQuiz] ??= [];
      porQuiz[h.idQuiz]!.add(h);
    }

    return porQuiz.entries.map((entry) {
      final idQuiz = entry.key;
      final jogos = entry.value;
      final totalAcertos = jogos.fold<int>(0, (sum, h) => sum + h.acertos);
      final totalPerguntas = jogos.fold<int>(0, (sum, h) => sum + h.perguntasRespondidas);
      final percentualAcerto = totalPerguntas > 0 ? (totalAcertos / totalPerguntas) * 100 : 0.0;

      return {
        'idQuiz': idQuiz,
        'totalJogos': jogos.length,
        'percentualAcerto': percentualAcerto,
        'ultimoJogo': jogos.last.dataJogo,
      };
    }).toList()
      ..sort((a, b) =>
        ((b['percentualAcerto'] ?? 0) as num).compareTo((a['percentualAcerto'] ?? 0) as num));
  }
}