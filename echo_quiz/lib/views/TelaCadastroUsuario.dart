import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaCadastroUsuario extends StatefulWidget {
  const TelaCadastroUsuario({super.key});

  @override
  State<TelaCadastroUsuario> createState() => _TelaCadastroUsuarioState();
}

class _TelaCadastroUsuarioState extends State<TelaCadastroUsuario> {
  final _formKey = GlobalKey<FormState>();
  String nome = '';
  String email = '';
  String senha = '';
  bool _obscureSenha = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crie sua conta'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Cadastro',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Informe seu nome'
                        : null,
                    onSaved: (value) => nome = value ?? '',
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Informe seu e-mail' : null,
                    onSaved: (value) => email = value ?? '',
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    obscureText: _obscureSenha,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureSenha ? Icons.visibility_off : Icons.visibility,
                          color: Colors.deepPurpleAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureSenha = !_obscureSenha;
                          });
                        },
                      ),
                    ),
                    validator: (value) =>
                        value == null || value.length < 6 ? 'Senha deve ter pelo menos 6 caracteres' : null,
                    onSaved: (value) => senha = value ?? '',
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // TODO: Salvar novo usuário usando o model Usuario
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
