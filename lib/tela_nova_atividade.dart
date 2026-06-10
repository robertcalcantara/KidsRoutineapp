import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NovaAtividadeScreen extends StatefulWidget {
  const NovaAtividadeScreen({super.key});

  @override
  State<NovaAtividadeScreen> createState() => _NovaAtividadeScreenState();
}

class _NovaAtividadeScreenState extends State<NovaAtividadeScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _inicioHoraController = TextEditingController();
  final TextEditingController _inicioMinController = TextEditingController();
  final TextEditingController _fimHoraController = TextEditingController();
  final TextEditingController _fimMinController = TextEditingController();

  String _categoriaSelecionada = 'Alimentação';
  DateTime _dataSelecionada = DateTime.now();

  @override
  void dispose() {
    _nomeController.dispose();
    _inicioHoraController.dispose();
    _inicioMinController.dispose();
    _fimHoraController.dispose();
    _fimMinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'NOVA ATIVIDADE',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Nome da atividade',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  hintText: 'Ex: Almoço',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Data da atividade',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: _selecionarData,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatarData(_dataSelecionada),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.calendar_month),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Horário Início',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildTimeField(
                      controller: _inicioHoraController,
                      hint: 'Hora',
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildTimeField(
                      controller: _inicioMinController,
                      hint: 'Minuto',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              const Text(
                'Horário Fim',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildTimeField(
                      controller: _fimHoraController,
                      hint: 'Hora',
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildTimeField(
                      controller: _fimMinController,
                      hint: 'Minuto',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Categoria',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildCategoryButton(
                    'Alimentação',
                    '🍲',
                    const Color(0xFFF7F433),
                    Colors.black,
                  ),
                  _buildCategoryButton(
                    'Sono',
                    '🌙',
                    const Color(0xFF6342F7),
                    Colors.white,
                  ),
                  _buildCategoryButton(
                    'Estudos',
                    '📚',
                    const Color(0xFF4CFF5C),
                    Colors.black,
                  ),
                  _buildCategoryButton(
                    'Lazer',
                    '🎮',
                    const Color(0xFF29E7FA),
                    Colors.black,
                  ),
                  _buildCategoryButton(
                    'Medicação',
                    '💊',
                    const Color(0xFFFF3333),
                    Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _salvarAtividade,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90E2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Salvar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (data != null) {
      setState(() {
        _dataSelecionada = data;
      });
    }
  }

  Future<void> _salvarAtividade() async {
  if (_nomeController.text.trim().isEmpty) {
    _mostrarMensagem('Digite o nome da atividade');
    return;
  }

  final inicio = _montarHorario(
    horaTexto: _inicioHoraController.text,
    minutoTexto: _inicioMinController.text,
    label: 'início',
  );

  if (inicio == null) return;

  final fim = _montarHorario(
    horaTexto: _fimHoraController.text,
    minutoTexto: _fimMinController.text,
    label: 'fim',
  );

  if (fim == null) return;

  try {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      _mostrarMensagem('Usuário não autenticado. Faça login novamente.');
      return;
    }

    await FirebaseFirestore.instance.collection('atividades').add({
      'nome': _nomeController.text.trim(),
      'categoria': _categoriaSelecionada,
      'inicio': inicio,
      'fim': fim,
      'data': Timestamp.fromDate(_dataSelecionada),
      'concluida': false,
      'concluidaEm': null,
      'criadoEm': FieldValue.serverTimestamp(),

      // Campos de segurança para separar as atividades por conta.
      // O app consulta pelo uid, então uma conta não vê atividades da outra.
      'uid': usuario.uid,
      'usuario_logado': usuario.email ?? '',
      'childId': 'perfil',
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Atividade salva no Firebase'),
        ),
      );

      Navigator.pop(context);
    }
  } catch (e) {
    _mostrarMensagem('Erro ao salvar: $e');
  }
}

  String? _montarHorario({
    required String horaTexto,
    required String minutoTexto,
    required String label,
  }) {
    if (horaTexto.trim().isEmpty) {
      _mostrarMensagem('Digite a hora de $label');
      return null;
    }

    final hora = int.tryParse(horaTexto.trim());
    final minuto = minutoTexto.trim().isEmpty
        ? 0
        : int.tryParse(minutoTexto.trim());

    if (hora == null || hora < 0 || hora > 23) {
      _mostrarMensagem('Hora de $label inválida');
      return null;
    }

    if (minuto == null || minuto < 0 || minuto > 59) {
      _mostrarMensagem('Minuto de $label inválido');
      return null;
    }

    return '${hora.toString().padLeft(2, '0')}:${minuto.toString().padLeft(2, '0')}';
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  Widget _buildTimeField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(2),
      ],
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }

  Widget _buildCategoryButton(
    String label,
    String emoji,
    Color backgroundColor,
    Color textColor,
  ) {
    final isSelected = _categoriaSelecionada == label;

    return InkWell(
      onTap: () {
        setState(() {
          _categoriaSelecionada = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
