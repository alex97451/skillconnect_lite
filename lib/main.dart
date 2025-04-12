import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Importer flutter_bloc
import 'firebase_options.dart';
import 'injection_container.dart' as di; // Notre DI
import 'injection_container.dart'; // Importer sl directement (pour create)
import 'features/auth/presentation/bloc/auth_bloc.dart'; // Importer AuthBloc
import 'features/auth/presentation/pages/auth_wrapper.dart'; // Importer AuthWrapper


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  di.initDi(); // Initialiser DI

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Fournir l'AuthBloc à l'arbre de widgets
    return BlocProvider(
      // Créer l'instance du Bloc en utilisant notre Service Locator (sl)
      create: (context) => sl<AuthBloc>(),
      child: MaterialApp(
        title: 'SkillConnect Lite',
        debugShowCheckedModeBanner: false, // Cacher la bannière Debug
        // --- Thème Mis à Jour ---
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, // Couleur de base pour générer la palette
            
          ),
          useMaterial3: true,

          // Thème pour les champs de texte
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder( // Bordure pour tous les champs
              borderRadius: BorderRadius.circular(8.0), // Coins arrondis
            ),
            // contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Ajuster padding interne
          ),

          // Thème pour les boutons élevés
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder( // Coins arrondis pour les boutons
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20), // Padding du bouton
              
              textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),

           // Thème pour les boutons texte (liens)
           textButtonTheme: TextButtonThemeData(
             style: TextButton.styleFrom(
               // Utiliser la couleur primaire pour le lien (peut être ajusté)
               foregroundColor: Colors.deepPurple, // Ou: Theme.of(context).colorScheme.primary
                 padding: const EdgeInsets.symmetric(vertical: 10), // Ajouter padding vertical
             )
           )
        ),
        // --------------------------
        home: const AuthWrapper(), // Point d'entrée UI
      ),
    );
  }
}