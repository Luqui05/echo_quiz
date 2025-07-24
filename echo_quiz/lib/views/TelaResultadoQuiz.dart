import 'package:echo_quiz/components/ComponenteCard.dart';
import 'package:echo_quiz/components/ComponenteEstatistica.dart';
import 'package:echo_quiz/config/Rotas.dart';
import 'package:echo_quiz/dao/HistoricoJogoDAO.dart';
import 'package:echo_quiz/models/HistoricoJogo.dart';
import 'package:echo_quiz/models/Quiz.dart';
import 'package:echo_quiz/models/Sessao.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaResultadoQuiz extends StatefulWidget {
  const TelaResultadoQuiz({super.key});

  @override
  State<TelaResultadoQuiz> createState() => _TelaResultadoQuizState();
}

class _TelaResultadoQuizState extends State<TelaResultadoQuiz> {
  bool _salvandoHistorico = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _salvarHistorico();
    });
  }

  Future<void> _salvarHistorico() async {
    if (_salvandoHistorico) return;
    
    setState(() {
      _salvandoHistorico = true;
    });

    try {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && Sessao.usuarioLogado && Sessao.usuario != null) {
        final quiz = args['quiz'] as Quiz;
        final pontuacao = args['pontuacao'] as int;
        final respostasCorretas = args['respostasCorretas'] as List<bool>;
        
        final historico = HistoricoJogo(
          id: 0,
          idUsuario: Sessao.usuario!.id!,
          idQuiz: quiz.id!,
          dataJogo: DateTime.now(),
          perguntasRespondidas: respostasCorretas.length,
          acertos: respostasCorretas.where((r) => r).length,
          erros: respostasCorretas.where((r) => !r).length,
          pontosObtidos: pontuacao,
        );
        
        await HistoricoJogoDAO().inserir(historico);
      }
    } catch (e) {
      debugPrint('Erro ao salvar histórico: $e');
    } finally {
      setState(() {
        _salvandoHistorico = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (args == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: const Center(child: Text('Dados não encontrados')),
      );
    }

    final quiz = args['quiz'] as Quiz;
    final pontuacao = args['pontuacao'] as int;
    final respostasCorretas = args['respostasCorretas'] as List<bool>;
    final totalPerguntas = respostasCorretas.length;
    final acertos = respostasCorretas.where((r) => r).length;
    final erros = totalPerguntas - acertos;
    final percentualAcerto = totalPerguntas > 0 ? (acertos / totalPerguntas * 100).round() : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
        backgroundColor: Colors.deepPurpleAccent,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTitulo(quiz.titulo),
                      const SizedBox(height: 24),
                      _buildPontuacao(pontuacao),
                      const SizedBox(height: 24),
                      _buildEstatisticas(totalPerguntas, acertos, erros, percentualAcerto),
                      const SizedBox(height: 24),
                      _buildDesempenho(percentualAcerto),
                      const SizedBox(height: 24),
                      _buildDetalhamento(respostasCorretas),
                    ],
                  ),
                ),
              ),
              _buildBotoes(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitulo(String titulo) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.emoji_events,
              size: 48,
              color: Colors.amber,
            ),
            const SizedBox(height: 12),
            Text(
              'Quiz Finalizado!',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              titulo,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPontuacao(int pontuacao) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Pontuação Final',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '$pontuacao',
              style: GoogleFonts.poppins(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent,
              ),
            ),
            Text(
              'pontos',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstatisticas(int total, int acertos, int erros, int percentual) {
    return ComponenteCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ComponenteEstatistica(
            rotulo: 'Total',
            valor: total.toString(),
            icone: Icons.quiz,
            cor: Colors.blue,
          ),
          ComponenteEstatistica(
            rotulo: 'Acertos',
            valor: acertos.toString(),
            icone: Icons.check_circle,
            cor: Colors.green,
          ),
          ComponenteEstatistica(
            rotulo: 'Erros',
            valor: erros.toString(),
            icone: Icons.cancel,
            cor: Colors.red,
          ),
          ComponenteEstatistica(
            rotulo: 'Acerto',
            valor: '$percentual%',
            icone: Icons.percent,
            cor: Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildEstatisticaItem(String label, String valor, IconData icon, Color cor) {
    return Column(
      children: [
        Icon(icon, color: cor, size: 32),
        const SizedBox(height: 8),
        Text(
          valor,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: cor,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDesempenho(int percentual) {
    String mensagem;
    Color cor;
    IconData icone;

    if (percentual >= 80) {
      mensagem = 'Excelente! Parabéns!';
      cor = Colors.green;
      icone = Icons.star;
    } else if (percentual >= 60) {
      mensagem = 'Bom trabalho!';
      cor = Colors.blue;
      icone = Icons.thumb_up;
    } else if (percentual >= 40) {
      mensagem = 'Continue praticando!';
      cor = Colors.orange;
      icone = Icons.trending_up;
    } else {
      mensagem = 'Estude mais e tente novamente!';
      cor = Colors.red;
      icone = Icons.school;
    }

    return Card(
      color: cor.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icone, color: cor, size: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                mensagem,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: cor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetalhamento(List<bool> respostasCorretas) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detalhamento por pergunta:',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: respostasCorretas.asMap().entries.map((entry) {
                final index = entry.key;
                final correto = entry.value;
                
                return Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: correto ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotoes() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Rotas.selecaoQuiz,
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(
              'Jogar Novamente',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Rotas.home,
                (route) => false,
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(
              'Voltar ao Início',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}