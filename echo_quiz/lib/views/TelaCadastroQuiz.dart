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
  final List<int> _perguntasSelecionadas = [];

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
                      // Aqui você pode adicionar a seleção de perguntas
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Salvar quiz
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Salvar',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.white,
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
