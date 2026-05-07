import 'package:flutter/material.dart';

import 'storage_service.dart';
import 'tela_home.dart';

class TelaLogin extends StatefulWidget {

  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() =>
      _TelaLoginState();
}

class _TelaLoginState
    extends State<TelaLogin> {

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController senhaController =
      TextEditingController();

  bool carregando = false;

  Future<void> fazerLogin() async {

    // LOGIN DEV
    if (

      emailController.text.trim() ==
          'dev@kidsroutine.com' &&

      senhaController.text.trim() ==
          'dev123'
    ) {

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (context) =>
              const TelaHome(

            nomeCrianca: 'Kid',

            idCrianca: '#0000',
          ),
        ),
      );

      return;
    }

    setState(() {
      carregando = true;
    });

    String email =
        emailController.text.trim();

    String senha =
        senhaController.text.trim();

    // BUSCAR USUÁRIO
    final usuario =
        await StorageService.buscarUsuario(
      email,
    );

    // EMAIL NÃO EXISTE
    if (usuario == null) {

      setState(() {
        carregando = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            'Email não encontrado',
          ),
        ),
      );

      return;
    }

    // SENHA ERRADA
    if (usuario['senha'] != senha) {

      setState(() {
        carregando = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            'Senha incorreta',
          ),
        ),
      );

      return;
    }

    // LOGIN CORRETO
    setState(() {
      carregando = false;
    });

    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder: (context) => TelaHome(

          nomeCrianca:
              usuario['crianca'],

          idCrianca:
              usuario['idCrianca'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFF5F5F5),

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
              const EdgeInsets.all(24),

          child: Column(

            children: [

              const SizedBox(height: 20),

              // LOGO
              Align(

                alignment: Alignment.topRight,

                child: Container(

                  width: 65,
                  height: 65,

                  decoration:
                      const BoxDecoration(

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

              const SizedBox(height: 30),

              // IMAGEM
              Image.asset(
                'assets/images/family.png',
                height: 250,
              ),

              const SizedBox(height: 30),

              // TÍTULO
              const Text(

                'Login',

                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              // EMAIL
              campoTexto(

                controller:
                    emailController,

                texto: 'Email',
              ),

              const SizedBox(height: 20),

              // SENHA
              campoTexto(

                controller:
                    senhaController,

                texto: 'Senha',

                senha: true,
              ),

              const SizedBox(height: 10),

              // ESQUECI SENHA
              Align(

                alignment:
                    Alignment.centerRight,

                child: TextButton(

                  onPressed: () {

                    Navigator.pushNamed(
                      context,
                      '/recuperar-senha',
                    );
                  },

                  child: const Text(
                    'Esqueci minha senha',
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // BOTÃO LOGIN
              SizedBox(

                width: double.infinity,
                height: 60,

                child: ElevatedButton(

                  onPressed:
                      carregando
                          ? null
                          : fazerLogin,

                  style:
                      ElevatedButton.styleFrom(

                    backgroundColor:
                        const Color(
                            0xFF4E8FE8),

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(
                              16),
                    ),
                  ),

                  child:
                      carregando
                          ? const CircularProgressIndicator(
                              color:
                                  Colors.white,
                            )
                          : const Text(

                              'ENTRAR',

                              style: TextStyle(
                                fontSize: 22,
                                color:
                                    Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                ),
              ),

              const SizedBox(height: 20),

              // CRIAR CONTA
              TextButton(

                onPressed: () {

                  Navigator.pushNamed(
                    context,
                    '/cadastro',
                  );
                },

                child: const Text(

                  'Criar nova conta',

                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // CAMPO PERSONALIZADO
  Widget campoTexto({

    required TextEditingController controller,

    required String texto,

    bool senha = false,
  }) {

    return TextField(

      controller: controller,

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