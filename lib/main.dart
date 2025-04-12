import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'injection_container.dart' as di; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialiser l'Injection de Dépendances !
  di.initDi(); // Appel de notre fonction d'initialisation

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Le reste du code reste inchangé pour l'instant...
    return MaterialApp(
      title: 'SkillConnect Lite',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SkillConnect Lite'),
        ),
        body: const Center(
          child: Text('Firebase & DI Initialisés!'),
        ),
      ),
    );
  }
}