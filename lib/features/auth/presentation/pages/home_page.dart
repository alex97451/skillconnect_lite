import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart'; // Importer le bloc pour dispatcher l'événement

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // On peut récupérer l'utilisateur depuis l'état si nécessaire
    final user = (context.watch<AuthBloc>().state as Authenticated).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: () {
              // Envoyer l'événement de déconnexion au Bloc
              context.read<AuthBloc>().add(AuthSignOutRequested());
            },
          )
        ],
      ),
      body: Center(
        child: Text('Bienvenue ${user.email ?? user.id}!'), // Afficher email ou ID
      ),
    );
  }
}