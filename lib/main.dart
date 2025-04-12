import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importation nécessaire pour Firebase
import 'firebase_options.dart'; // Importation du fichier généré par FlutterFire

void main() async { // La fonction main devient asynchrone (async)
  // Assure que tout est prêt avant d'initialiser Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Firebase en utilisant les options par défaut pour la plateforme
  await Firebase.initializeApp( // await car l'initialisation est asynchrone
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Lance l'application Flutter
  runApp(const MyApp());
}

// Le reste de votre application commence ici
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillConnect Lite', // Titre mis à jour
      theme: ThemeData(
        // Vous pouvez garder ou ajuster le thème par défaut
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, // Recommandé pour les nouveaux projets
      ),
      // Un widget temporaire pour montrer que ça fonctionne
      // On remplacera ça par notre écran de connexion/liste plus tard
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SkillConnect Lite'),
        ),
        body: const Center(
          child: Text('Firebase a été initialisé avec succès !'),
        ),
      ),
    );
  }
}

