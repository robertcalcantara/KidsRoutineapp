import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {

    final larguraTela =
        MediaQuery.of(context).size.width;

    return Scaffold(

      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding: const EdgeInsets.all(24),

            child: Column(

              children: [

                // LOGO
                Align(

                  alignment: Alignment.topRight,

                  child: Container(

                    width: 60,
                    height: 60,

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

                const SizedBox(height: 20),

                const Text(

                  'Login',

                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // IMAGEM
                Container(

                  width: larguraTela * 0.8,

                  constraints:
                      const BoxConstraints(
                    maxWidth: 350,
                  ),

                  height: 220,

                  decoration: BoxDecoration(

                    borderRadius:
                        BorderRadius.circular(40),

                    border: Border.all(
                      color: Colors.blue,
                      width: 2,
                    ),

                    color: Colors.white,
                  ),

                  child: ClipRRect(

                    borderRadius:
                        BorderRadius.circular(40),

                    child: Image.asset(
                      'assets/images/family.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                const Text(

                  'Bem-vindo ao\nRotinaKids',

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                // EMAIL
                TextField(

                  controller: emailController,

                  decoration: InputDecoration(

                    hintText: 'EMAIL',

                    filled: true,
                    fillColor: Colors.white,

                    border: OutlineInputBorder(

                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // SENHA
                TextField(

                  controller: senhaController,

                  obscureText: true,

                  decoration: InputDecoration(

                    hintText: 'SENHA',

                    filled: true,
                    fillColor: Colors.white,

                    border: OutlineInputBorder(

                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // BOTÃO ENTRAR
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

                      'ENTRAR',

                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // RECUPERAR SENHA
                TextButton(

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

                // NOVA CONTA
                TextButton(

                  onPressed: () {

                    Navigator.pushNamed(
                      context,
                      '/cadastro',
                    );
                  },

                  child: const Text(
                    'Criar nova conta',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}