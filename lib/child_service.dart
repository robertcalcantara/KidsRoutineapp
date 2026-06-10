import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChildService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;
  static final _storage = FirebaseStorage.instance;

  static String get _uid => _auth.currentUser!.uid;

  static DocumentReference<Map<String, dynamic>> get _perfilDoc =>
      _db.collection('users').doc(_uid).collection('children').doc('perfil');

  // ─── STREAM em tempo real ─────────────────────────────────────────────────
  static Stream<Map<String, dynamic>?> watchPerfil() {
    return _perfilDoc.snapshots().map((snap) {
      if (!snap.exists) return null;
      return snap.data();
    });
  }

  // ─── LEITURA única (para initState) ──────────────────────────────────────
  static Future<Map<String, dynamic>?> getPerfil() async {
    final snap = await _perfilDoc.get();
    if (!snap.exists) return null;
    return snap.data();
  }

  // ─── SALVAR perfil ────────────────────────────────────────────────────────
  static Future<void> salvarPerfil(Map<String, dynamic> data) async {
    await _perfilDoc.set(
      {...data, 'updatedAt': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
  }

  // ─── UPLOAD foto ─────────────────────────────────────────────────────────
  static Future<String> uploadFoto(Uint8List bytes) async {
    // Usa nome único para evitar cache antigo da imagem no app.
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final ref = _storage.ref().child('users/$_uid/profile/perfil_$timestamp.jpg');

    await ref.putData(
      bytes,
      SettableMetadata(
        contentType: 'image/jpeg',
        cacheControl: 'no-cache, max-age=0',
      ),
    );

    return await ref.getDownloadURL();
  }

  // ─── CRIAR perfil inicial após cadastro ───────────────────────────────────
  static Future<void> criarPerfilInicial(
    String nomeCrianca, {
    String responsavel1 = '',
    String responsavel2 = '',
    String emailResponsavel = '',
  }) async {
    final nomeLimpo = nomeCrianca.trim();
    final dados = {
      'nome': nomeLimpo.isNotEmpty ? nomeLimpo : 'Criança',
      'responsavel1': responsavel1.trim(),
      'responsavel2': responsavel2.trim(),
      'emailResponsavel': emailResponsavel.trim(),
      'idade': '',
      'unidadeIdade': 'anos',
      'genero': 'feminino',
      'escola': '',
      'emergencia': '',
      'observacoes': '',
      'fotoUrl': '',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    final snap = await _perfilDoc.get();
    if (snap.exists) {
      // Não sobrescreve o perfil já criado/editado.
      // Apenas garante que os campos de responsável existam.
      await _perfilDoc.set({
        if (responsavel1.trim().isNotEmpty) 'responsavel1': responsavel1.trim(),
        if (responsavel2.trim().isNotEmpty) 'responsavel2': responsavel2.trim(),
        if (emailResponsavel.trim().isNotEmpty) 'emailResponsavel': emailResponsavel.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return;
    }

    await _perfilDoc.set(dados);
  }
}