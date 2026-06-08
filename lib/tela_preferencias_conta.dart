import 'package:flutter/material.dart';
import 'app_data.dart';

class TelaPreferenciasConta extends StatefulWidget {
  const TelaPreferenciasConta({super.key});

  @override
  State<TelaPreferenciasConta> createState() => _TelaPreferenciasContaState();
}

class _TelaPreferenciasContaState extends State<TelaPreferenciasConta> {
  late TextEditingController nomeController;
  late TextEditingController escolaController;

  @override
  void initState() {
    super.initState();

    nomeController = TextEditingController(text: AppData.nomeCrianca);

    escolaController = TextEditingController(text: AppData.escola);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preferências da Conta"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: "Nome da Criança"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: escolaController,
              decoration: const InputDecoration(labelText: "Escola"),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  AppData.nomeCrianca = nomeController.text;

                  AppData.escola = escolaController.text;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Dados atualizados com sucesso"),
                  ),
                );
              },

              child: const Text("Salvar"),
            ),

            const SizedBox(height: 40),

            const ListTile(
              leading: Icon(Icons.info),
              title: Text("Versão"),
              subtitle: Text("Kids Routine v1.0"),
            ),
          ],
        ),
      ),
    );
  }
}
