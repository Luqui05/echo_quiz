import 'package:echo_quiz/dao/HistoricoJogoDAO.dart';
import 'package:echo_quiz/models/HistoricoJogo.dart';
import 'package:echo_quiz/models/Sessao.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TelaHistorico extends StatefulWidget {
  const TelaHistorico({super.key});

  @override
  State<TelaHistorico> createState() => _TelaHistoricoState();
}

class _TelaHistoricoState extends State<TelaHistorico> {
  List<HistoricoJogo> _historicos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  Future<void> _carregarHistorico() async {
    if (Sessao.usuarioLogado && Sessao.usuario != null) {
      final historicos = await HistoricoJogoDAO().consultarPorUsuario(Sessao.usuario!.id!);
      setState(() {
        _historicos = historicos;
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
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
        child: _carregando
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : _historicos.isEmpty
                ? _buildHistoricoVazio()
                : _buildListaHistorico(),
      ),
    );
  }

  Widget _buildHistoricoVazio() {
    return Center(
      child: Card(
        color: Colors.white.withOpacity(0.9),
        margin: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.history, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'Nenhum jogo encontrado',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Jogue alguns quizzes para ver seu histórico aqui!',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListaHistorico() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _historicos.length,
      itemBuilder: (context, index) {
        final historico = _historicos[index];
        final percentual = (historico.acertos / historico.perguntasRespondidas * 100).round();
        
        return Card(
          color: Colors.white.withOpacity(0.9),
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quiz ID: ${historico.idQuiz}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(historico.dataJogo),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildEstatistica('Acertos', '${historico.acertos}', Colors.green),
                    _buildEstatistica('Erros', '${historico.erros}', Colors.red),
                    _buildEstatistica('Total', '${historico.perguntasRespondidas}', Colors.blue),
                    _buildEstatistica('Pontos', '${historico.pontosObtidos}', Colors.amber),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: percentual / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    percentual >= 70 ? Colors.green : percentual >= 50 ? Colors.orange : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEstatistica(String label, String valor, Color cor) {
    return Expanded(
      child: Column(
        children: [
          Text(
            valor,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: cor,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}