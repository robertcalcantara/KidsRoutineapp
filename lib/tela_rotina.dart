import 'package:cloud_firestore/cloud_firestore.dart';
import 'atividade.dart';
import 'package:flutter/material.dart';

import 'tela_nova_atividade.dart';
import 'widgets/navbar.dart';

class TelaRotina extends StatefulWidget {
  final String filtroInicial;

  const TelaRotina({
    super.key,
    this.filtroInicial = 'Hoje',
  });

  @override
  State<TelaRotina> createState() => _TelaRotinaState();
}

class _TelaRotinaState extends State<TelaRotina> {
  late String filtroSelecionado;
  DateTime diaSelecionado = DateTime.now();
  DateTime mesSelecionado = DateTime.now();

  @override
  void initState() {
    super.initState();
    filtroSelecionado = widget.filtroInicial;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
  stream: FirebaseFirestore.instance
      .collection('atividades')
      .snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final atividades = snapshot.data!.docs
        .map((doc) => Atividade.fromFirestore(doc))
        .toList();
        print('ATIVIDADES ENCONTRADAS: ${atividades.length}');

    final atividadesFiltradas = atividades
        .where(_atividadeDentroDoFiltro)
        .toList()
      ..sort((a, b) => a.inicio.compareTo(b.inicio));

    final atividadesPendentes = atividadesFiltradas
        .where((atividade) => !atividade.concluida)
        .toList();

    final atividadesConcluidas = atividadesFiltradas
        .where((atividade) => atividade.concluida)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      bottomNavigationBar: const Navbar(currentIndex: 1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'ROTINA',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1976D2),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const NovaAtividadeScreen(),
  ),
);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rotina',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Acompanhe todas as atividades da criança.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFiltroButton('Hoje'),
                  _buildFiltroButton('Semana'),
                  _buildFiltroButton('Mês'),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                _textoPeriodoSelecionado(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 30),
              const Text(
                'Atividades Pendentes',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              atividadesPendentes.isEmpty
                  ? _buildEmptyCard('Nenhuma atividade pendente')
                  : Column(
                      children: atividadesPendentes.map((atividade) {
                        return _buildAtividadeCard(atividade);
                      }).toList(),
                    ),
              const SizedBox(height: 35),
              const Text(
                'Atividades Concluídas',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              atividadesConcluidas.isEmpty
                  ? _buildEmptyCard('Nenhuma atividade concluída')
                  : Column(
                      children: atividadesConcluidas.map((atividade) {
                        return _buildAtividadeCard(atividade);
                      }).toList(),
                    ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  },
);
}
  Widget _buildFiltroButton(String texto) {
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
          diaSelecionado = DateTime.now();
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
    final dataAtividade = atividade.data;

    if (filtroSelecionado == 'Hoje') {
      return _mesmoDia(dataAtividade, DateTime.now());
    }

    if (filtroSelecionado == 'Semana') {
      final hoje = DateTime.now();
      final inicioSemana = DateTime(hoje.year, hoje.month, hoje.day)
          .subtract(Duration(days: hoje.weekday - 1));
      final fimSemana = inicioSemana.add(const Duration(days: 6));
      final data = DateTime(dataAtividade.year, dataAtividade.month, dataAtividade.day);
      return !data.isBefore(inicioSemana) && !data.isAfter(fimSemana);
    }

    return dataAtividade.month == mesSelecionado.month &&
        dataAtividade.year == mesSelecionado.year;
  }

  String _textoPeriodoSelecionado() {
    if (filtroSelecionado == 'Hoje') {
      return 'Exibindo: Hoje';
    }

    if (filtroSelecionado == 'Semana') {
      return 'Exibindo: Semana atual';
    }

    return 'Exibindo: ${_nomeMes(mesSelecionado.month)} de ${mesSelecionado.year}';
  }

  bool _mesmoDia(DateTime a, DateTime b) {
    return a.day == b.day && a.month == b.month && a.year == b.year;
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
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

  Widget _buildEmptyCard(String texto) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Text(
          texto,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildAtividadeCard(Atividade atividade) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: getCategoriaColor(atividade.categoria).withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              getCategoriaIcon(atividade.categoria),
              color: getCategoriaColor(atividade.categoria),
              size: 28,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  atividade.nome,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    decoration: atividade.concluida
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${atividade.inicio} - ${atividade.fim}',
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatarData(atividade.data),
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: getCategoriaColor(atividade.categoria),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    atividade.categoria,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
  value: atividade.concluida,
  activeColor: Colors.green,
  onChanged: (value) async {
    await FirebaseFirestore.instance
        .collection('atividades')
        .doc(atividade.id)
        .update({
      'concluida': value,
      'concluidaEm': value == true
          ? Timestamp.now()
          : null,
    });
  },
),
        ],
      ),
    );
  }

  Color getCategoriaColor(String categoria) {
    switch (categoria) {
      case 'Sono':
        return Colors.deepPurple;
      case 'Alimentação':
        return Colors.orange;
      case 'Estudos':
        return Colors.green;
      case 'Lazer':
        return Colors.cyan;
      case 'Medicação':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  IconData getCategoriaIcon(String categoria) {
    switch (categoria) {
      case 'Sono':
        return Icons.bed;
      case 'Alimentação':
        return Icons.restaurant;
      case 'Estudos':
        return Icons.menu_book;
      case 'Lazer':
        return Icons.sports_esports;
      case 'Medicação':
        return Icons.medication;
      default:
        return Icons.task;
    }
  }
}
