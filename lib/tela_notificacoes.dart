import 'package:flutter/material.dart';

class TelaNotificacoes extends StatefulWidget {
  const TelaNotificacoes({super.key});

  @override
  State<TelaNotificacoes> createState() => _TelaNotificacoesState();
}

class _TelaNotificacoesState extends State<TelaNotificacoes> {
  bool atividades = true;
  bool alimentacao = true;
  bool sono = true;
  bool medicacao = true;
  bool escola = true;
  bool vibracao = true;
  bool som = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notificações"), centerTitle: true),

      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Lembretes de atividades"),
            value: atividades,
            onChanged: (v) => setState(() => atividades = v),
          ),

          SwitchListTile(
            title: const Text("Alimentação"),
            value: alimentacao,
            onChanged: (v) => setState(() => alimentacao = v),
          ),

          SwitchListTile(
            title: const Text("Sono"),
            value: sono,
            onChanged: (v) => setState(() => sono = v),
          ),

          SwitchListTile(
            title: const Text("Medicação"),
            value: medicacao,
            onChanged: (v) => setState(() => medicacao = v),
          ),

          SwitchListTile(
            title: const Text("Avisos da escola"),
            value: escola,
            onChanged: (v) => setState(() => escola = v),
          ),

          SwitchListTile(
            title: const Text("Vibração"),
            value: vibracao,
            onChanged: (v) => setState(() => vibracao = v),
          ),

          SwitchListTile(
            title: const Text("Som"),
            value: som,
            onChanged: (v) => setState(() => som = v),
          ),
        ],
      ),
    );
  }
}
