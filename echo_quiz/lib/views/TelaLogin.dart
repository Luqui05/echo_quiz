import 'package:echo_quiz/config/Rotas.dart';
import 'package:echo_quiz/dao/UsuarioDAO.dart';
import 'package:echo_quiz/models/Usuario.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String senha = '';
  bool _obscureSenha = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0XFF8E2DE2), Color(0xFF4A00E0)],
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
                    'Bem vindo de volta!',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Informe seu e-mail'
                        : null,
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
                          _obscureSenha
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.deepPurpleAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureSenha = !_obscureSenha;
                          });
                        },
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Informe sua senha'
                        : null,
                    onSaved: (value) => senha = value ?? '',
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final usuario = await UsuarioDao()
                            .consultarPorEmailSenha(email, senha);
                        if (usuario != null) {
                          // TODO: Navege pra tela principal ou perfil
                        } else {
                          FocusScope.of(context).unfocus();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("E-mail ou senha inválidos"),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Entrar',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Rotas.cadastro);
                    },
                    child: const Text(
                      'Não tem conta? Crie sua conta',
                      style: TextStyle(color: Colors.white70),
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
