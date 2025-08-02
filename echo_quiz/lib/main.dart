import 'package:echo_quiz/config/MyApp.dart';
import 'package:echo_quiz/config/firebase/FirebaseConfig.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase (não irá falhar se não conseguir conectar)
  await FirebaseConfig.inicializar();
  
  runApp(const MyApp());
}


