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
    final ref = _storage.ref().child('users/$_uid/perfil.jpg');
    await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
    return await ref.getDownloadURL();
  }

  // ─── CRIAR perfil inicial após cadastro ───────────────────────────────────
  static Future<void> criarPerfilInicial(String nomeCrianca) async {
    final snap = await _perfilDoc.get();
    if (snap.exists) return; // já existe, não sobrescreve

    await _perfilDoc.set({
      'nome': nomeCrianca,
      'idade': '',
      'unidadeIdade': 'anos',
      'genero': 'feminino',
      'escola': '',
      'emergencia': '',
      'observacoes': '',
      'fotoUrl': '',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}