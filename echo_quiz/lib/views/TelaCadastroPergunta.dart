import 'package:echo_quiz/dao/PerguntaDAO.dart';
import 'package:echo_quiz/models/Alternativa.dart';
import 'package:echo_quiz/models/Pergunta.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaCadastroPergunta extends StatefulWidget {
  const TelaCadastroPergunta({super.key});

  @override
  State<TelaCadastroPergunta> createState() => _TelaCadastroPerguntaState();
}

class _TelaCadastroPerguntaState extends State<TelaCadastroPergunta> {
  final _formKey = GlobalKey<FormState>();
  final _perguntaController = TextEditingController();
  final List<TextEditingController> _alternativasControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  int _indiceCorreta = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Pergunta'),
        backgroundColor: Colors.deepPurpleAccent,
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
        padding: const EdgeInsets.symmetric(horizontal: 24),
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
                        'Nova Pergunta',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _perguntaController,
                        decoration: InputDecoration(
                          labelText: 'Pergunta',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        style: GoogleFonts.poppins(),
                        validator: (v) => v == null || v.isEmpty
                            ? 'Informe a pergunta'
                            : null,
                      ),
                      const SizedBox(height: 24),
                      ...List.generate(
                        4,
                        (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Radio<int>(
                                value: i,
                                groupValue: _indiceCorreta,
                                activeColor: Colors.deepPurpleAccent,
                                onChanged: (v) =>
                                    setState(() => _indiceCorreta = v!),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _alternativasControllers[i],
                                  decoration: InputDecoration(
                                    labelText: 'Alternativa ${i + 1}',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  style: GoogleFonts.poppins(),
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Informe a alternativa'
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final pergunta = Pergunta(
                                texto: _perguntaController.text,
                                alternativas: _alternativasControllers
                                    .map((c) => Alternativa(texto: c.text))
                                    .toList(),
                                indiceAlternativaCorreta: _indiceCorreta,
                              );
                              await PerguntaDAO().salvar(pergunta);
                              Navigator.pop(context);
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
