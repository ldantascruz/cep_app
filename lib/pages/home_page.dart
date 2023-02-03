import 'package:cep_app/models/endereco_model.dart';
import 'package:cep_app/repositories/cep_repository_impl.dart';
import 'package:flutter/material.dart';

import '../repositories/cep_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CepRepository cepRepository = CepRepositoryImpl();
  EnderecoModel? enderecoModel;

  bool isLoading = false;

  final formKey = GlobalKey<FormState>();
  final cepEC = TextEditingController();

  @override
  void dispose() {
    cepEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar CEP'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: cepEC,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'CEP Obrigatório';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  final valid = formKey.currentState?.validate() ?? false;
                  if (valid) {
                    try {
                      setState(() {
                        isLoading = true;
                      });
                      final endereco = await cepRepository.getCep(cepEC.text);
                      setState(() {
                        isLoading = false;
                        enderecoModel = endereco;
                      });
                    } catch (e) {
                      setState(() {
                        isLoading = false;
                        enderecoModel = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Erro ao buscar endereço'),
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  'Buscar',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Visibility(
                visible: isLoading,
                child: const CircularProgressIndicator(),
              ),
              Visibility(
                visible: enderecoModel != null,
                child: Text(
                  '${enderecoModel?.logradouro} ${enderecoModel?.complemento} ${enderecoModel?.cep}',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
