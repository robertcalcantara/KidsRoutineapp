import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'app_data.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  final responsavel1Controller = TextEditingController();
  final responsavel2Controller = TextEditingController();
  final criancaController = TextEditingController();

  bool carregando = false;

  static const String dominioPermitido = '@souunit.com.br';

  bool emailInstitucionalValido(String email) {
    return email.toLowerCase().endsWith(dominioPermitido);
  }

  Future<void> criarConta() async {
    if (emailController.text.trim().isEmpty ||
        senhaController.text.trim().isEmpty ||
        confirmarSenhaController.text.trim().isEmpty ||
        criancaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos obrigatórios'),
        ),
      );
      return;
    }

    if (!emailInstitucionalValido(emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Use apenas email institucional @souunit.com.br'),
        ),
      );
      return;
    }

    if (senhaController.text != confirmarSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('As senhas não coincidem'),
        ),
      );
      return;
    }

    try {
      setState(() {
        carregando = true;
      });

      final credencial = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: senhaController.text.trim(),
      );

      await credencial.user?.updateDisplayName(criancaController.text.trim());

      AppData.nomeCrianca = criancaController.text.trim();
      AppData.idCrianca = '#${credencial.user?.uid.substring(0, 4) ?? '0000'}';

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada com sucesso!'),
        ),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String mensagem = 'Erro ao criar conta';

      switch (e.code) {
        case 'email-already-in-use':
          mensagem = 'Este email já está cadastrado';
          break;

        case 'invalid-email':
          mensagem = 'Email inválido';
          break;

        case 'weak-password':
          mensagem = 'Senha muito fraca';
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );
    } catch (e) {
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
    confirmarSenhaController.dispose();
    responsavel1Controller.dispose();
    responsavel2Controller.dispose();
    criancaController.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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

              Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Criar Conta',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              campoTexto(
                controller: emailController,
                texto: 'Email',
              ),

              const SizedBox(height: 20),

              campoTexto(
                controller: senhaController,
                texto: 'Senha',
                senha: true,
              ),

              const SizedBox(height: 8),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'A senha deve conter:\n'
                  '• Pelo menos 6 caracteres',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              campoTexto(
                controller: confirmarSenhaController,
                texto: 'Confirmar senha',
                senha: true,
              ),

              const SizedBox(height: 20),

              campoTexto(
                controller: responsavel1Controller,
                texto: 'Nome do responsável',
              ),

              const SizedBox(height: 20),

              campoTexto(
                controller: responsavel2Controller,
                texto: 'Segundo responsável (Opcional)',
              ),

              const SizedBox(height: 20),

              campoTexto(
                controller: criancaController,
                texto: 'Nome da criança',
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: carregando ? null : criarConta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4E8FE8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: carregando
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
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
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
