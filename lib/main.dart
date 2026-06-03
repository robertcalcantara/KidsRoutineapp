import 'package:flutter/material.dart';
import 'tela_login.dart';
import 'tela_cadastro.dart';
import 'tela_recuperar_senha.dart';
import 'tela_home.dart';
import 'tela_historico.dart';
import 'tela_configuracoes.dart';
import 'tela_nova_atividade.dart';
import 'tela_rotina.dart';
import 'tela_ajuda_suporte.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const TelaLogin(),
        '/cadastro': (context) => const TelaCadastro(),
        '/recuperar-senha': (context) => const TelaRecuperarSenha(),
        '/home': (context) =>
            const TelaHome(nomeCrianca: 'Perfil Teste', idCrianca: '#0000'),
        '/historico': (context) => const TelaHistorico(),
        '/configuracoes': (context) => const TelaConfiguracoes(),
        '/nova-atividade': (context) => const NovaAtividadeScreen(),
        '/ajuda-suporte': (context) => const TelaAjudaSuporte(),
        '/rotina': (context) {
          final filtro = ModalRoute.of(context)?.settings.arguments as String?;
          return TelaRotina(filtroInicial: filtro ?? 'Hoje');
        },
      },
    );
  }
}
