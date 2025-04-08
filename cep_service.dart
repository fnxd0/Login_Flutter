import 'package:flutter/material.dart';
import 'package:search_cep/search_cep.dart';

Future<void> buscarEnderecoPeloCep({
  required BuildContext context,
  required String cep,
  required Function({
    required String logradouro,
    required String bairro,
    required String cidade,
    required String estado,
  }) onSucesso,
}) async {
  final viaCepSearchCep = ViaCepSearchCep();
  final result = await viaCepSearchCep.searchInfoByCep(
    cep: cep.replaceAll(RegExp(r'[^0-9]'), ''),
  );

  result.fold(
    (failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${failure.errorMessage}')),
      );
    },
    (info) {
      onSucesso(
        logradouro: info.logradouro ?? '',
        bairro: info.bairro ?? '',
        cidade: info.localidade ?? '',
        estado: info.uf ?? '',
      );
    },
  );
}
