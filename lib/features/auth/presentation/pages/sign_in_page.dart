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
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    if (_isLoading) return; // Ne rien faire si déjà en chargement
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(AuthSignInRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ));
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating, 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() { _isLoading = true; });
          } else if (state is AuthFailureState) {
            setState(() { _isLoading = false; });
            _showErrorSnackBar(context, state.failure.message);
          } else if (state is Authenticated || state is Unauthenticated) {
            // Gérer la fin du chargement si l'état redevient stable
            if (_isLoading) {
               setState(() { _isLoading = false; });
            }
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.connect_without_contact,
                        size: 60,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 20),

                      Text(
                        'Connexion',
                        style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          // Style de bordure via thème
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        validator: (value) {
                           if (value == null || value.isEmpty || !value.contains('@')) {
                             return 'Veuillez entrer un email valide';
                           }
                           return null;
                         },
                      ),
                      const SizedBox(height: 15),

                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Mot de passe',
                          prefixIcon: Icon(Icons.lock_outline),
                           // Style de bordure via thème
                        ),
                        obscureText: true,
                        validator: (value) {
                           if (value == null || value.isEmpty) {
                             return 'Veuillez entrer un mot de passe';
                           }
                           return null;
                         },
                      ),
                      const SizedBox(height: 30),

                      ElevatedButton(
                        onPressed: _isLoading ? null : _signIn,
                        // Style via thème
                        child: _isLoading
                            ? const SizedBox(
                                height: 24, width: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text('SE CONNECTER'),
                      ),
                      const SizedBox(height: 15),

                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: _isLoading ? null : () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                  value: BlocProvider.of<AuthBloc>(context),
                                  child: const SignUpPage(), // Assurez-vous que SignUpPage est importé
                               ),
                            ));
                          },
                          // Style via thème
                          child: const Text('Pas encore de compte ? S\'inscrire'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}