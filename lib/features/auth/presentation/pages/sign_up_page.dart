import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart'; // Importer Bloc, Events, States

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController(); // Pour confirmer le mot de passe
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      // Vérifier si les mots de passe correspondent
      if (_passwordController.text == _confirmPasswordController.text) {
        context.read<AuthBloc>().add(AuthSignUpRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              // Ajoutez d'autres champs ici si votre SignUpParams les requiert
            ));
      } else {
        // Afficher une erreur si les mots de passe ne correspondent pas
        _showErrorSnackBar(context, 'Les mots de passe ne correspondent pas');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() { _isLoading = true; });
          } else if (state is AuthFailureState) {
            setState(() { _isLoading = false; });
            _showErrorSnackBar(context, state.failure.message);
          } else if (state is Authenticated || state is Unauthenticated) {
             // Arrêter le chargement (AuthWrapper gère la navigation si Authenticated)
             setState(() { _isLoading = false; });
             // Si l'inscription réussit (Authenticated), AuthWrapper nous redirigera
             // vers HomePage. Si on est Unauthenticated (ce qui ne devrait pas
             // arriver juste après une tentative d'inscription réussie mais on le gère),
             // on reste ici ou AuthWrapper redirige vers SignIn.
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null || value.isEmpty || !value.contains('@')) {
                        return 'Veuillez entrer un email valide';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Mot de passe'),
                    obscureText: true,
                    validator: (value) {
                      // Vous pourriez ajouter une validation de force de mot de passe ici
                      if (value == null || value.length < 6) { // Exemple: min 6 caractères
                        return 'Le mot de passe doit faire au moins 6 caractères';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                   TextFormField( // Champ de confirmation
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(labelText: 'Confirmer le mot de passe'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez confirmer le mot de passe';
                      }
                      if (value != _passwordController.text) {
                         return 'Les mots de passe ne correspondent pas';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _signUp, // Appelle la méthode _signUp
                          child: const Text('S\'inscrire'),
                        ),
                   const SizedBox(height: 15),
                   // Lien pour retourner à la page de connexion
                   TextButton(
                     onPressed: _isLoading ? null : () { // Désactivé pendant le chargement
                       // Simple retour en arrière (suppose que SignInPage est en dessous dans la pile)
                       if (Navigator.canPop(context)) {
                         Navigator.pop(context);
                       }
                     },
                     child: const Text('Déjà un compte ? Se connecter'),
                   )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

   void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}