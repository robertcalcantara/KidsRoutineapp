import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'tela_login.dart';
import 'tela_cadastro.dart';
import 'tela_recuperar_senha.dart';
import 'tela_home.dart';
import 'tela_historico.dart';
import 'tela_configuracoes.dart';
import 'tela_nova_atividade.dart';
import 'tela_rotina.dart';

void main() {
  runApp(const KidsRoutineApp());
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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
      ),

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      locale: const Locale('pt', 'BR'),

      initialRoute: '/',
      routes: {
        // LOGIN
        '/': (context) => const TelaLogin(),

        // CADASTRO
        '/cadastro': (context) => const TelaCadastro(),

        // RECUPERAR SENHA
        '/recuperar-senha': (context) => const TelaRecuperarSenha(),

        // HOME
        '/home': (context) =>
            const TelaHome(nomeCrianca: 'Perfil Teste', idCrianca: '#0000'),

        // HISTÓRICO
        '/historico': (context) => const TelaHistorico(),

        // CONFIGURAÇÕES
        '/configuracoes': (context) => const TelaConfiguracoes(),

        // NOVA ATIVIDADE
        '/nova-atividade': (context) => const NovaAtividadeScreen(),

        '/rotina': (context) => const TelaRotina(),
      },
    );
  }
}
