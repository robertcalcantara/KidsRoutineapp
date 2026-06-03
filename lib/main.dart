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
import 'tela_notificacoes.dart';
import 'tela_preferencias_conta.dart';

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

        // AJUDA E SUPORTE
        '/ajuda-suporte': (context) => const TelaAjudaSuporte(),

        // NOTIFICAÇÕES
        '/notificacoes': (context) => const TelaNotificacoes(),

        // PREFERÊNCIAS DA CONTA
        '/preferencias-conta': (context) => const TelaPreferenciasConta(),

        // ROTINA
        '/rotina': (context) {
          final filtro = ModalRoute.of(context)?.settings.arguments as String?;

          return TelaRotina(filtroInicial: filtro ?? 'Hoje');
        },
      },
    );
  }
}
