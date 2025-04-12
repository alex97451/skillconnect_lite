import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import 'home_page.dart'; // Écran si connecté
import 'sign_in_page.dart'; // Écran si déconnecté
import 'splash_screen.dart'; // Écran de chargement initial

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocBuilder écoute les changements d'état de AuthBloc
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Afficher l'écran d'accueil si authentifié
        if (state is Authenticated) {
          
          return const HomePage();
        }
        // Afficher l'écran de connexion si non authentifié (ou après une erreur gérée)
        else if (state is Unauthenticated || state is AuthFailureState) {
           
          return const SignInPage();
        }
        // Afficher l'écran de chargement pendant l'initialisation ou le chargement
        // (AuthInitial est l'état avant que le stream n'émette la première valeur)
        else { // Inclut AuthInitial, AuthLoading
          return const SplashScreen();
        }
      },
    );
  }
}