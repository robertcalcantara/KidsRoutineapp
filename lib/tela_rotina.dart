import 'package:flutter/material.dart';

import 'atividade.dart';
import 'app_data.dart';
import 'tela_nova_atividade.dart';
import 'widgets/navbar.dart';

class TelaRotina extends StatefulWidget {
  const TelaRotina({super.key});

  @override
  State<TelaRotina> createState() => _TelaRotinaState();
}

class _TelaRotinaState extends State<TelaRotina> {
  List<Atividade> get atividades => AppData.atividades;

  @override
  Widget build(BuildContext context) {
    final atividadesPendentes = atividades
        .where((atividade) => !atividade.concluida)
        .toList();

    final atividadesConcluidas = atividades
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
          final novaAtividade = await Navigator.push(
            context,

            MaterialPageRoute(
              builder: (context) => const NovaAtividadeScreen(),
            ),
          );

          if (novaAtividade != null) {
            setState(() {
              AppData.atividades.add(novaAtividade);
            });
          }
        },
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // TÍTULO
              const Text(
                'Rotina do Dia',

                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                'Acompanhe todas as atividades da criança.',

                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 30),

              // PENDENTES
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

              // CONCLUÍDAS
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
  }

  // CARD VAZIO
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

  // CARD ATIVIDADE
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
          // ÍCONE
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

          // TEXTO
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

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

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

          // CHECKBOX
          Checkbox(
            value: atividade.concluida,

            activeColor: Colors.green,

            onChanged: (value) {
              setState(() {
                atividade.concluida = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  // COR DA CATEGORIA
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

  // ÍCONE DA CATEGORIA
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
