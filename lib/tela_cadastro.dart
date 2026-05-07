import 'package:flutter/material.dart';

class TelaCadastro extends StatelessWidget {
  const TelaCadastro({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding: const EdgeInsets.all(24),

            child: Column(

              children: [

                // BOTÃO VOLTAR
                Align(

                  alignment: Alignment.topLeft,

                  child: IconButton(

                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(Icons.arrow_back),
                  ),
                ),

                const SizedBox(height: 10),

                // TÍTULO
                const Text(

                  'Criar Conta',

                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                // EMAIL
                campoTexto('EMAIL'),

                espacamento(),

                // SENHA
                campoTexto(
                  'SENHA',
                  senha: true,
                ),

                espacamento(),

                // CONFIRMAR SENHA
                campoTexto(
                  'CONFIRMAR SENHA',
                  senha: true,
                ),

                espacamento(),

                // RESPONSÁVEL 1
                campoTexto('RESPONSÁVEL 1'),

                espacamento(),

                // RESPONSÁVEL 2
                campoTexto(
                  'RESPONSÁVEL 2 (Opcional)',
                ),

                espacamento(),

                // CRIANÇA
                campoTexto('NOME DA CRIANÇA'),

                const SizedBox(height: 40),

                // BOTÃO
                SizedBox(

                  width: double.infinity,
                  height: 60,

                  child: ElevatedButton(

                    onPressed: () {},

                    style:
                        ElevatedButton.styleFrom(

                      backgroundColor:
                          const Color(0xFF4E8FE8),

                      shape: RoundedRectangleBorder(

                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                    ),

                    child: const Text(

                      'CRIAR CONTA',

                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget espacamento() {

    return const SizedBox(height: 20);
  }

  Widget campoTexto(
    String texto, {
    bool senha = false,
  }) {

    return TextField(

      obscureText: senha,

      decoration: InputDecoration(

        hintText: texto,

        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(16),
        ),
      ),
    );
  }
}