import 'package:echo_quiz/config/Rotas.dart';
import 'package:echo_quiz/dao/QuizDAO.dart';
import 'package:echo_quiz/models/Quiz.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaSelecaoQuiz extends StatefulWidget {
  const TelaSelecaoQuiz({super.key});

  @override
  State<StatefulWidget> createState() => _TelaSelecaoQuizState();
}

class _TelaSelecaoQuizState extends State<TelaSelecaoQuiz> {
  List<Quiz> _quizzesDisponiveis = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarQuizzes();
  }

  Future<void> _carregarQuizzes() async {
    final quizzes = await QuizDAO().consultarTodos();
    setState(() {
      _quizzesDisponiveis = quizzes;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Quiz'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: _carregando
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : _quizzesDisponiveis.isEmpty
            ? _buildTelaVazia()
            : _buildListaQuizzes(),
      ),
    );
  }

  Widget _buildTelaVazia() {
    return Center(
      child: Card(
        color: Colors.white.withOpacity(0.92),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.quiz_outlined,
                size: 64,
                color: Colors.deepPurpleAccent,
              ),
              const SizedBox(height: 24),
              Text(
                'Nenhum Quiz Disponível',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Crie seu primeiro quiz para começar a jogar!',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, Rotas.cadastroQuiz);
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: Text(
                    'Criar Meu Primeiro Quiz',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListaQuizzes() {
    return Column(
      children: [
        // Botão criar quiz no topo
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              await Navigator.pushNamed(context, Rotas.cadastroQuiz);
              _carregarQuizzes(); // Recarrega a lista ao voltar
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              'Criar Novo Quiz',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Lista de quizzes
        Expanded(
          child: ListView.builder(
            itemCount: _quizzesDisponiveis.length,
            itemBuilder: (context, index) {
              final quiz = _quizzesDisponiveis[index];
              return Card(
                color: Colors.white.withOpacity(0.92),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurpleAccent,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    quiz.titulo,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '${quiz.perguntas.length} pergunta(s)',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  trailing: const Icon(
                    Icons.play_arrow,
                    color: Colors.deepPurpleAccent,
                    size: 32,
                  ),
                  onTap: () {
                    // TODO: Navegar para a tela do quiz
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Iniciando quiz "${quiz.titulo}"!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
