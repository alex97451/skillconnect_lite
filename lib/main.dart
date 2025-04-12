import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Importer flutter_bloc
import 'firebase_options.dart';
import 'injection_container.dart' as di; // Notre DI
import 'injection_container.dart'; // Importer sl directement
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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // Le point d'entrée de l'UI est maintenant AuthWrapper
        home: const AuthWrapper(),
      ),
    );
  }
}