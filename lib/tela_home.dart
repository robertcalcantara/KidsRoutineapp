import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'widgets/navbar.dart';
import 'Tela_perfil.dart';
import 'atividade.dart';
import 'tela_nova_atividade.dart';
import 'app_data.dart';

class TelaHome extends StatefulWidget {
  final String nomeCrianca;
  final String idCrianca;

  const TelaHome({
    super.key,
    required this.nomeCrianca,
    required this.idCrianca,
  });

  @override
  State<TelaHome> createState() => _TelaHomeState();
}

class _TelaHomeState extends State<TelaHome> {
  String get nomeCrianca => AppData.nomeCrianca;

  String get idCrianca => AppData.idCrianca;

  String get escola => AppData.escola;

  String get emergencia => AppData.emergencia;

  String get observacoes => AppData.observacoes;

  String get idade => AppData.idade;

  String get genero => AppData.genero;

  Uint8List? get fotoPerfil => AppData.fotoPerfil;

  List<Atividade> get atividades => AppData.atividades;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      bottomNavigationBar: const Navbar(currentIndex: 0),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(24),

                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1976D2), Color(0xFFD6E8F7)],

                    begin: Alignment.topCenter,

                    end: Alignment.bottomCenter,
                  ),
                ),

                child: Column(
                  children: [
                    // TOPO
                    Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        children: [
                          // Aqui está a logo ajustada
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () async {
                              final confirmar = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Confirmar saída'),
                                    content: const Text(
                                      'Deseja realmente sair?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancelar'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Sair'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirmar == true) {
                                Navigator.pushReplacementNamed(context, '/');
                              }
                            },
                            child: const Text(
                              'Sair',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // FOTO PERFIL
                    GestureDetector(
                      onTap: () async {
                        final resultado = await Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (context) => TelaPerfil(
                              nome: nomeCrianca,

                              idade: idade,

                              genero: genero,

                              escola: escola,

                              emergencia: emergencia,

                              observacoes: observacoes,

                              foto: fotoPerfil,
                            ),
                          ),
                        );

                        if (resultado != null) {
                          setState(() {
                            AppData.nomeCrianca = resultado['nome'];

                            AppData.idade = resultado['idade'];

                            AppData.genero = resultado['genero'];

                            AppData.escola = resultado['escola'];

                            AppData.emergencia = resultado['emergencia'];

                            AppData.observacoes = resultado['observacoes'];

                            AppData.fotoPerfil = resultado['foto'];
                          });
                        }
                      },

                      child: Container(
                        width: 140,
                        height: 140,

                        decoration: BoxDecoration(
                          color: Colors.white,

                          shape: BoxShape.circle,

                          border: Border.all(color: Colors.white, width: 4),
                        ),

                        child: Stack(
                          alignment: Alignment.center,

                          children: [
                            fotoPerfil != null
                                ? ClipOval(
                                    child: Image.memory(
                                      fotoPerfil!,

                                      width: 140,

                                      height: 140,

                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,

                                    size: 70,

                                    color: Colors.grey,
                                  ),

                            Positioned(
                              bottom: 5,
                              right: 5,

                              child: Container(
                                padding: const EdgeInsets.all(6),

                                decoration: const BoxDecoration(
                                  color: Colors.blue,

                                  shape: BoxShape.circle,
                                ),

                                child: const Icon(
                                  Icons.edit,

                                  color: Colors.white,

                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // NOME
                    Text(
                      nomeCrianca,

                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        fontSize: 30,

                        color: Colors.white,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ID
                    Text(
                      idCrianca,

                      style: const TextStyle(
                        fontSize: 20,

                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 35),

                    // ROTINA DE HOJE
                    Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text(
                            'Rotina de hoje',

                            style: TextStyle(
                              fontSize: 24,

                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),

                          atividades.isEmpty
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 30),

                                    child: Text(
                                      'Nenhuma atividade cadastrada',

                                      style: TextStyle(
                                        fontSize: 18,

                                        color: Colors.grey,

                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                              : Column(
                                  children: atividades.map((atividade) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 15),

                                      padding: const EdgeInsets.all(16),

                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F7FA),

                                        borderRadius: BorderRadius.circular(16),
                                      ),

                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),

                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade100,

                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),

                                            child: Icon(
                                              atividade.categoria == 'Sono'
                                                  ? Icons.bed
                                                  : atividade.categoria ==
                                                        'Alimentação'
                                                  ? Icons.restaurant
                                                  : atividade.categoria ==
                                                        'Estudos'
                                                  ? Icons.menu_book
                                                  : atividade.categoria ==
                                                        'Lazer'
                                                  ? Icons.sports_esports
                                                  : atividade.categoria ==
                                                        'Medicação'
                                                  ? Icons.medication
                                                  : Icons.task,

                                              color: Colors.blue,
                                            ),
                                          ),

                                          const SizedBox(width: 15),

                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,

                                              children: [
                                                Text(
                                                  atividade.nome,

                                                  style: const TextStyle(
                                                    fontSize: 18,

                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),

                                                const SizedBox(height: 5),

                                                Text(
                                                  '${atividade.inicio} - ${atividade.fim}',

                                                  style: const TextStyle(
                                                    color: Colors.grey,

                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // BOTÕES
                    Row(
                      children: [
                        Expanded(
                          child: botaoHome(
                            icone: Icons.add,

                            texto: 'Nova atividade',

                            onTap: () async {
                              final novaAtividade = await Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NovaAtividadeScreen(),
                                ),
                              );

                              if (novaAtividade != null) {
                                setState(() {
                                  AppData.atividades.add(novaAtividade);
                                });
                              }
                            },
                          ),
                        ),

                        const SizedBox(width: 20),

                        Expanded(
                          child: botaoHome(
                            icone: Icons.calendar_month,

                            texto: 'Rotina Semanal',

                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Tela Rotina Semanal em desenvolvimento',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // ATIVIDADES CONCLUÍDAS
                    const Align(
                      alignment: Alignment.centerLeft,

                      child: Text(
                        'Atividades concluídas',

                        style: TextStyle(
                          fontSize: 28,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(25),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: const Center(
                        child: Text(
                          'Nenhuma atividade concluída',

                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // BOTÃO HOME
  Widget botaoHome({
    required IconData icone,

    required String texto,

    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 130,

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(20),

          boxShadow: const [
            BoxShadow(
              color: Colors.black12,

              blurRadius: 8,

              offset: Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icone, size: 45),

            const SizedBox(height: 12),

            Text(
              texto,

              textAlign: TextAlign.center,

              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
