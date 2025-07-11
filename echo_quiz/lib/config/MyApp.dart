import 'package:echo_quiz/config/Rotas.dart';
import 'package:echo_quiz/views/TelaCadastroUsuario.dart';
import 'package:echo_quiz/views/TelaInicial.dart';
import 'package:echo_quiz/views/TelaLogin.dart';
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
      },
    );
  }
}
