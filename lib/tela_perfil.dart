import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'ficha_medica_screen.dart';

class TelaPerfil extends StatefulWidget {
  final String nome;
  final DateTime dataNascimento; // Mudou de String para DateTime
  final String genero;
  final String school; // Mantido de acordo com seu código original (escola)
  final String escola;
  final String emergencia;
  final String observacoes;
  final Uint8List? foto;

  const TelaPerfil({
    super.key,
    required this.nome,
    required this.dataNascimento, // Atualizado aqui
    required this.genero,
    required this.escola,
    required this.emergencia,
    required this.observacoes,
    required this.foto,
    this.school = "",
  });

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  bool isEditing = false;

  // GÊNERO
  late String genero;

  // IMAGEM
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();

  // DATA DE NASCIMENTO
  late DateTime _dataNascimentoSelecionada;

  Future<void> _pickImage() async {
    if (!isEditing) return;

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();

      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  // CONTROLLERS
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController escolaController = TextEditingController();
  final TextEditingController emergenciaController = TextEditingController();
  final TextEditingController observacoesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    genero = widget.genero;
    _dataNascimentoSelecionada = widget.dataNascimento;

    nomeController.text = widget.nome;
    escolaController.text = widget.escola;
    emergenciaController.text = widget.emergencia;
    observacoesController.text = widget.observacoes;

    _imageBytes = widget.foto;
  }

  @override
  void dispose() {
    nomeController.dispose();
    escolaController.dispose();
    emergenciaController.dispose();
    observacoesController.dispose();
    super.dispose();
  }

  // FUNÇÃO PARA CALCULAR A IDADE DINAMICAMENTE
  String _calcularIdadeString(DateTime dataNasc) {
    final hoje = DateTime.now();
    int anos = hoje.year - dataNasc.year;
    int meses = hoje.month - dataNasc.month;

    if (hoje.day < dataNasc.day) {
      meses--;
    }

    if (meses < 0) {
      anos--;
      meses += 12;
    }

    if (anos > 0) {
      return "$anos ${anos == 1 ? 'ano' : 'anos'}";
    } else {
      return "$meses ${meses == 1 ? 'mês' : 'meses'}";
    }
  }

  // FUNÇÃO PARA FORMATAR A DATA NO PADRÃO PT-BR (DD/MM/AAAA)
  String _formatarData(DateTime data) {
    return "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}";
  }

  // SELETOR DE DATA (DATE PICKER)
  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? selecionada = await showDatePicker(
      context: context,
      initialDate: _dataNascimentoSelecionada,
      firstDate: DateTime(DateTime.now().year - 18), // Limite de 18 anos atrás
      lastDate: DateTime.now(), // Não deixa selecionar data futura
      locale: const Locale(
        'pt',
        'BR',
      ), // Lembre-se de configurar a localização no main.dart se necessário
    );

    if (selecionada != null && selecionada != _dataNascimentoSelecionada) {
      setState(() {
        _dataNascimentoSelecionada = selecionada;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color corGenero = genero == "masculino" ? Colors.blue : Colors.pink;

    Color corFundoIcone = genero == "masculino"
        ? Colors.blue[50]!
        : Colors.pink[50]!;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Perfil da Criança",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: corFundoIcone,
              radius: 20,
              child: Icon(
                genero == "masculino" ? Icons.face : Icons.face_3,
                color: corGenero,
                size: 24,
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // FOTO
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[200],
                              border: Border.all(
                                color: isEditing
                                    ? corGenero
                                    : Colors.transparent,
                                width: 3,
                              ),
                              image: _imageBytes != null
                                  ? DecorationImage(
                                      image: MemoryImage(_imageBytes!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: _imageBytes == null
                                ? ClipOval(
                                    child: Icon(
                                      Icons.person,
                                      size: 80,
                                      color: Colors.grey[400],
                                    ),
                                  )
                                : null,
                          ),
                          if (isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: corGenero,
                                radius: 18,
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildMainField(nomeController, isTitle: true),

                    const SizedBox(height: 8),

                    // CAMPO DE IDADE CORRIGIDO
                    _buildIdadeField(),

                    if (isEditing) _buildGeneroSelector(corGenero),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              const Text(
                "INFORMAÇÕES DE ROTINA",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const Divider(),
              const SizedBox(height: 10),

              _buildEditableRow("Escola:", escolaController),

              const SizedBox(height: 15),

              _buildEditableRow("Emergência:", emergenciaController),

              const SizedBox(height: 30),

              const Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "ALERTA DE SAÚDE",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              _buildAlertaSaude(),
              const SizedBox(height: 40),

              // BOTÃO SALVAR
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEditing
                      ? Colors.green
                      : const Color(0xFF5A8DEE),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  if (isEditing) {
                    Navigator.pop(context, {
                      'nome': nomeController.text,
                      'dataNascimento':
                          _dataNascimentoSelecionada, // Retorna o DateTime alterado
                      'idade': _calcularIdadeString(
                        _dataNascimentoSelecionada,
                      ), // Caso precise da String em algum lugar
                      'genero': genero,
                      'escola': escolaController.text,
                      'emergencia': emergenciaController.text,
                      'observacoes': observacoesController.text,
                      'foto': _imageBytes,
                    });
                  } else {
                    setState(() {
                      isEditing = true;
                    });
                  }
                },
                child: Text(
                  isEditing ? "Salvar Alterações" : "Editar Perfil",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              _buildSecondaryButtons(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // GÊNERO
  Widget _buildGeneroSelector(Color corAtiva) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ChoiceChip(
            label: const Text("Menino"),
            selected: genero == "masculino",
            selectedColor: Colors.blue[100],
            onSelected: (val) {
              setState(() {
                genero = "masculino";
              });
            },
          ),
          const SizedBox(width: 10),
          ChoiceChip(
            label: const Text("Menina"),
            selected: genero == "feminino",
            selectedColor: Colors.pink[100],
            onSelected: (val) {
              setState(() {
                genero = "feminino";
              });
            },
          ),
        ],
      ),
    );
  }

  // NOVO WIDGET DE IDADE / DATA DE NASCIMENTO
  Widget _buildIdadeField() {
    if (!isEditing) {
      // Exibe a idade calculada dinamicamente quando não está editando
      return Text(
        _calcularIdadeString(_dataNascimentoSelecionada),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );
    }

    // Botão estilizado para abrir o DatePicker em modo de edição
    return InkWell(
      onTap: () => _selecionarData(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_month, size: 20, color: Colors.black54),
            const SizedBox(width: 8),
            Text(
              "${_formatarData(_dataNascimentoSelecionada)} (${_calcularIdadeString(_dataNascimentoSelecionada)})",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CAMPO PRINCIPAL
  Widget _buildMainField(
    TextEditingController controller, {
    required bool isTitle,
  }) {
    if (!isEditing) {
      return Text(
        controller.text,
        style: TextStyle(
          fontSize: isTitle ? 26 : 16,
          fontWeight: isTitle ? FontWeight.w900 : FontWeight.bold,
        ),
      );
    }

    return SizedBox(
      width: 200,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // LINHAS EDITÁVEIS
  Widget _buildEditableRow(String label, TextEditingController controller) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: isEditing
              ? TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    isDense: true,
                  ),
                )
              : Text(controller.text, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  // ALERTA
  Widget _buildAlertaSaude() {
    return Container(
      width: double.infinity,
      padding: isEditing ? EdgeInsets.zero : const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEditing ? Colors.transparent : Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: isEditing
            ? null
            : Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: isEditing
          ? TextField(
              controller: observacoesController,
              maxLines: null,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            )
          : Text(
              observacoesController.text,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  // BOTÕES
  Widget _buildSecondaryButtons() {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1976D2),
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FichaMedicaScreen(
                  nome: nomeController.text.isEmpty
                      ? 'Criança'
                      : nomeController.text,
                  // Agora passa a idade calculada dinamicamente para a Ficha Médica!
                  idade: _calcularIdadeString(_dataNascimentoSelecionada),
                ),
              ),
            );
          },
          child: const Text(
            "Ver Ficha Médica Completa",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.black38),
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {},
          child: const Text(
            "Excluir Criança",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
