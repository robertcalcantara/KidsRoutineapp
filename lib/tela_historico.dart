import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'atividade.dart';
import 'widgets/navbar.dart';

class TelaHistorico extends StatefulWidget {
  const TelaHistorico({super.key});

  @override
  State<TelaHistorico> createState() => _TelaHistoricoState();
}

class _TelaHistoricoState extends State<TelaHistorico> {
  String filtroSelecionado = 'Hoje';
  DateTime mesSelecionado = DateTime.now();

  Stream<QuerySnapshot<Map<String, dynamic>>> get _atividadesStream =>
      FirebaseFirestore.instance.collection('atividades').snapshots();

  List<Atividade> _atividadesConcluidas(List<Atividade> atividades) {
    final lista = atividades
        .where((atividade) => atividade.concluida)
        .where(_atividadeDentroDoFiltro)
        .toList();

    lista.sort((a, b) {
      final dataA = a.concluidaEm ?? a.data;
      final dataB = b.concluidaEm ?? b.data;
      return dataB.compareTo(dataA);
    });

    return lista;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _atividadesStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFFF4F4F4),
            bottomNavigationBar: const Navbar(currentIndex: 2),
            body: Center(child: Text('Erro ao carregar histórico: ${snapshot.error}')),
          );
        }

        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Color(0xFFF4F4F4),
            bottomNavigationBar: Navbar(currentIndex: 2),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final atividades = snapshot.data!.docs
            .map((doc) => Atividade.fromFirestore(doc))
            .toList();
        final historico = _atividadesConcluidas(atividades);

        return Scaffold(
          backgroundColor: const Color(0xFFF4F4F4),
          bottomNavigationBar: const Navbar(currentIndex: 2),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 50),
                      const Text(
                        'Histórico',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _botaoFiltro('Hoje'),
                      _botaoFiltro('Semana'),
                      _botaoFiltro('Mês'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _textoFiltro(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: historico.isEmpty
                        ? const Center(
                            child: Text(
                              'Nenhuma atividade concluída neste período',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: historico.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 22),
                            itemBuilder: (context, index) {
                              final atividade = historico[index];
                              return CardHistorico(
                                data: _formatarDataCurta(atividade.data),
                                atividade: atividade.nome,
                                horario: _formatarHorarioConclusao(atividade),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _botaoFiltro(String texto) {
    final selecionado = filtroSelecionado == texto;

    return GestureDetector(
      onTap: () async {
        if (texto == 'Mês') {
          final data = await showDatePicker(
            context: context,
            initialDate: mesSelecionado,
            firstDate: DateTime(2020),
            lastDate: DateTime(2035),
            helpText: 'Escolha uma data do mês',
          );

          if (data == null) return;

          setState(() {
            filtroSelecionado = texto;
            mesSelecionado = data;
          });
          return;
        }

        setState(() {
          filtroSelecionado = texto;
        });
      },
      child: Container(
        width: 105,
        height: 48,
        decoration: BoxDecoration(
          color: selecionado ? const Color(0xFF2D9CDB) : const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            texto,
            style: TextStyle(
              color: selecionado ? Colors.white : Colors.black,
              fontSize: texto == 'Semana' ? 22 : 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }

  bool _atividadeDentroDoFiltro(Atividade atividade) {
    final data = atividade.data;

    if (filtroSelecionado == 'Hoje') {
      final hoje = DateTime.now();
      return data.day == hoje.day && data.month == hoje.month && data.year == hoje.year;
    }

    if (filtroSelecionado == 'Semana') {
      final hoje = DateTime.now();
      final inicioSemana = DateTime(hoje.year, hoje.month, hoje.day)
          .subtract(Duration(days: hoje.weekday - 1));
      final fimSemana = inicioSemana.add(const Duration(days: 6));
      final dataComparar = DateTime(data.year, data.month, data.day);
      return !dataComparar.isBefore(inicioSemana) && !dataComparar.isAfter(fimSemana);
    }

    return data.month == mesSelecionado.month && data.year == mesSelecionado.year;
  }

  String _textoFiltro() {
    if (filtroSelecionado == 'Hoje') return 'Exibindo: Hoje';
    if (filtroSelecionado == 'Semana') return 'Exibindo: Semana atual';
    return 'Exibindo: ${_nomeMes(mesSelecionado.month)} de ${mesSelecionado.year}';
  }

  String _formatarDataCurta(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}';
  }

  String _formatarHorarioConclusao(Atividade atividade) {
    final data = atividade.concluidaEm;
    if (data == null) return atividade.fim;
    return '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
  }

  String _nomeMes(int mes) {
    const meses = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];

    return meses[mes - 1];
  }
}

class CardHistorico extends StatelessWidget {
  final String data;
  final String atividade;
  final String horario;

  const CardHistorico({
    super.key,
    required this.data,
    required this.atividade,
    required this.horario,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD9D9D9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$data - $atividade',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '- Concluída às $horario',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
