import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'cep_service.dart';

void main() {
  runApp(const MaterialApp(home: CadastroUsuario()));
}

class CadastroUsuario extends StatefulWidget {
  const CadastroUsuario({Key? key}) : super(key: key);

  @override
  State<CadastroUsuario> createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _cepController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  String? _generoSelecionado;

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _dataNascimentoController.text =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
      ),
    );
  }

  void _buscarEndereco() {
    buscarEnderecoPeloCep(
      context: context,
      cep: _cepController.text,
      onSucesso: ({
        required String logradouro,
        required String bairro,
        required String cidade,
        required String estado,
      }) {
        setState(() {
          _logradouroController.text = logradouro;
          _bairroController.text = bairro;
          _cidadeController.text = cidade;
          _estadoController.text = estado;
        });
      },
    );
  }

  void _mostrarMensagemSucesso() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cadastro realizado com sucesso')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro de Usuário")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: _inputDecoration("Nome Completo"),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
                validator: (value) {
                  if (value == null || value.trim().split(' ').length < 2) {
                    return 'Informe o nome completo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cpfController,
                keyboardType: TextInputType.number,
                inputFormatters: [MaskedInputFormatter('000.000.000-00')],
                decoration: _inputDecoration("CPF"),
                validator: (value) {
                  if (value == null || value.length != 14) {
                    return 'Informe um CPF válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dataNascimentoController,
                readOnly: true,
                decoration: _inputDecoration("Data de Nascimento"),
                onTap: () => _selecionarData(context),
              ),
              const SizedBox(height: 16),
              const Text("Gênero"),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ["Masculino", "Feminino", "Outro"].map((g) {
                  return Expanded(
                    child: RadioListTile<String>(
                      title: Text(
                        g,
                        style: const TextStyle(fontSize: 13),
                      ),
                      value: g,
                      groupValue: _generoSelecionado,
                      onChanged: (value) {
                        setState(() {
                          _generoSelecionado = value;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _cepController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [MaskedInputFormatter('#####-###')],
                      decoration: _inputDecoration("CEP"),
                      validator: (value) {
                        if (value == null || value.length != 9) {
                          return 'Informe um CEP válido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _buscarEndereco,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Buscar"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _logradouroController,
                decoration: _inputDecoration("Logradouro"),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _numeroController,
                keyboardType: TextInputType.number,
                inputFormatters: [MaskedInputFormatter('#####')],
                decoration: _inputDecoration("Número"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o número';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _complementoController,
                decoration: _inputDecoration("Complemento"),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bairroController,
                decoration: _inputDecoration("Bairro"),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cidadeController,
                decoration: _inputDecoration("Cidade"),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _estadoController,
                decoration: _inputDecoration("Estado"),
                readOnly: true,
              ),
              const SizedBox(height: 32),
              Center(
                child: SizedBox(
                  width: 150,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          _generoSelecionado != null) {
                        _mostrarMensagemSucesso();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Preencha todos os campos obrigatórios'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Enviar'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
