import 'package:flutter/material.dart';
import 'app_data.dart';
import 'child_service.dart';

class TelaPreferenciasConta extends StatefulWidget {
  const TelaPreferenciasConta({super.key});

  @override
  State<TelaPreferenciasConta> createState() => _TelaPreferenciasContaState();
}

class _TelaPreferenciasContaState extends State<TelaPreferenciasConta> {
  late TextEditingController nomeController;
  late TextEditingController escolaController;
  bool salvando = false;

  @override
  void initState() {
    super.initState();
    nomeController   = TextEditingController(text: AppData.nomeCrianca);
    escolaController = TextEditingController(text: AppData.escola);
  }

  @override
  void dispose() {
    nomeController.dispose();
    escolaController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    setState(() => salvando = true);

    try {
      // Atualiza cache local
      AppData.nomeCrianca = nomeController.text.trim();
      AppData.escola      = escolaController.text.trim();

      // Persiste no Firestore (merge: true — não apaga outros campos)
      await ChildService.salvarPerfil({
        'nome':   AppData.nomeCrianca,
        'escola': AppData.escola,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dados atualizados com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preferências da Conta'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome da Criança'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: escolaController,
              decoration: const InputDecoration(labelText: 'Escola'),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: salvando ? null : _salvar,
                child: salvando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Salvar'),
              ),
            ),
            const SizedBox(height: 40),
            const ListTile(
              leading: Icon(Icons.info),
              title: Text('Versão'),
              subtitle: Text('Kids Routine v1.0'),
            ),
          ],
        ),
      ),
    );
  }
}