import 'package:echo_quiz/config/Rotas.dart';
import 'package:echo_quiz/models/Quiz.dart';
import 'package:echo_quiz/models/Pergunta.dart';
import 'package:echo_quiz/models/Alternativa.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaQuiz extends StatefulWidget {
  final Quiz quiz;
  
  const TelaQuiz({super.key, required this.quiz});

  @override
  State<TelaQuiz> createState() => _TelaQuizState();
}

class _TelaQuizState extends State<TelaQuiz> {
  int _perguntaAtual = 0;
  int _pontuacao = 0;
  int? _alternativaSelecionada;
  bool _respondeu = false;
  List<bool> _respostasCorretas = [];

  Pergunta get perguntaAtual => widget.quiz.perguntas[_perguntaAtual];
  bool get isUltimaPergunta => _perguntaAtual == widget.quiz.perguntas.length - 1;

  void _selecionarAlternativa(int index) {
    if (!_respondeu) {
      setState(() {
        _alternativaSelecionada = index;
      });
    }
  }

  void _confirmarResposta() {
    if (_alternativaSelecionada == null) return;

    setState(() {
      _respondeu = true;
      bool acertou = _alternativaSelecionada == perguntaAtual.indiceAlternativaCorreta;
      _respostasCorretas.add(acertou);
      if (acertou) {
        _pontuacao += 10; // 10 pontos por resposta correta
      }
    });
  }

  void _proximaPergunta() {
    if (isUltimaPergunta) {
      _finalizarQuiz();
    } else {
      setState(() {
        _perguntaAtual++;
        _alternativaSelecionada = null;
        _respondeu = false;
      });
    }
  }

  void _finalizarQuiz() {
    Navigator.pushReplacementNamed(
      context,
      Rotas.resultadoQuiz,
      arguments: {
        'quiz': widget.quiz,
        'pontuacao': _pontuacao,
        'respostasCorretas': _respostasCorretas,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.titulo),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
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
              _buildProgresso(),
              const SizedBox(height: 24),
              _buildPergunta(),
              const SizedBox(height: 24),
              _buildAlternativas(),
              const Spacer(),
              _buildBotaoAcao(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgresso() {
    return Card(
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pergunta ${_perguntaAtual + 1} de ${widget.quiz.perguntas.length}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Pontuação: $_pontuacao',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: (_perguntaAtual + 1) / widget.quiz.perguntas.length,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPergunta() {
    return Card(
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          perguntaAtual.texto,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildAlternativas() {
    return Expanded(
      child: ListView.builder(
        itemCount: perguntaAtual.alternativas.length,
        itemBuilder: (context, index) {
          final alternativa = perguntaAtual.alternativas[index];
          final selecionada = _alternativaSelecionada == index;
          final correta = index == perguntaAtual.indiceAlternativaCorreta;
          
          Color? corCard;
          if (_respondeu) {
            if (correta) {
              corCard = Colors.green.withOpacity(0.7);
            } else if (selecionada && !correta) {
              corCard = Colors.red.withOpacity(0.7);
            } else {
              corCard = Colors.white.withOpacity(0.9);
            }
          } else {
            corCard = selecionada 
                ? Colors.deepPurpleAccent.withOpacity(0.3)
                : Colors.white.withOpacity(0.9);
          }

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: corCard,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: _respondeu && correta 
                    ? Colors.green 
                    : _respondeu && selecionada && !correta
                        ? Colors.red
                        : Colors.deepPurpleAccent,
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, D...
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                alternativa.texto,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: _respondeu && correta 
                  ? const Icon(Icons.check_circle, color: Colors.green, size: 28)
                  : _respondeu && selecionada && !correta
                      ? const Icon(Icons.cancel, color: Colors.red, size: 28)
                      : null,
              onTap: () => _selecionarAlternativa(index),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBotaoAcao() {
    if (!_respondeu) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _alternativaSelecionada != null ? _confirmarResposta : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Text(
            'Confirmar Resposta',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _proximaPergunta,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Text(
            isUltimaPergunta ? 'Ver Resultado' : 'Próxima Pergunta',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }
}