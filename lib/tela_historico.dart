import 'package:flutter/material.dart';
import 'widgets/navbar.dart';

class TelaHistorico extends StatefulWidget {
  const TelaHistorico({super.key});

  @override
  State<TelaHistorico> createState() => _TelaHistoricoState();
}

class _TelaHistoricoState extends State<TelaHistorico> {
  String filtroSelecionado = 'Hoje';

  String semanaSelecionada = 'Semana Atual';
  String mesSelecionado = 'Março';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      bottomNavigationBar: const Navbar(currentIndex: 2),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SizedBox(height: 15),

              // TOPO
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

                  // LOGO (Linhas 47 a 61)
                  SizedBox(
                    width: 70, // Ajustado para caber bem no Row
                    height: 70,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // BOTÕES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_botaoHoje(), _botaoSemana(), _botaoMes()],
              ),

              const SizedBox(height: 20),

              // TEXTO SELECIONADO
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  filtroSelecionado == 'Hoje'
                      ? 'Exibindo: Hoje'
                      : filtroSelecionado == 'Semana'
                      ? 'Exibindo: $semanaSelecionada'
                      : 'Exibindo: $mesSelecionado',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // LISTA
              Expanded(
                child: ListView(
                  children: const [
                    CardHistorico(
                      data: '31/03',
                      atividade: 'Estudar',
                      horario: '18:00',
                    ),

                    SizedBox(height: 22),

                    CardHistorico(
                      data: '30/03',
                      atividade: 'Estudar',
                      horario: '17:00',
                    ),

                    SizedBox(height: 22),

                    CardHistorico(
                      data: '29/03',
                      atividade: 'Estudar',
                      horario: '17:30',
                    ),

                    SizedBox(height: 22),

                    CardHistorico(
                      data: '28/03',
                      atividade: 'Estudar',
                      horario: '16:00',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // BOTÃO HOJE
  Widget _botaoHoje() {
    return GestureDetector(
      onTap: () {
        setState(() {
          filtroSelecionado = 'Hoje';
        });
      },
      child: Container(
        width: 105,
        height: 48,
        decoration: BoxDecoration(
          color: filtroSelecionado == 'Hoje'
              ? const Color(0xFF2D9CDB)
              : const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            'Hoje',
            style: TextStyle(
              color: filtroSelecionado == 'Hoje' ? Colors.white : Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }

  // BOTÃO SEMANA
  Widget _botaoSemana() {
    return GestureDetector(
      onTap: () async {
        final semana = await showDialog<String>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Escolha a semana'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _itemSemana('Semana Atual'),
                  _itemSemana('Semana Passada'),
                  _itemSemana('Há 2 semanas'),
                ],
              ),
            );
          },
        );

        if (semana != null) {
          setState(() {
            filtroSelecionado = 'Semana';
            semanaSelecionada = semana;
          });
        }
      },
      child: Container(
        width: 105,
        height: 48,
        decoration: BoxDecoration(
          color: filtroSelecionado == 'Semana'
              ? const Color(0xFF2D9CDB)
              : const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            'Semana',
            style: TextStyle(
              color: filtroSelecionado == 'Semana'
                  ? Colors.white
                  : Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }

  // BOTÃO MÊS
  Widget _botaoMes() {
    return GestureDetector(
      onTap: () async {
        final mes = await showDialog<String>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Escolha o mês'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _itemMes('Janeiro'),
                  _itemMes('Fevereiro'),
                  _itemMes('Março'),
                  _itemMes('Abril'),
                ],
              ),
            );
          },
        );

        if (mes != null) {
          setState(() {
            filtroSelecionado = 'Mês';
            mesSelecionado = mes;
          });
        }
      },
      child: Container(
        width: 105,
        height: 48,
        decoration: BoxDecoration(
          color: filtroSelecionado == 'Mês'
              ? const Color(0xFF2D9CDB)
              : const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            'Mês',
            style: TextStyle(
              color: filtroSelecionado == 'Mês' ? Colors.white : Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemSemana(String texto) {
    return ListTile(
      title: Text(texto),
      onTap: () {
        Navigator.pop(context, texto);
      },
    );
  }

  Widget _itemMes(String texto) {
    return ListTile(
      title: Text(texto),
      onTap: () {
        Navigator.pop(context, texto);
      },
    );
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
