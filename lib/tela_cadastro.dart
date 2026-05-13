import 'package:flutter/material.dart';

class TelaCadastro extends StatelessWidget {
  const TelaCadastro({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(24),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.center,

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

              // LOGO
              Align(

                alignment: Alignment.topRight,

                child: Container(

                  width: 65,
                  height: 65,

                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),

                  child: ClipOval(

                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
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
              campoTexto(
                texto: 'Email',
              ),

              const SizedBox(height: 20),

              // SENHA
              campoTexto(
                texto: 'Senha',
                senha: true,
              ),

              const SizedBox(height: 8),

              // TEXTO EXPLICATIVO
              const Align(

                alignment: Alignment.centerLeft,

                child: Text(

                  'A senha deve conter:\n'
                  '• 2 letras\n'
                  '• até 4 números',

                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // CONFIRMAR SENHA
              campoTexto(
                texto: 'Confirmar senha',
                senha: true,
              ),

              const SizedBox(height: 20),

              // RESPONSÁVEL 1
              campoTexto(
                texto: 'Nome do responsável',
              ),

              const SizedBox(height: 20),

              // RESPONSÁVEL 2
              campoTexto(
                texto: 'Segundo responsável (Opcional)',
              ),

              const SizedBox(height: 20),

              // CRIANÇA
              campoTexto(
                texto: 'Nome da criança',
              ),

              const SizedBox(height: 40),

              // BOTÃO
              SizedBox(

                width: double.infinity,
                height: 60,

                child: ElevatedButton(

                  onPressed: () {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(

                      const SnackBar(

                        content: Text(
                          'Conta criada com sucesso!',
                        ),
                      ),
                    );
                  },

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

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // CAMPO PERSONALIZADO
  Widget campoTexto({

    required String texto,
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

          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

