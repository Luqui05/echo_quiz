import 'package:echo_quiz/models/Sessao.dart';
import 'package:echo_quiz/service/EstatisticaService.dart';
import 'package:echo_quiz/components/ComponenteAppBar.dart';
import 'package:echo_quiz/components/ComponenteCard.dart';
import 'package:echo_quiz/components/ComponenteEstatistica.dart';
import 'package:echo_quiz/components/ComponenteLayoutGradiente.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TelaDashboard extends StatefulWidget {
  const TelaDashboard({super.key});

  @override
  State<TelaDashboard> createState() => _TelaDashboardState();
}

class _TelaDashboardState extends State<TelaDashboard> {
  Map<String, dynamic>? _estatisticas;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarEstatisticas();
  }

  Future<void> _carregarEstatisticas() async {
    if (Sessao.usuarioLogado && Sessao.usuario != null) {
      final stats = await EstatisticasService.obterEstatisticasUsuario(Sessao.usuario!.id!);
      setState(() {
        _estatisticas = stats;
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ComponenteAppBar(titulo: 'Dashboard'),
      body: ComponenteLayoutGradiente(
        child: _carregando
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : _estatisticas == null
                ? _buildSemDados()
                : _buildDashboard(),
      ),
    );
  }

  Widget _buildSemDados() {
    return const Center(
      child: ComponenteCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.analytics_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Nenhum dado encontrado'),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResumoEstatisticas(),
          const SizedBox(height: 24),
          _buildGraficoEvolucao(),
          const SizedBox(height: 24),
          _buildGraficoDesempenho(),
          const SizedBox(height: 24),
          _buildAtividadeRecente(),
        ],
      ),
    );
  }

  Widget _buildResumoEstatisticas() {
    return ComponenteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo Geral',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ComponenteEstatistica(
                  rotulo: 'Jogos',
                  valor: '${_estatisticas!['totalJogos']}',
                  icone: Icons.sports_esports,
                  cor: Colors.blue,
                ),
              ),
              Expanded(
                child: ComponenteEstatistica(
                  rotulo: 'Pontos',
                  valor: '${_estatisticas!['pontuacaoTotal']}',
                  icone: Icons.star,
                  cor: Colors.amber,
                ),
              ),
              Expanded(
                child: ComponenteEstatistica(
                  rotulo: 'Média',
                  valor: '${_estatisticas!['mediaAcertos'].toStringAsFixed(1)}%',
                  icone: Icons.trending_up,
                  cor: Colors.green,
                ),
              ),
              Expanded(
                child: ComponenteEstatistica(
                  rotulo: 'Melhor',
                  valor: '${_estatisticas!['melhorDesempenho'].toStringAsFixed(1)}%',
                  icone: Icons.emoji_events,
                  cor: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGraficoEvolucao() {
    final evolucao = _estatisticas!['evolucaoPontuacao'] as List<Map<String, dynamic>>;
    
    if (evolucao.isEmpty) {
      return const ComponenteCard(
        child: Column(
          children: [
            Icon(Icons.timeline, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text('Sem dados de evolução'),
          ],
        ),
      );
    }

    return ComponenteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Evolução da Pontuação',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Text(
                        'J${value.toInt()}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: evolucao.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        entry.value['pontuacao'].toDouble(),
                      );
                    }).toList(),
                    isCurved: true,
                    color: Colors.deepPurpleAccent,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.deepPurpleAccent.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGraficoDesempenho() {
    final desempenho = _estatisticas!['desempenhoPorQuiz'] as List<Map<String, dynamic>>;
    
    if (desempenho.isEmpty) {
      return const ComponenteCard(
        child: Column(
          children: [
            Icon(Icons.pie_chart, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text('Sem dados de desempenho'),
          ],
        ),
      );
    }

    return ComponenteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Desempenho por Quiz',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}%',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Text(
                        'Q${value.toInt() + 1}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: desempenho.asMap().entries.map((entry) {
                  final percentual = entry.value['percentualAcerto'] as double;
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: percentual,
                        color: _getCorDesempenho(percentual),
                        width: 20,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAtividadeRecente() {
    final jogosRecentes = _estatisticas!['jogosUltimos7Dias'] as List;
    
    return ComponenteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Atividade dos Últimos 7 Dias',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          if (jogosRecentes.isEmpty)
            const Center(
              child: Column(
                children: [
                  Icon(Icons.calendar_today, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Nenhuma atividade recente'),
                ],
              ),
            )
          else
            ...jogosRecentes.take(5).map((jogo) => ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurpleAccent,
                child: Text('Q${jogo.idQuiz}'),
              ),
              title: Text('${jogo.acertos}/${jogo.perguntasRespondidas} acertos'),
              subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(jogo.dataJogo)),
              trailing: Text(
                '${jogo.pontosObtidos} pts',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            )),
        ],
      ),
    );
  }

  Color _getCorDesempenho(double percentual) {
    if (percentual >= 80) return Colors.green;
    if (percentual >= 60) return Colors.orange;
    return Colors.red;
  }
}