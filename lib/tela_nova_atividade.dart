import 'package:flutter/material.dart';
import 'atividade.dart';

class NovaAtividadeScreen extends StatefulWidget {
  const NovaAtividadeScreen({super.key});

  @override
  State<NovaAtividadeScreen> createState() =>
      _NovaAtividadeScreenState();
}

class _NovaAtividadeScreenState
    extends State<NovaAtividadeScreen> {

  final TextEditingController _nomeController =
      TextEditingController();

  final TextEditingController
      _inicioHoraController =
      TextEditingController(text: '08:00');

  final TextEditingController
      _inicioMinController =
      TextEditingController(text: '09:00');

  final TextEditingController
      _fimHoraController =
      TextEditingController(text: '09:00');

  final TextEditingController
      _fimMinController =
      TextEditingController(text: '10:00');

  String _categoriaSelecionada =
      'Alimentação';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // HEADER
              Row(
                children: [

                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                    ),

                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(width: 8),

                  const Text(
                    'NOVA ATIVIDADE',

                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // NOME
              const Text(
                'Nome da atividade',

                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: _nomeController,

                decoration: InputDecoration(
                  hintText: 'Ex: Almoço',

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),

                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // HORÁRIO INÍCIO
              const Text(
                'Horário Início',

                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [

                  Expanded(
                    child: _buildTimeField(
                      _inicioHoraController,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: _buildTimeField(
                      _inicioMinController,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // HORÁRIO FIM
              const Text(
                'Horário Fim',

                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [

                  Expanded(
                    child: _buildTimeField(
                      _fimHoraController,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: _buildTimeField(
                      _fimMinController,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // CATEGORIAS
              const Text(
                'Categoria',

                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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

              // BOTÕES
              Row(
                children: [

                  // SALVAR
                  Expanded(
                    child: ElevatedButton(

                      onPressed: () {

                        if (_nomeController
                            .text
                            .isEmpty) {

                          ScaffoldMessenger.of(
                                  context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Digite o nome da atividade',
                              ),
                            ),
                          );

                          return;
                        }

                        final novaAtividade =
                            Atividade(
                          nome:
                              _nomeController.text,

                          inicio:
                              _inicioHoraController
                                  .text,

                          fim:
                              _fimHoraController
                                  .text,

                          categoria:
                              _categoriaSelecionada,
                        );

                        Navigator.pop(
                          context,
                          novaAtividade,
                        );
                      },

                      style: ElevatedButton
                          .styleFrom(
                        backgroundColor:
                            const Color(
                                0xFF4A90E2),

                        padding:
                            const EdgeInsets
                                .symmetric(
                          vertical: 16,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                                      12),
                        ),
                      ),

                      child: const Text(
                        'Salvar',

                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // CANCELAR
                  Expanded(
                    child: OutlinedButton(

                      onPressed: () {
                        Navigator.pop(context);
                      },

                      style:
                          OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          vertical: 16,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                                      12),
                        ),
                      ),

                      child: const Text(
                        'Cancelar',

                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
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

  // CAMPO HORÁRIO
  Widget _buildTimeField(
      TextEditingController controller) {

    return TextField(
      controller: controller,

      textAlign: TextAlign.center,

      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
        ),

        contentPadding:
            const EdgeInsets.symmetric(
          vertical: 14,
        ),
      ),
    );
  }

  // BOTÃO CATEGORIA
  Widget _buildCategoryButton(
    String label,
    String emoji,
    Color backgroundColor,
    Color textColor,
  ) {

    final isSelected =
        _categoriaSelecionada == label;

    return InkWell(
      onTap: () {

        setState(() {
          _categoriaSelecionada = label;
        });
      },

      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 150),

        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),

        decoration: BoxDecoration(
          color: backgroundColor,

          borderRadius:
              BorderRadius.circular(12),

          border: Border.all(
            color: isSelected
                ? Colors.black
                : Colors.transparent,
            width: 2,
          ),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,

          children: [

            Text(
              emoji,
              style:
                  const TextStyle(fontSize: 18),
            ),

            const SizedBox(width: 6),

            Text(
              label,

              style: TextStyle(
                color: textColor,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}