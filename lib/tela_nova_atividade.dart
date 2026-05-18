import 'package:flutter/material.dart';

class NovaAtividadeScreen extends StatefulWidget {
  const NovaAtividadeScreen({super.key});

  @override
  State<NovaAtividadeScreen> createState() => _NovaAtividadeScreenState();
}

class _NovaAtividadeScreenState extends State<NovaAtividadeScreen> {
  final TextEditingController _nomeController = TextEditingController();
  
  // Ajustado os valores padrão para bater com o layout da imagem (Hora e Minuto separados)
  final TextEditingController _inicioHoraController = TextEditingController(text: '08:00');
  final TextEditingController _inicioMinController = TextEditingController(text: '09:00');
  final TextEditingController _fimHoraController = TextEditingController(text: '09:00');
  final TextEditingController _fimMinController = TextEditingController(text: '02:00');

  // Controle da categoria selecionada (Repetição)
  String _categoriaSelecionada = 'Alimentação';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com botão voltar e título
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 24),
                    onPressed: () {
                      Navigator.pop(context); // Volta para a tela anterior (Home)
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'NOVA ATIVIDADE',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Nome da Atividade
              const Text(
                'Nome da atividade',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  hintText: 'ex: Almoço',
                  hintStyle: const TextStyle(color: Colors.black38),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Horário Início
              const Text(
                'Horário Início',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildTimeField(_inicioHoraController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTimeField(_inicioMinController)),
                ],
              ),
              const SizedBox(height: 20),

              // Horário Fim
              const Text(
                'Horário Fim',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildTimeField(_fimHoraController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTimeField(_fimMinController)),
                ],
              ),
              const SizedBox(height: 24),

              // Seção de Repetição / Categorias
              const Text(
                'Repetição',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 12),

              // Grid dinâmico dos botões de categoria
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildCategoryButton('Alimentação', '🍲', const Color(0xFFF7F433), Colors.black),
                  _buildCategoryButton('Sono', '🌙', const Color(0xFF6342F7), Colors.white),
                  _buildCategoryButton('Estudos', '📚', const Color(0xFF4CFF5C), Colors.black),
                  _buildCategoryButton('Lazer', '🎮', const Color(0xFF29E7FA), Colors.black),
                  _buildCategoryButton('Medicação', '💊', const Color(0xFFFF3333), Colors.white),
                ],
              ),
              const SizedBox(height: 48),

              // Botões inferiores (Salvar e Cancelar)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Código para salvar a atividade futuramente
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90E2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Salvar',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); // Cancela e volta para a Home
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.black54, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
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

  // Helper para construir os inputs de hora
  Widget _buildTimeField(TextEditingController controller) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black26),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black26),
        ),
      ),
    );
  }

  // Helper para construir os botões de categoria com mudança de estado sutil
  Widget _buildCategoryButton(String label, String emoji, Color backgroundColor, Color textColor) {
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
          // Aplica uma borda preta nítida quando selecionado, respeitando o estilo da imagem original
          border: Border.all(
            color: isSelected ? Colors.black87 : Colors.transparent, 
            width: 2,
          ),
          boxShadow: isSelected ? [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))] : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}