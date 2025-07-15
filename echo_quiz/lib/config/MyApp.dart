import 'package:echo_quiz/config/Rotas.dart';
import 'package:echo_quiz/models/Usuario.dart';
import 'package:echo_quiz/views/TelaCadastroPergunta.dart';
import 'package:echo_quiz/views/TelaCadastroUsuario.dart';
import 'package:echo_quiz/views/TelaInicial.dart';
import 'package:echo_quiz/views/TelaLogin.dart';
import 'package:echo_quiz/views/TelaPerfilUsuario.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const TelaInicial(),
      routes: {
        Rotas.login: (context) => const TelaLogin(),
        Rotas.cadastro: (context) => const TelaCadastroUsuario(),
        Rotas.perfil: (context) {
          final usuario = ModalRoute.of(context)!.settings.arguments as Usuario;
          return TelaPerfilUsuario(usuario: usuario);
        },
        Rotas.cadastroPergunta: (context) => const TelaCadastroPergunta(),
      },
    );
  }
}
