class Atividade {
  String nome;
  String inicio;
  String fim;
  String categoria;
  DateTime data;
  bool concluida;
  DateTime? concluidaEm;

  Atividade({
    required this.nome,
    required this.inicio,
    required this.fim,
    required this.categoria,
    DateTime? data,
    this.concluida = false,
    this.concluidaEm,
  }) : data = data ?? DateTime.now();
}
