import 'package:flutter/material.dart';

class TelaAjudaSuporte extends StatelessWidget {
  const TelaAjudaSuporte({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        iconTheme: const IconThemeData(color: Colors.black),

        title: const Text(
          'Ajuda e Suporte',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            _item(
              context,
              Icons.question_answer,
              'Perguntas Frequentes',
              _faqDialog,
            ),

            _linha(),

            _item(
              context,
              Icons.menu_book,
              'Como Utilizar o App',
              _manualDialog,
            ),

            _linha(),

            _item(context, Icons.email, 'Contato do Suporte', _contatoDialog),

            _linha(),

            _item(
              context,
              Icons.info_outline,
              'Sobre o Aplicativo',
              _sobreDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _linha() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 1,
      color: Colors.black26,
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String texto,
    Function(BuildContext) onTap,
  ) {
    return ListTile(
      leading: Icon(icon, size: 30),

      title: Text(
        texto,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),

      trailing: const Icon(Icons.chevron_right),

      onTap: () => onTap(context),
    );
  }

  void _faqDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Perguntas Frequentes'),

        content: const SingleChildScrollView(
          child: Text(
            '• Como cadastrar uma atividade?\n'
            'Clique em "Nova Atividade".\n\n'
            '• Como marcar uma atividade como concluída?\n'
            'Utilize a caixa de seleção na tela Rotina.\n\n'
            '• Como editar informações da criança?\n'
            'Acesse o perfil pela tela inicial.',
          ),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _manualDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Como Utilizar o App'),

        content: const Text(
          '1. Cadastre atividades.\n\n'
          '2. Acompanhe a rotina diária.\n\n'
          '3. Marque atividades concluídas.\n\n'
          '4. Consulte o histórico e informações da criança.',
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _contatoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Contato do Suporte'),

        content: const Text(
          'Email:\n'
          'suporte@kidsroutine.com\n\n'
          'Telefone:\n'
          '(79) 99999-9999',
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _sobreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sobre o Aplicativo'),

        content: const Text(
          'Kids Routine\n\n'
          'Versão 1.0\n\n'
          'Aplicativo desenvolvido para facilitar a comunicação entre pais e escolas, permitindo o acompanhamento da rotina infantil.',
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
