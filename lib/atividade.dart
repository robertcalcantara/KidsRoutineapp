import 'package:cloud_firestore/cloud_firestore.dart';

class Atividade {
  String id;
  String nome;
  String inicio;
  String fim;
  String categoria;
  DateTime data;
  bool concluida;
  DateTime? concluidaEm;
  String uid;
  String usuarioLogado;

  Atividade({
    required this.id,
    required this.nome,
    required this.inicio,
    required this.fim,
    required this.categoria,
    required this.data,
    this.concluida = false,
    this.concluidaEm,
    this.uid = '',
    this.usuarioLogado = '',
  });

  factory Atividade.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final dados = doc.data() ?? {};

    return Atividade(
      id: doc.id,
      nome: dados['nome'] ?? '',
      inicio: dados['inicio'] ?? '',
      fim: dados['fim'] ?? '',
      categoria: dados['categoria'] ?? '',
      data: dados['data'] is Timestamp
          ? (dados['data'] as Timestamp).toDate()
          : DateTime.now(),
      concluida: dados['concluida'] ?? false,
      concluidaEm: dados['concluidaEm'] is Timestamp
          ? (dados['concluidaEm'] as Timestamp).toDate()
          : null,
      uid: dados['uid'] ?? '',
      usuarioLogado: dados['usuario_logado'] ?? '',
    );
  }
}
