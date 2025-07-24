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
  List<HistoricoJogo> _todosHistoricos = [];
  List<HistoricoJogo> _historicosFiltrados = [];
  bool _carregando = true;
  
  // Filtros
  String _filtroSelecionado = 'todos';
  DateTime? _dataInicio;
  DateTime? _dataFim;
  String _agrupamentoSelecionado = 'data';

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  Future<void> _carregarHistorico() async {
    if (Sessao.usuarioLogado && Sessao.usuario != null) {
      final historicos = await HistoricoJogoDAO().consultarPorUsuario(Sessao.usuario!.id!);
      setState(() {
        _todosHistoricos = historicos;
        _historicosFiltrados = historicos;
        _carregando = false;
      });
    }
  }

  void _aplicarFiltros() {
    List<HistoricoJogo> filtrados = List.from(_todosHistoricos);

    switch (_filtroSelecionado) {
      case 'ultimos7':
        final seteDiasAtras = DateTime.now().subtract(const Duration(days: 7));
        filtrados = filtrados.where((h) => h.dataJogo.isAfter(seteDiasAtras)).toList();
        break;
      case 'ultimos30':
        final trintaDiasAtras = DateTime.now().subtract(const Duration(days: 30));
        filtrados = filtrados.where((h) => h.dataJogo.isAfter(trintaDiasAtras)).toList();
        break;
      case 'periodo':
        if (_dataInicio != null && _dataFim != null) {
          filtrados = filtrados.where((h) => 
            h.dataJogo.isAfter(_dataInicio!) && 
            h.dataJogo.isBefore(_dataFim!.add(const Duration(days: 1)))
          ).toList();
        }
        break;
      case 'acertos_altos':
        filtrados = filtrados.where((h) => 
          (h.acertos / h.perguntasRespondidas) >= 0.7).toList();
        break;
      case 'precisa_melhorar':
        filtrados = filtrados.where((h) => 
          (h.acertos / h.perguntasRespondidas) < 0.5).toList();
        break;
    }

    // Aplicar agrupamento
    switch (_agrupamentoSelecionado) {
      case 'data':
        filtrados.sort((a, b) => b.dataJogo.compareTo(a.dataJogo));
        break;
      case 'pontuacao':
        filtrados.sort((a, b) => b.pontosObtidos.compareTo(a.pontosObtidos));
        break;
      case 'desempenho':
        filtrados.sort((a, b) => 
          (b.acertos / b.perguntasRespondidas).compareTo(a.acertos / a.perguntasRespondidas));
        break;
    }

    setState(() {
      _historicosFiltrados = filtrados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _mostrarDialogoFiltros,
          ),
        ],
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
            : Column(
                children: [
                  _buildResumoEstatisticas(),
                  Expanded(
                    child: _historicosFiltrados.isEmpty
                        ? _buildHistoricoVazio()
                        : _buildListaHistorico(),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildResumoEstatisticas() {
    if (_historicosFiltrados.isEmpty) return const SizedBox.shrink();

    final totalJogos = _historicosFiltrados.length;
    final totalPontos = _historicosFiltrados.fold<int>(0, (sum, h) => sum + h.pontosObtidos);
    final totalAcertos = _historicosFiltrados.fold<int>(0, (sum, h) => sum + h.acertos);
    final totalPerguntas = _historicosFiltrados.fold<int>(0, (sum, h) => sum + h.perguntasRespondidas);
    final mediaAcertos = totalPerguntas > 0 ? (totalAcertos / totalPerguntas * 100) : 0;

    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        color: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Resumo dos Resultados Filtrados',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildResumoItem('Jogos', totalJogos.toString(), Icons.sports_esports, Colors.blue),
                  _buildResumoItem('Pontos', totalPontos.toString(), Icons.star, Colors.amber),
                  _buildResumoItem('Média', '${mediaAcertos.toStringAsFixed(1)}%', Icons.trending_up, Colors.green),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResumoItem(String label, String valor, IconData icone, Color cor) {
    return Column(
      children: [
        Icon(icone, color: cor, size: 24),
        const SizedBox(height: 4),
        Text(
          valor,
          style: GoogleFonts.poppins(
            fontSize: 16,
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
    );
  }

  void _mostrarDialogoFiltros() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtros e Agrupamentos'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _filtroSelecionado,
                decoration: const InputDecoration(labelText: 'Filtrar por'),
                items: const [
                  DropdownMenuItem(value: 'todos', child: Text('Todos os jogos')),
                  DropdownMenuItem(value: 'ultimos7', child: Text('Últimos 7 dias')),
                  DropdownMenuItem(value: 'ultimos30', child: Text('Últimos 30 dias')),
                  DropdownMenuItem(value: 'periodo', child: Text('Período personalizado')),
                  DropdownMenuItem(value: 'acertos_altos', child: Text('Alto desempenho (≥70%)')),
                  DropdownMenuItem(value: 'precisa_melhorar', child: Text('Precisa melhorar (<50%)')),
                ],
                onChanged: (valor) => setState(() => _filtroSelecionado = valor!),
              ),
              const SizedBox(height: 16),
              if (_filtroSelecionado == 'periodo') ...[
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final data = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (data != null) setState(() => _dataInicio = data);
                        },
                        child: Text(_dataInicio != null 
                            ? DateFormat('dd/MM/yyyy').format(_dataInicio!)
                            : 'Data início'),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final data = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (data != null) setState(() => _dataFim = data);
                        },
                        child: Text(_dataFim != null 
                            ? DateFormat('dd/MM/yyyy').format(_dataFim!)
                            : 'Data fim'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              DropdownButtonFormField<String>(
                value: _agrupamentoSelecionado,
                decoration: const InputDecoration(labelText: 'Agrupar por'),
                items: const [
                  DropdownMenuItem(value: 'data', child: Text('Data (mais recente)')),
                  DropdownMenuItem(value: 'pontuacao', child: Text('Pontuação (maior)')),
                  DropdownMenuItem(value: 'desempenho', child: Text('Desempenho (melhor %)')),
                ],
                onChanged: (valor) => setState(() => _agrupamentoSelecionado = valor!),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _aplicarFiltros();
            },
            child: const Text('Aplicar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _filtroSelecionado = 'todos';
                _agrupamentoSelecionado = 'data';
                _dataInicio = null;
                _dataFim = null;
                _historicosFiltrados = _todosHistoricos;
              });
              Navigator.pop(context);
            },
            child: const Text('Limpar'),
          ),
        ],
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
              const Icon(Icons.filter_list_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'Nenhum resultado encontrado',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tente ajustar os filtros ou jogue mais quizzes!',
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
      itemCount: _historicosFiltrados.length,
      itemBuilder: (context, index) {
        final historico = _historicosFiltrados[index];
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
                    Row(
                      children: [
                        Icon(
                          _getIconeDesempenho(percentual),
                          color: _getCorDesempenho(percentual),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('dd/MM/yyyy HH:mm').format(historico.dataJogo),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
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
                  valueColor: AlwaysStoppedAnimation<Color>(_getCorDesempenho(percentual)),
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

  Color _getCorDesempenho(int percentual) {
    if (percentual >= 70) return Colors.green;
    if (percentual >= 50) return Colors.orange;
    return Colors.red;
  }

  IconData _getIconeDesempenho(int percentual) {
    if (percentual >= 70) return Icons.emoji_events;
    if (percentual >= 50) return Icons.thumb_up;
    return Icons.trending_down;
  }
}