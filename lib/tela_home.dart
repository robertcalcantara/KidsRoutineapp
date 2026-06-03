import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'widgets/navbar.dart';
import 'tela_perfil.dart'; // Mantido em minúsculo (padrão do Flutter)
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
  String get genero => AppData.genero;
  Uint8List? get fotoPerfil => AppData.fotoPerfil;
  List<Atividade> get atividades => AppData.atividades;

  // CORREÇÃO AQUI: Agora pegamos a data de nascimento do AppData
  DateTime get dataNascimento => AppData.dataNascimento;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      bottomNavigationBar: const Navbar(currentIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 🔵 CABEÇALHO COM GRADIENTE AZUL
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    // TOPO: Logo e Botão Sair
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final confirmar = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirmar saída'),
                                content: const Text('Deseja realmente sair?'),
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
                              ),
                            );

                            if (confirmar == true) {
                              Navigator.pushReplacementNamed(context, '/');
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              'Sair',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // FOTO DE PERFIL (Clica para abrir/editar o perfil)
                    GestureDetector(
                      onTap: () async {
                        final resultado = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TelaPerfil(
                              nome: nomeCrianca,
                              dataNascimento:
                                  dataNascimento, // ATUALIZADO: Passando DateTime
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
                            AppData.dataNascimento =
                                resultado['dataNascimento']; // ATUALIZADO: Salvando DateTime
                            AppData.genero = resultado['genero'];
                            AppData.escola = resultado['escola'];
                            AppData.emergencia = resultado['emergencia'];
                            AppData.observacoes = resultado['observacoes'];
                            AppData.fotoPerfil = resultado['foto'];
                          });
                        }
                      },
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 8),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            fotoPerfil != null
                                ? ClipOval(
                                    child: Image.memory(
                                      fotoPerfil!,
                                      width: 130,
                                      height: 130,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 65,
                                    color: Colors.grey,
                                  ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // NOME DA CRIANÇA
                    Text(
                      nomeCrianca,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // ID DA CRIANÇA
                    Text(
                      idCrianca,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // ⚪ CORPO DA TELA (Fundo Cinza Claro)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SEÇÃO: ROTINA DE HOJE
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rotina de hoje',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          atividades.isEmpty
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 30),
                                    child: Text(
                                      'Nenhuma atividade cadastrada',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                              : Column(
                                  children: atividades.map((atividade) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F7FA),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              _getIconeCategoria(
                                                atividade.categoria,
                                              ),
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
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  '${atividade.inicio} - ${atividade.fim}',
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
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
                    const SizedBox(height: 20),

                    // BOTÕES DE AÇÃO INTERNOS
                    Row(
                      children: [
                        Expanded(
                          child: _buildBotaoHome(
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
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildBotaoHome(
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
                    const SizedBox(height: 25),

                    // SEÇÃO: ATIVIDADES CONCLUÍDAS
                    const Text(
                      'Atividades concluídas',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Nenhuma atividade concluída',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper para selecionar os ícones das categorias de forma limpa
  IconData _getIconeCategoria(String categoria) {
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

  // Widget do Botão Customizado da Home
  Widget _buildBotaoHome({
    required IconData icone,
    required String texto,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
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
            Icon(icone, size: 38, color: Colors.blue.shade700),
            const SizedBox(height: 8),
            Text(
              texto,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
