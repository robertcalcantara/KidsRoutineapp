import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'widgets/navbar.dart';
import 'Tela_perfil.dart';

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
  late String nomeCrianca;
  late String idCrianca;

  String escola = "Escola UNIT";
  String emergencia = "Mãe (79) 98888-7777";
  String observacoes = "ALÉRGICA A Farofa";
  String idade = "3";
  String genero = "feminino";

  Uint8List? fotoPerfil;

  @override
  void initState() {
    super.initState();

    nomeCrianca = widget.nomeCrianca;
    idCrianca = widget.idCrianca;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      bottomNavigationBar: const Navbar(
        currentIndex: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),

                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1976D2),
                      Color(0xFFD6E8F7),
                    ],
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

                          // LOGO
                          Container(
                            width: 58,
                            height: 58,

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(100),
                            ),

                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(100),

                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // BOTÃO SAIR
                          GestureDetector(
                            onTap: () async {

                              final confirmar =
                                  await showDialog<bool>(
                                context: context,

                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Confirmar saída',
                                    ),

                                    content: const Text(
                                      'Deseja realmente sair?',
                                    ),

                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                            context,
                                            false,
                                          );
                                        },

                                        child: const Text(
                                          'Cancelar',
                                        ),
                                      ),

                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(
                                            context,
                                            true,
                                          );
                                        },

                                        child: const Text(
                                          'Sair',
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirmar == true) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/',
                                );
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
                        final resultado =
                            await Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (context) =>
                                TelaPerfil(
                              nome: nomeCrianca,
                              idade: idade,
                              genero: genero,
                              escola: escola,
                              emergencia: emergencia,
                              observacoes:
                                  observacoes,
                              foto: fotoPerfil,
                            ),
                          ),
                        );

                        if (resultado != null) {
                          setState(() {
                            nomeCrianca =
                                resultado['nome'];

                            idade =
                                resultado['idade'];

                            genero =
                                resultado['genero'];

                            escola =
                                resultado['escola'];

                            emergencia = resultado[
                                'emergencia'];

                            observacoes = resultado[
                                'observacoes'];

                            fotoPerfil =
                                resultado['foto'];
                          });
                        }
                      },

                      child: Container(
                        width: 140,
                        height: 140,

                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,

                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                        ),

                        child: Stack(
                          alignment: Alignment.center,

                          children: [
                            fotoPerfil != null
                                ? ClipOval(
                                    child:
                                        Image.memory(
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
                                padding:
                                    const EdgeInsets
                                        .all(6),

                                decoration:
                                    const BoxDecoration(
                                  color: Colors.blue,
                                  shape:
                                      BoxShape.circle,
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

                    // ROTINA DO DIA
                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(20),
                      ),

                      child: const Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Text(
                            'Rotina de hoje',

                            style: TextStyle(
                              fontSize: 24,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 20),

                          Center(
                            child: Padding(
                              padding:
                                  EdgeInsets.symmetric(
                                      vertical: 30),

                              child: Text(
                                'Nenhuma atividade cadastrada',

                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontWeight:
                                      FontWeight.w500,
                                ),
                              ),
                            ),
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
                            onTap: () {
                              // MODIFICADO: Agora abre a sua nova tela usando a rota cadastrada no main.dart
                              Navigator.pushNamed(context, '/nova-atividade');
                            },
                          ),
                        ),

                        const SizedBox(width: 20),

                        Expanded(
                          child: botaoHome(
                            icone:
                                Icons.calendar_month,
                            texto:
                                'Rotina Semanal',

                            onTap: () {
                              ScaffoldMessenger.of(
                                      context)
                                  .showSnackBar(
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

                    // TÍTULO
                    const Align(
                      alignment:
                          Alignment.centerLeft,

                      child: Text(
                        'Atividades concluídas',

                        style: TextStyle(
                          fontSize: 28,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // VAZIO
                    Container(
                      width: double.infinity,

                      padding:
                          const EdgeInsets.all(25),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(20),
                      ),

                      child: const Center(
                        child: Text(
                          'Nenhuma atividade concluída',

                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ),
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
          borderRadius:
              BorderRadius.circular(20),

          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Icon(
              icone,
              size: 45,
            ),

            const SizedBox(height: 12),

            Text(
              texto,

              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}