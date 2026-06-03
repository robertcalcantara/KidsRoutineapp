import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'ficha_medica_screen.dart'; 

class TelaPerfil extends StatefulWidget {
  final String nome;
  final String idade;
  final String genero;
  final String escola;
  final String emergencia;
  final String observacoes;
  final Uint8List? foto;

  const TelaPerfil({
    super.key,
    required this.nome,
    required this.idade,
    required this.genero,
    required this.escola,
    required this.emergencia,
    required this.observacoes,
    required this.foto,
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

  Future<void> _pickImage() async {
    if (!isEditing) return;

    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();

      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  // CONTROLLERS
  final TextEditingController nomeController =
      TextEditingController(text: "Kid");

  final TextEditingController idadeNumeroController =
      TextEditingController(text: "3");

  String unidadeIdade = "anos";

  final TextEditingController escolaController =
      TextEditingController(text: "Escola UNIT");

  final TextEditingController emergenciaController =
      TextEditingController(text: "Mãe (79) 98888-7777");

  final TextEditingController observacoesController =
      TextEditingController(text: "ALÉRGICA A Farofa");
      
  @override
  void initState() {
    super.initState();

    genero = widget.genero;

    nomeController.text = widget.nome;
    idadeNumeroController.text = widget.idade;
    escolaController.text = widget.escola;
    emergenciaController.text = widget.emergencia;
    observacoesController.text =
        widget.observacoes;

    _imageBytes = widget.foto;
  }

  @override
  void dispose() {
    nomeController.dispose();
    idadeNumeroController.dispose();
    escolaController.dispose();
    emergenciaController.dispose();
    observacoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color corGenero =
        genero == "masculino" ? Colors.blue : Colors.pink;

    Color corFundoIcone =
        genero == "masculino"
            ? Colors.blue[50]!
            : Colors.pink[50]!;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
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
                genero == "masculino"
                    ? Icons.face
                    : Icons.face_3,
                color: corGenero,
                size: 24,
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 24.0),

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
                                      image: MemoryImage(
                                          _imageBytes!),
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
                                      color:
                                          Colors.grey[400],
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

                    _buildMainField(
                      nomeController,
                      isTitle: true,
                    ),

                    const SizedBox(height: 8),

                    _buildIdadeField(),

                    if (isEditing)
                      _buildGeneroSelector(corGenero),
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

              _buildEditableRow(
                "Escola:",
                escolaController,
              ),

              const SizedBox(height: 15),

              _buildEditableRow(
                "Emergência:",
                emergenciaController,
              ),

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

                  minimumSize:
                      const Size(double.infinity, 55),

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),

                  elevation: 0,
                ),

                onPressed: () {
                  if (isEditing) {
                    Navigator.pop(context, {
                      'nome': nomeController.text,
                      'idade': idadeNumeroController.text,
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
                  isEditing
                      ? "Salvar Alterações"
                      : "Editar Perfil",

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
        mainAxisAlignment:
            MainAxisAlignment.center,

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

  // IDADE
  Widget _buildIdadeField() {
    if (!isEditing) {
      return Text(
        "${idadeNumeroController.text} $unidadeIdade",

        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center,

      children: [
        SizedBox(
          width: 70,

          child: TextField(
            controller: idadeNumeroController,

            keyboardType: TextInputType.number,

            inputFormatters: [
              FilteringTextInputFormatter
                  .digitsOnly
            ],

            textAlign: TextAlign.center,

            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],

              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),

              isDense: true,
            ),
          ),
        ),

        const SizedBox(width: 10),

        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12),

          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),

          child: DropdownButton<String>(
            value: unidadeIdade,

            underline: const SizedBox(),

            items: const [
              DropdownMenuItem(
                value: "anos",
                child: Text("anos"),
              ),

              DropdownMenuItem(
                value: "meses",
                child: Text("meses"),
              ),
            ],

            onChanged: (val) {
              setState(() {
                unidadeIdade = val!;
              });
            },
          ),
        ),
      ],
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
          fontWeight:
              isTitle
                  ? FontWeight.w900
                  : FontWeight.bold,
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
            borderRadius:
                BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // LINHAS EDITÁVEIS
  Widget _buildEditableRow(
    String label,
    TextEditingController controller,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 100,

          child: Text(
            label,

            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
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
                      borderRadius:
                          BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),

                    isDense: true,
                  ),
                )
              : Text(
                  controller.text,

                  style:
                      const TextStyle(fontSize: 16),
                ),
        ),
      ],
    );
  }

  // ALERTA
  Widget _buildAlertaSaude() {
    return Container(
      width: double.infinity,

      padding:
          isEditing
              ? EdgeInsets.zero
              : const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color:
            isEditing
                ? Colors.transparent
                : Colors.red[50],

        borderRadius: BorderRadius.circular(12),

        border: isEditing
            ? null
            : Border.all(
                color:
                    Colors.red.withOpacity(0.3),
              ),
      ),

      child: isEditing
          ? TextField(
              controller: observacoesController,
              maxLines: null,

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
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
            backgroundColor:
                const Color(0xFF1976D2),

            minimumSize:
                const Size(double.infinity, 55),

            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12),
            ),
          ),

          // AQUI FIZEMOS A CONEXÃO ENTRE AS TELAS:
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FichaMedicaScreen(
                  // Pega o nome digitado no controlador e envia pra Ficha Médica
                  nome: nomeController.text.isEmpty ? 'Criança' : nomeController.text,
                  // Junta o número da idade com a unidade (ex: "5" + " " + "anos")
                  idade: "${idadeNumeroController.text} $unidadeIdade",
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
            side:
                const BorderSide(color: Colors.black38),

            minimumSize:
                const Size(double.infinity, 55),

            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12),
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
