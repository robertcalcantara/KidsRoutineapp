import 'package:flutter/material.dart';

import 'tela_login.dart';
import 'tela_cadastro.dart';
import 'tela_recuperar_senha.dart';
import 'tela_home.dart';

void main() {

  runApp(
    const KidsRoutineApp(),
  );
}

class KidsRoutineApp extends StatelessWidget {

  const KidsRoutineApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'Kids Routine',

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      initialRoute: '/',

      routes: {

        // LOGIN
        '/': (context) =>
            const TelaLogin(),

        // CADASTRO
        '/cadastro': (context) =>
            const TelaCadastro(),

        // RECUPERAR SENHA
        '/recuperar-senha': (context) =>
            const TelaRecuperarSenha(),

        // HOME
        '/home': (context) =>
            const TelaHome(

              nomeCrianca:
                  'Perfil Teste',

              idCrianca:
                  '#0000',
            ),
      },
    );
  }
}