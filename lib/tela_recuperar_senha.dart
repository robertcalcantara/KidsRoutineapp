import 'package:flutter/material.dart';

class TelaRecuperarSenha
    extends StatelessWidget {

  const TelaRecuperarSenha({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(

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

              const SizedBox(height: 20),

              // TÍTULO
              const Text(

                'Recuperar Senha',

                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 50),

              // CAMPO EMAIL
              TextField(

                decoration: InputDecoration(

                  hintText: 'Digite seu email',

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(

                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),
              ),

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

                    'RECUPERAR SENHA',

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
    );
  }
}