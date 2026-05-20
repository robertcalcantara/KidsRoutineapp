class Atividade {
  final String nome;
  final String inicio;
  final String fim;
  final String categoria;

  bool concluida;

  Atividade({
    required this.nome,
    required this.inicio,
    required this.fim,
    required this.categoria,
    this.concluida = false,
  });
}
