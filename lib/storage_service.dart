import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {

  static const FlutterSecureStorage storage =
      FlutterSecureStorage();

  // SALVAR USUÁRIO
  static Future<void> salvarUsuario({

    required String email,
    required String senha,
    required String crianca,
    required String responsavel1,
    required String responsavel2,
    required String idCrianca,
  }) async {

    Map<String, dynamic> usuario = {

      'email': email,
      'senha': senha,
      'crianca': crianca,
      'responsavel1': responsavel1,
      'responsavel2': responsavel2,
      'idCrianca': idCrianca,
    };

    await storage.write(

      key: email,

      value: jsonEncode(usuario),
    );
  }

  // BUSCAR USUÁRIO
  static Future<Map<String, dynamic>?>
      buscarUsuario(String email) async {

    String? dados =
        await storage.read(key: email);

    if (dados == null) {

      return null;
    }

    return jsonDecode(dados);
  }
}