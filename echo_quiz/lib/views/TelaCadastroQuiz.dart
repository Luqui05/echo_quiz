import 'package:echo_quiz/config/Rotas.dart';
import 'package:echo_quiz/dao/PerguntaDAO.dart';
import 'package:echo_quiz/dao/QuizDAO.dart';
import 'package:echo_quiz/models/Quiz.dart';
import 'package:echo_quiz/models/Pergunta.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaCadastroQuiz extends StatefulWidget {
  const TelaCadastroQuiz({super.key});

  @override
  State<StatefulWidget> createState() => _TelaCadastroQuizState();
}

class _TelaCadastroQuizState extends State<TelaCadastroQuiz> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  List<Pergunta> _perguntasDisponiveis = [];
  List<Pergunta> _perguntasSelecionadas = [];

  @override
  void initState() {
    super.initState();
    _carregarPerguntas();
  }

  Future<void> _carregarPerguntas() async {
    final perguntas = await PerguntaDAO().consultarTodos();
    setState(() {
      _perguntasDisponiveis = perguntas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Quiz'),
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
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              color: Colors.white.withOpacity(0.92),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Novo Quiz',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _tituloController,
                        decoration: InputDecoration(
                          labelText: 'Título do Quiz',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        style: GoogleFonts.poppins(),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Informe o título' : null,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Selecione as Perguntas',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListView.builder(
                          itemCount: _perguntasDisponiveis.length,
                          itemBuilder: (context, index) {
                            final pergunta = _perguntasDisponiveis[index];
                            final isSelected = _perguntasSelecionadas.contains(
                              pergunta,
                            );
                            return CheckboxListTile(
                              title: Text(
                                pergunta.texto,
                                style: GoogleFonts.poppins(fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              value: isSelected,
                              activeColor: Colors.deepPurpleAccent,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _perguntasSelecionadas.add(pergunta);
                                  } else {
                                    _perguntasSelecionadas.remove(pergunta);
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (_perguntasSelecionadas.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Selecione pelo menos uma pergunta',
                                    ),
                                  ),
                                );
                                return;
                              }
                              final quiz = Quiz(
                                titulo: _tituloController.text,
                                perguntas: _perguntasSelecionadas,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Quiz salvo com sucesso!'),
                                ),
                              );
                              await QuizDAO().salvar(quiz);
                              Navigator.pushNamed(context, Rotas.home);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 3,
                          ),
                          child: Text(
                            'Salvar Quiz',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
