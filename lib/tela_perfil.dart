import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'app_data.dart';
import 'child_service.dart';
import 'ficha_medica_screen.dart';

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({super.key});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  bool isEditing = false;
  bool isSaving = false;
  bool isLoading = true;

  // GÊNERO
  String genero = 'feminino';

  // IMAGEM
  Uint8List? _imageBytes;   // bytes de uma nova foto escolhida localmente
  String _fotoUrl = '';     // URL salva no Firebase Storage
  final ImagePicker _picker = ImagePicker();

  // CONTROLLERS (sem texto fixo)
  final TextEditingController nomeController       = TextEditingController();
  final TextEditingController idadeNumeroController = TextEditingController();
  final TextEditingController escolaController      = TextEditingController();
  final TextEditingController emergenciaController  = TextEditingController();
  final TextEditingController observacoesController = TextEditingController();

  String unidadeIdade = 'anos';

  @override
  void initState() {
    super.initState();
    _carregarDoFirebase();
  }

  // ─── Carrega dados do Firestore ───────────────────────────────────────────
  Future<void> _carregarDoFirebase() async {
    final data = await ChildService.getPerfil();
    if (data != null) {
      _preencherCampos(data);
    } else {
      // Usa cache local se não encontrar documento ainda
      _preencherCamposDoAppData();
    }
    if (mounted) setState(() => isLoading = false);
  }

  void _preencherCampos(Map<String, dynamic> data) {
    nomeController.text        = data['nome']        ?? '';
    idadeNumeroController.text = data['idade']       ?? '';
    unidadeIdade               = data['unidadeIdade'] ?? 'anos';
    genero                     = data['genero']      ?? 'feminino';
    escolaController.text      = data['escola']      ?? '';
    emergenciaController.text  = data['emergencia']  ?? '';
    observacoesController.text = data['observacoes'] ?? '';
    _fotoUrl                   = data['fotoUrl']     ?? '';
  }

  void _preencherCamposDoAppData() {
    nomeController.text        = AppData.nomeCrianca;
    idadeNumeroController.text = AppData.idade;
    unidadeIdade               = AppData.unidadeIdade;
    genero                     = AppData.genero;
    escolaController.text      = AppData.escola;
    emergenciaController.text  = AppData.emergencia;
    observacoesController.text = AppData.observacoes;
    _fotoUrl                   = AppData.fotoUrl;
  }

  // ─── Escolhe foto da galeria ──────────────────────────────────────────────
  Future<void> _pickImage() async {
    if (!isEditing) return;
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() => _imageBytes = bytes);
    }
  }

  // ─── Salva no Firebase ────────────────────────────────────────────────────
  Future<void> _salvar() async {
    setState(() => isSaving = true);

    try {
      // Upload da foto se o usuário trocou
      if (_imageBytes != null) {
        _fotoUrl = await ChildService.uploadFoto(_imageBytes!);
        _imageBytes = null; // limpa bytes locais após upload
      }

      final data = {
        'nome':        nomeController.text.trim(),
        'idade':       idadeNumeroController.text.trim(),
        'unidadeIdade': unidadeIdade,
        'genero':      genero,
        'escola':      escolaController.text.trim(),
        'emergencia':  emergenciaController.text.trim(),
        'observacoes': observacoesController.text.trim(),
        'fotoUrl':     _fotoUrl,
      };

      await ChildService.salvarPerfil(data);

      // Atualiza o cache em memória
      AppData.fromFirestore(data);

      setState(() => isEditing = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil salvo com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
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
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    Color corGenero      = genero == 'masculino' ? Colors.blue : Colors.pink;
    Color corFundoIcone  = genero == 'masculino' ? Colors.blue[50]! : Colors.pink[50]!;

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
          'Perfil da Criança',
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
                genero == 'masculino' ? Icons.face : Icons.face_3,
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

              // ── FOTO ──────────────────────────────────────────────────────
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
                                color: isEditing ? corGenero : Colors.transparent,
                                width: 3,
                              ),
                              image: _imagemDecoration(),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: _semFoto()
                                ? ClipOval(
                                    child: Icon(Icons.person, size: 80, color: Colors.grey[400]),
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
                                child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    _buildMainField(nomeController, isTitle: true),
                    const SizedBox(height: 8),
                    _buildIdadeField(),
                    if (isEditing) _buildGeneroSelector(corGenero),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              const Text(
                'INFORMAÇÕES DE ROTINA',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const Divider(),
              const SizedBox(height: 10),

              _buildEditableRow('Escola:', escolaController),
              const SizedBox(height: 15),
              _buildEditableRow('Emergência:', emergenciaController),

              const SizedBox(height: 30),

              const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'ALERTA DE SAÚDE',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildAlertaSaude(),

              const SizedBox(height: 40),

              // ── BOTÃO PRINCIPAL ───────────────────────────────────────────
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEditing ? Colors.green : const Color(0xFF5A8DEE),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: isSaving
                    ? null
                    : () {
                        if (isEditing) {
                          _salvar();
                        } else {
                          setState(() => isEditing = true);
                        }
                      },
                child: isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        isEditing ? 'Salvar Alterações' : 'Editar Perfil',
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

  // ─── Helpers de imagem ────────────────────────────────────────────────────

  bool _semFoto() => _imageBytes == null && _fotoUrl.isEmpty;

  DecorationImage? _imagemDecoration() {
    if (_imageBytes != null) {
      return DecorationImage(image: MemoryImage(_imageBytes!), fit: BoxFit.cover);
    }
    if (_fotoUrl.isNotEmpty) {
      return DecorationImage(image: NetworkImage(_fotoUrl), fit: BoxFit.cover);
    }
    return null;
  }

  // ─── Widgets de campo ─────────────────────────────────────────────────────

  Widget _buildGeneroSelector(Color corAtiva) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ChoiceChip(
            label: const Text('Menino'),
            selected: genero == 'masculino',
            selectedColor: Colors.blue[100],
            onSelected: (_) => setState(() => genero = 'masculino'),
          ),
          const SizedBox(width: 10),
          ChoiceChip(
            label: const Text('Menina'),
            selected: genero == 'feminino',
            selectedColor: Colors.pink[100],
            onSelected: (_) => setState(() => genero = 'feminino'),
          ),
        ],
      ),
    );
  }

  Widget _buildIdadeField() {
    if (!isEditing) {
      return Text(
        '${idadeNumeroController.text} $unidadeIdade',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 70,
          child: TextField(
            controller: idadeNumeroController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: unidadeIdade,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'anos', child: Text('anos')),
              DropdownMenuItem(value: 'meses', child: Text('meses')),
            ],
            onChanged: (val) => setState(() => unidadeIdade = val!),
          ),
        ),
      ],
    );
  }

  Widget _buildMainField(TextEditingController controller, {required bool isTitle}) {
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

  Widget _buildEditableRow(String label, TextEditingController controller) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildAlertaSaude() {
    return Container(
      width: double.infinity,
      padding: isEditing ? EdgeInsets.zero : const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEditing ? Colors.transparent : Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: isEditing ? null : Border.all(color: Colors.red.withOpacity(0.3)),
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
              style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
            ),
    );
  }

  Widget _buildSecondaryButtons() {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1976D2),
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FichaMedicaScreen(
                  nome: nomeController.text.isEmpty ? 'Criança' : nomeController.text,
                  idade: '${idadeNumeroController.text} $unidadeIdade',
                ),
              ),
            );
          },
          child: const Text(
            'Ver Ficha Médica Completa',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}