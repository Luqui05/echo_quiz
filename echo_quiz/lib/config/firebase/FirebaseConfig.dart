import 'package:echo_quiz/config/firebase/DefaultFirebaseConfig.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseConfig {
  static FirebaseFirestore? _firestore;
  
  static Future<void> inicializar() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _firestore = FirebaseFirestore.instance;
      
      // Configurar para usar emulador em desenvolvimento (opcional)
      // if (kDebugMode) {
      //   _firestore!.useFirestoreEmulator('localhost', 8080);
      // }
      
    } catch (e) {
      print('Erro ao inicializar Firebase: $e');
      // Em caso de erro, continua sem Firebase
      _firestore = null;
    }
  }
  
  static FirebaseFirestore? get firestore => _firestore;
  
  static bool get isInitialized => _firestore != null;
}