import 'package:flutter/material.dart';

import 'tela_login.dart';
import 'tela_cadastro.dart';
import 'tela_recuperar_senha.dart';

void main() {
  runApp(const KidsRoutineApp());
}

class KidsRoutineApp extends StatelessWidget {
  const KidsRoutineApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'KidsRoutine',

      initialRoute: '/',

      routes: {

        '/': (context) => const TelaLogin(),

        '/cadastro': (context) =>
            const TelaCadastro(),

        '/recuperar-senha': (context) =>
            const TelaRecuperarSenha(),
      },
    );
  }
}