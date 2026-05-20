import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final int currentIndex;

  const Navbar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,

      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black54,

      type: BottomNavigationBarType.fixed,

      onTap: (index) {
        if (index == currentIndex) return;

        switch (index) {
          // HOME
          case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;

          // ROTINA
          case 1:
            Navigator.pushReplacementNamed(context, '/rotina');
            break;

          // HISTÓRICO
          case 2:
            Navigator.pushReplacementNamed(context, '/historico');
            break;

          // CONFIGURAÇÕES
          case 3:
            Navigator.pushReplacementNamed(context, '/configuracoes');
            break;
        }
      },

      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Rotina',
        ),

        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Histórico'),

        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Config'),
      ],
    );
  }
}
