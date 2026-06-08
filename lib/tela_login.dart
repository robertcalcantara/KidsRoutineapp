import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'app_data.dart';
import 'tela_home.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController senhaController = TextEditingController();

  bool carregando = false;

  Future<void> fazerLogin() async {
    String email = emailController.text.trim();

    String senha = senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha email e senha')),
      );

      return;
    }

    // LOGIN DEV PARA TESTES
    if (email == 'dev@kidsroutine.com' && senha == 'dev123') {
      AppData.nomeCrianca = 'Kid';
      AppData.idCrianca = '#0000';

      Navigator.pushReplacement(
        context,

        MaterialPageRoute(
          builder: (context) => const TelaHome(
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

    try {
      final credencial = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final nomeCrianca = credencial.user?.displayName;

      AppData.nomeCrianca =
          nomeCrianca == null || nomeCrianca.isEmpty ? 'Perfil Teste' : nomeCrianca;
      AppData.idCrianca = '#${credencial.user?.uid.substring(0, 4) ?? '0000'}';

      if (!mounted) return;

      Navigator.pushReplacement(
        context,

        MaterialPageRoute(
          builder: (context) => TelaHome(
            nomeCrianca: AppData.nomeCrianca,
            idCrianca: AppData.idCrianca,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String mensagem = 'Erro ao fazer login';

      switch (e.code) {
        case 'invalid-email':
          mensagem = 'Email inválido';
          break;

        case 'user-not-found':
          mensagem = 'Email não encontrado';
          break;

        case 'wrong-password':
          mensagem = 'Senha incorreta';
          break;

        case 'invalid-credential':
          mensagem = 'Email ou senha incorretos';
          break;

        case 'user-disabled':
          mensagem = 'Usuário desativado';
          break;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            children: [
              const SizedBox(height: 20),

              // LOGO
              Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  width: 80, // Tamanho ajustado para melhor visibilidade
                  height: 80,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // IMAGEM
              Image.asset('assets/images/family.png', height: 250),

              const SizedBox(height: 30),

              // TÍTULO
              const Text(
                'Login',

                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 40),

              // EMAIL
              campoTexto(controller: emailController, texto: 'Email'),

              const SizedBox(height: 20),

              // SENHA
              campoTexto(
                controller: senhaController,

                texto: 'Senha',

                senha: true,
              ),

              const SizedBox(height: 10),

              // ESQUECI SENHA
              Align(
                alignment: Alignment.centerRight,

                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/recuperar-senha');
                  },

                  child: const Text('Esqueci minha senha'),
                ),
              ),

              const SizedBox(height: 20),

              // BOTÃO LOGIN
              SizedBox(
                width: double.infinity,
                height: 60,

                child: ElevatedButton(
                  onPressed: carregando ? null : fazerLogin,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4E8FE8),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  child: carregando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'ENTRAR',

                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // CRIAR CONTA
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/cadastro');
                },

                child: const Text(
                  'Criar nova conta',

                  style: TextStyle(fontSize: 16),
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

      keyboardType: senha ? TextInputType.text : TextInputType.emailAddress,

      decoration: InputDecoration(
        hintText: texto,

        filled: true,

        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),

          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
