import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart'; // Importer Bloc, Events, States
import 'sign_up_page.dart'; // Importer la page d'inscription
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; // Pour gérer l'état de chargement localement

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      // Si le formulaire est valide, envoyer l'événement au Bloc
      context.read<AuthBloc>().add(AuthSignInRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: BlocListener<AuthBloc, AuthState>(
        // BlocListener est idéal pour les actions ponctuelles (snackbar, navigation...)
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() { _isLoading = true; });
          } else if (state is AuthFailureState) {
            setState(() { _isLoading = false; });
            // Afficher l'erreur
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar();
              _showErrorSnackBar(context, state.failure.message);
          } else if (state is Authenticated || state is Unauthenticated) {
            // Arrêter le chargement si on revient à un état stable
            // (AuthWrapper gère la navigation vers HomePage si Authenticated)
             setState(() { _isLoading = false; });
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
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un mot de passe';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _signIn, // Appelle la méthode _signIn
                          child: const Text('Se Connecter'),
                        ),
                     const SizedBox(height: 15), 
                  // Lien pour aller vers la page d'inscription
                  TextButton(
                    onPressed: _isLoading ? null : () { // Désactivé pendant le chargement
                      // Naviguer vers SignUpPage
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BlocProvider.value( // Important: Fournir le Bloc existant
                            value: BlocProvider.of<AuthBloc>(context),
                            child: const SignUpPage(),
                         ),
                      ));
                    },
                    child: const Text('Pas encore de compte ? S\'inscrire'),
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