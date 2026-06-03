import 'package:flutter/material.dart';
import 'widgets/navbar.dart';

class TelaConfiguracoes extends StatelessWidget {
  const TelaConfiguracoes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      bottomNavigationBar: const Navbar(currentIndex: 3),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // TOPO
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 45),

                  const Text(
                    'Configurações',
                    style: TextStyle(
                      fontSize: 33,
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

              const SizedBox(height: 55),

              // PREFERÊNCIAS DA CONTA
              _itemConfiguracao(
                icon: Icons.groups,
                texto: 'Preferências da Conta',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Tela Preferências da Conta em desenvolvimento',
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              _linha(),

              const SizedBox(height: 10),

              // NOTIFICAÇÕES
              _itemConfiguracao(
                icon: Icons.notifications,
                texto: 'Notificações',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tela Notificações em desenvolvimento'),
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              _linha(),

              const SizedBox(height: 10),

              // AJUDA E SUPORTE
              _itemConfiguracao(
                icon: Icons.help_outline,
                texto: 'Ajuda e Suporte',
                onTap: () {
                  Navigator.pushNamed(context, '/ajuda-suporte');
                },
              ),

              const SizedBox(height: 10),

              _linha(),

              const Spacer(),

              // BOTÃO SAIR
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB3B3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.red, width: 1),
                  ),
                  child: const Center(
                    child: Text(
                      'Sair',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _linha() {
    return Container(width: double.infinity, height: 1, color: Colors.black54);
  }

  Widget _itemConfiguracao({
    required IconData icon,
    required String texto,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 38, color: Colors.black),

          const SizedBox(width: 18),

          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
          ),

          const Icon(Icons.chevron_right, size: 36, color: Colors.black),
        ],
      ),
    );
  }
}
