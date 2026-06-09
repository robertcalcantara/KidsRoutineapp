import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'widgets/navbar.dart';
import 'tela_perfil.dart';
import 'atividade.dart';
import 'tela_nova_atividade.dart';
import 'tela_rotina.dart';
import 'app_data.dart';

class TelaHome extends StatefulWidget {
  // Mantemos os parâmetros para compatibilidade com a navegação atual,
  // mas os dados reais vêm do AppData (carregado do Firebase no login).
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
  // Lê sempre do AppData (atualizado após salvar no perfil)
  String get nomeCrianca => AppData.nomeCrianca.isNotEmpty ? AppData.nomeCrianca : widget.nomeCrianca;
  String get idCrianca   => AppData.idCrianca.isNotEmpty   ? AppData.idCrianca   : widget.idCrianca;
  String get escola      => AppData.escola;
  String get emergencia  => AppData.emergencia;
  String get observacoes => AppData.observacoes;
  String get idade       => AppData.idade;
  String get genero      => AppData.genero;
  String get fotoUrl     => AppData.fotoUrl;
  Uint8List? get fotoPerfil => AppData.fotoPerfil;

  List<Atividade> get atividades => AppData.atividades;

  List<Atividade> get atividadesHoje => atividades.where((a) {
        final hoje = DateTime.now();
        return a.data.day == hoje.day &&
            a.data.month == hoje.month &&
            a.data.year == hoje.year;
      }).toList();

  List<Atividade> get ultimasConcluidas {
    final lista = atividades.where((a) => a.concluida).toList();
    lista.sort((a, b) {
      final dataA = a.concluidaEm ?? a.data;
      final dataB = b.concluidaEm ?? b.data;
      return dataB.compareTo(dataA);
    });
    return lista.take(3).toList();
  }

  String _formatarData(DateTime data) =>
      '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';

  IconData _iconeCategoria(String categoria) {
    switch (categoria) {
      case 'Sono':        return Icons.bed;
      case 'Alimentação': return Icons.restaurant;
      case 'Estudos':     return Icons.menu_book;
      case 'Lazer':       return Icons.sports_esports;
      case 'Medicação':   return Icons.medication;
      default:            return Icons.task;
    }
  }

  // ─── Imagem do perfil ─────────────────────────────────────────────────────
  Widget _buildFotoPerfil() {
    if (fotoPerfil != null) {
      return ClipOval(
        child: Image.memory(fotoPerfil!, width: 140, height: 140, fit: BoxFit.cover),
      );
    }
    if (fotoUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(fotoUrl, width: 140, height: 140, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.person, size: 70, color: Colors.grey),
        ),
      );
    }
    return const Icon(Icons.person, size: 70, color: Colors.grey);
  }

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
                    // ── TOPO ─────────────────────────────────────────────
                    Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () async {
                              final confirmar = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirmar saída'),
                                  content: const Text('Deseja realmente sair?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('Cancelar'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('Sair'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirmar == true) {
                                AppData.clear();
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

                    // ── FOTO PERFIL ───────────────────────────────────────
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TelaPerfil()),
                        );
                        // Após voltar do perfil, rebuild para mostrar dados atualizados
                        if (mounted) setState(() {});
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
                            _buildFotoPerfil(),
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.edit, color: Colors.white, size: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ── NOME ─────────────────────────────────────────────
                    Text(
                      nomeCrianca,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      idCrianca,
                      style: const TextStyle(fontSize: 20, color: Colors.white70),
                    ),

                    const SizedBox(height: 35),

                    // ── ROTINA DE HOJE ────────────────────────────────────
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
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          atividadesHoje.isEmpty
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 30),
                                    child: Text(
                                      'Nenhuma atividade cadastrada',
                                      style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                )
                              : Column(
                                  children: atividadesHoje.map((atividade) {
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
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Icon(_iconeCategoria(atividade.categoria), color: Colors.blue),
                                          ),
                                          const SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  atividade.nome,
                                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  '${atividade.inicio} - ${atividade.fim}',
                                                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  _formatarData(atividade.data),
                                                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Checkbox(
                                            value: atividade.concluida,
                                            activeColor: Colors.green,
                                            onChanged: (value) {
                                              setState(() {
                                                atividade.concluida = value!;
                                                atividade.concluidaEm = value ? DateTime.now() : null;
                                              });
                                            },
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

                    // ── BOTÕES ────────────────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: botaoHome(
                            icone: Icons.add,
                            texto: 'Nova atividade',
                            onTap: () async {
                              final novaAtividade = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const NovaAtividadeScreen()),
                              );
                              if (novaAtividade != null) {
                                setState(() => AppData.atividades.add(novaAtividade));
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TelaRotina(filtroInicial: 'Semana'),
                                ),
                              ).then((_) => setState(() {}));
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // ── ATIVIDADES CONCLUÍDAS ─────────────────────────────
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Atividades concluídas',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                      child: ultimasConcluidas.isEmpty
                          ? const Center(
                              child: Text(
                                'Nenhuma atividade concluída',
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            )
                          : Column(
                              children: ultimasConcluidas.map((atividade) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F7FA),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(_iconeCategoria(atividade.categoria), color: Colors.green),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              atividade.nome,
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${atividade.inicio} - ${atividade.fim} • ${_formatarData(atividade.data)}',
                                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.check_circle, color: Colors.green),
                                    ],
                                  ),
                                );
                              }).toList(),
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

  Widget botaoHome({required IconData icone, required String texto, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 45),
            const SizedBox(height: 12),
            Text(texto, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}