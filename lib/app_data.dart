import 'dart:typed_data';
import 'atividade.dart';

/// AppData agora é usado apenas como cache em memória durante a sessão.
/// A fonte de verdade é o Firestore (via ChildService).
/// Não coloque valores fixos aqui — os campos são preenchidos no login.
class AppData {
  // PERFIL
  static String nomeCrianca = '';
  static String idCrianca = '';

  // IDADE
  static String idade = '';
  static String unidadeIdade = 'anos';

  // DATA DE NASCIMENTO
  static DateTime dataNascimento = DateTime(2020, 1, 1);

  static String genero = 'feminino';
  static String escola = '';
  static String emergencia = '';
  static String observacoes = '';
  static String fotoUrl = '';

  // foto local (apenas quando o usuário acabou de trocar, antes do upload)
  static Uint8List? fotoPerfil;

  // ATIVIDADES
  static List<Atividade> atividades = [];

  /// Preenche o cache a partir do mapa vindo do Firestore
  static void fromFirestore(Map<String, dynamic> data) {
    nomeCrianca   = data['nome']         ?? '';
    idade         = data['idade']        ?? '';
    unidadeIdade  = data['unidadeIdade'] ?? 'anos';
    genero        = data['genero']       ?? 'feminino';
    escola        = data['escola']       ?? '';
    emergencia    = data['emergencia']   ?? '';
    observacoes   = data['observacoes']  ?? '';
    fotoUrl       = data['fotoUrl']      ?? '';
    fotoPerfil    = null; // limpa bytes locais; usa URL do storage
  }

  /// Converte o cache para o mapa que vai ao Firestore
  static Map<String, dynamic> toFirestore() {
    return {
      'nome':        nomeCrianca,
      'idade':       idade,
      'unidadeIdade': unidadeIdade,
      'genero':      genero,
      'escola':      escola,
      'emergencia':  emergencia,
      'observacoes': observacoes,
      'fotoUrl':     fotoUrl,
    };
  }

  /// Limpa o cache ao fazer logout
  static void clear() {
    nomeCrianca  = '';
    idCrianca    = '';
    idade        = '';
    unidadeIdade = 'anos';
    genero       = 'feminino';
    escola       = '';
    emergencia   = '';
    observacoes  = '';
    fotoUrl      = '';
    fotoPerfil   = null;
    atividades   = [];
  }
}