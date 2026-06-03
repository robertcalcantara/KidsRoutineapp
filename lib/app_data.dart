import 'dart:typed_data';
import 'atividade.dart';

class AppData {
  // PERFIL
  static String nomeCrianca = 'Perfil Teste';
  static String idCrianca = '#0001';

  static DateTime dataNascimento = DateTime(2023, 01, 01);

  static String genero = 'feminino';
  static String escola = 'Escola UNIT';
  static String emergencia = 'Mãe (79) 98888-7777';
  static String observacoes = 'Digite a alergia da criança (CASO POSSUA)';
  static Uint8List? fotoPerfil;

  // ATIVIDADES
  static List<Atividade> atividades = [];
}
