import 'package:echo_quiz/config/Rotas.dart';
import 'package:echo_quiz/config/SincronizacaoService.dart';
import 'package:echo_quiz/dao/UsuarioDAO.dart';
import 'package:echo_quiz/models/Sessao.dart';
import 'package:echo_quiz/models/Usuario.dart';
import 'package:echo_quiz/components/ComponenteAppBar.dart';
import 'package:echo_quiz/components/ComponenteBotao.dart';
import 'package:echo_quiz/components/ComponenteCampoTexto.dart';
import 'package:echo_quiz/components/ComponenteLayoutGradiente.dart';
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
  bool _carregando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ComponenteAppBar(titulo: 'Login'),
      body: ComponenteLayoutGradiente(
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
                  ComponenteCampoTexto(
                    rotulo: 'E-mail',
                    tipoTeclado: TextInputType.emailAddress,
                    validador: (value) => value == null || value.isEmpty
                        ? 'Informe seu e-mail'
                        : null,
                    aoSalvar: (value) => email = value ?? '',
                  ),
                  const SizedBox(height: 20),
                  ComponenteCampoTexto(
                    rotulo: 'Senha',
                    obscureText: _obscureSenha,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureSenha ? Icons.visibility_off : Icons.visibility,
                        color: Colors.deepPurpleAccent,
                      ),
                      onPressed: () => setState(() => _obscureSenha = !_obscureSenha),
                    ),
                    validador: (value) => value == null || value.isEmpty
                        ? 'Informe sua senha'
                        : null,
                    aoSalvar: (value) => senha = value ?? '',
                  ),
                  const SizedBox(height: 20),
                  ComponenteBotao(
                    texto: 'Entrar',
                    carregando: _carregando,
                    largura: double.infinity,
                    onPressed: _fazerLogin,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, Rotas.cadastro),
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

  Future<void> _fazerLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _carregando = true);
      _formKey.currentState!.save();
      
      try {
        final usuario = await UsuarioDao().consultarPorEmailSenha(email, senha);
        if (usuario != null) {
          Sessao.usuarioLogado = true;
          Sessao.usuario = usuario;
          
          // Sincronização após login
          await SincronizacaoService.sincronizacaoCompleta();
          
          Navigator.pushReplacementNamed(context, Rotas.perfil, arguments: usuario);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("E-mail ou senha inválidos")),
          );
        }
      } finally {
        setState(() => _carregando = false);
      }
    }
  }
}
