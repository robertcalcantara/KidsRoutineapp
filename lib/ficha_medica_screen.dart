import 'package:flutter/material.dart';
// Importações necessárias para o PDF
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class FichaMedicaScreen extends StatefulWidget {
  const FichaMedicaScreen({Key? key}) : super(key: key);

  @override
  State<FichaMedicaScreen> createState() => _FichaMedicaScreenState();
}

class _FichaMedicaScreenState extends State<FichaMedicaScreen> {
  // Controladores para capturar o que o usuário digitar
  final _tipoSanguineoController = TextEditingController();
  final _alergiasController = TextEditingController();
  final _comorbidadesController = TextEditingController();
  final _medicamentosController = TextEditingController();
  final _restricoesController = TextEditingController();
  final _contatoController = TextEditingController();
  final _observacoesController = TextEditingController();

  @override
  void dispose() {
    // É importante limpar os controladores da memória quando fechar a tela
    _tipoSanguineoController.dispose();
    _alergiasController.dispose();
    _comorbidadesController.dispose();
    _medicamentosController.dispose();
    _restricoesController.dispose();
    _contatoController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  // Função que será chamada ao clicar em "Gerar PDF"
  Future<void> _gerarPDF() async {
    // Cria o documento PDF
    final pdf = pw.Document();

    // Função auxiliar para desenhar cada campo no PDF
    pw.Widget buildPdfField(String titulo, String valor) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 12.0),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(titulo, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
            pw.SizedBox(height: 4),
            pw.Text(
              valor.trim().isEmpty ? 'Não informado' : valor,
              style: const pw.TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
    }

    // Adiciona uma página ao PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Cabeçalho do PDF
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Ficha Médica - João Pedro',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 20),

              // Dados da Criança
              pw.Text('Idade: 5 anos', style: const pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 30),

              // Campos Preenchidos
              buildPdfField('Tipo Sanguíneo', _tipoSanguineoController.text),
              buildPdfField('Alergias', _alergiasController.text),
              buildPdfField('Comorbidades', _comorbidadesController.text),
              buildPdfField('Medicamentos de uso contínuo', _medicamentosController.text),
              buildPdfField('Restrições alimentares', _restricoesController.text),
              buildPdfField('Contato de emergência', _contatoController.text),
              buildPdfField('Observações gerais', _observacoesController.text),
            ],
          );
        },
      ),
    );

    // Exibe a tela de pré-visualização e salvamento do dispositivo
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Ficha_Medica_Joao_Pedro.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.toys_outlined, color: Colors.blue, size: 32),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Ficha Médica',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'Prescrição e observações da criança',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            // Card de Perfil da Criança
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F8FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey[200],
                    child: const Icon(Icons.person, size: 40, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'João Pedro',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '5 anos',
                        style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Campos do formulário associados aos controladores
            _buildCustomField(
              controller: _tipoSanguineoController,
              label: 'Tipo sanguíneo',
              hint: 'Ex.: O+',
              icon: Icons.water_drop_outlined,
              iconColor: Colors.red[400]!,
            ),
            _buildCustomField(
              controller: _alergiasController,
              label: 'Alergias',
              hint: 'Ex.: Dipirona, amendoim, poeira...',
              icon: Icons.warning_amber_rounded,
              iconColor: Colors.orange,
            ),
            _buildCustomField(
              controller: _comorbidadesController,
              label: 'Comorbidades',
              hint: 'Ex.: Asma, rinite, diabetes...',
              icon: Icons.favorite_border,
              iconColor: Colors.purple[300]!,
            ),
            _buildCustomField(
              controller: _medicamentosController,
              label: 'Medicamentos de uso contínuo',
              hint: 'Ex.: Aerolin, Loratadina...',
              icon: Icons.medication_outlined,
              iconColor: Colors.blue[400]!,
            ),
            _buildCustomField(
              controller: _restricoesController,
              label: 'Restrições alimentares',
              hint: 'Ex.: Não consome leite, sem glúten...',
              icon: Icons.apple_outlined,
              iconColor: Colors.green[400]!,
            ),
            _buildCustomField(
              controller: _contatoController,
              label: 'Contato de emergência',
              hint: 'Ex.: (79) 99999-9999 - Mãe',
              icon: Icons.phone_outlined,
              iconColor: Colors.blue[400]!,
            ),
            _buildCustomField(
              controller: _observacoesController,
              label: 'Observações gerais',
              hint: 'Informações importantes sobre a saúde...',
              icon: Icons.insert_drive_file_outlined,
              iconColor: Colors.purple[300]!,
              maxLines: 3,
            ),

            const SizedBox(height: 8),

            // Botão Gerar PDF
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _gerarPDF,
                icon: const Icon(Icons.picture_as_pdf_outlined, color: Colors.white),
                label: const Text(
                  'GERAR PDF',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Rodapé
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, color: Colors.grey[500], size: 18),
                const SizedBox(width: 6),
                Text(
                  'O PDF será salvo no seu dispositivo',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Widget construtor dos campos de texto
  Widget _buildCustomField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color iconColor,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 16),
              ),
            ],
          ),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.blue, width: 1.5),
          ),
        ),
      ),
    );
  }
}