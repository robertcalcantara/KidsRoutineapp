import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  static const String dominioPermitido = '@souunit.com.br';

  bool carregando = false;

  bool emailInstitucionalValido(String? email) {
    return email != null && email.toLowerCase().endsWith(dominioPermitido);
  }

  Future<void> logoutPorDominioInvalido() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  void abrirHome(User? usuario) {
    final nomeCrianca = usuario?.displayName;

    AppData.nomeCrianca = nomeCrianca == null || nomeCrianca.isEmpty
        ? 'Perfil Teste'
        : nomeCrianca;
    AppData.idCrianca = '#${usuario?.uid.substring(0, 4) ?? '0000'}';

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TelaHome(
          nomeCrianca: AppData.nomeCrianca,
          idCrianca: AppData.idCrianca,
        ),
      ),
    );
  }

  Future<void> fazerLogin() async {
    String email = emailController.text.trim();
    String senha = senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha email e senha')),
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

      if (!emailInstitucionalValido(credencial.user?.email)) {
        await logoutPorDominioInvalido();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Acesso permitido apenas para contas @souunit.com.br'),
          ),
        );
        return;
      }

      if (!mounted) return;
      abrirHome(credencial.user);
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

  Future<void> fazerLoginGoogle() async {
    setState(() {
      carregando = true;
    });

    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final credencial = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      if (!emailInstitucionalValido(credencial.user?.email)) {
        await logoutPorDominioInvalido();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Acesso permitido apenas para contas @souunit.com.br'),
          ),
        );
        return;
      }

      if (!mounted) return;
      abrirHome(credencial.user);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro no login com Google: ${e.message}')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro no login com Google: $e')),
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

              const SizedBox(height: 30),
              Image.asset('assets/images/family.png', height: 250),
              const SizedBox(height: 30),

              const Text(
                'Login',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 40),
              campoTexto(controller: emailController, texto: 'Email'),
              const SizedBox(height: 20),
              campoTexto(
                controller: senhaController,
                texto: 'Senha',
                senha: true,
              ),

              const SizedBox(height: 10),

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

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: carregando ? null : fazerLoginGoogle,
                  icon: const Icon(Icons.login),
                  label: const Text(
                    'Entrar com Google',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

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
