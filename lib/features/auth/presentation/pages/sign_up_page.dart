import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() {
     if (_isLoading) return;
    if (_formKey.currentState!.validate()) {
      // La validation de correspondance est déjà dans le validator du champ confirm
      context.read<AuthBloc>().add(AuthSignUpRequested(
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
     // appBar: AppBar(title: const Text('Inscription')), // Optionnel, titre dans le body
     body: BlocListener<AuthBloc, AuthState>(
       listener: (context, state) {
         if (state is AuthLoading) {
           setState(() { _isLoading = true; });
         } else if (state is AuthFailureState) {
           setState(() { _isLoading = false; });
           _showErrorSnackBar(context, state.failure.message);
         } else if (state is Authenticated || state is Unauthenticated) {
           if (_isLoading) {
              setState(() { _isLoading = false; });
           }
           // La redirection vers HomePage si Authenticated est gérée par AuthWrapper
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
                       Icons.person_add_alt_1,
                       size: 60,
                       color: colorScheme.primary,
                     ),
                     const SizedBox(height: 20),

                     Text(
                       'Inscription',
                       style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                       textAlign: TextAlign.center,
                     ),
                     const SizedBox(height: 40),

                     TextFormField(
                       controller: _emailController,
                       decoration: const InputDecoration(
                         labelText: 'Email',
                         prefixIcon: Icon(Icons.email_outlined),
                         // Style via thème
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
                          // Style via thème
                       ),
                       obscureText: true,
                        validator: (value) {
                           if (value == null || value.length < 6) {
                             return 'Le mot de passe doit faire au moins 6 caractères';
                           }
                           return null;
                         },
                     ),
                      const SizedBox(height: 15),

                     TextFormField(
                       controller: _confirmPasswordController,
                       decoration: const InputDecoration(
                         labelText: 'Confirmer le mot de passe',
                         prefixIcon: Icon(Icons.password),
                          // Style via thème
                       ),
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
                     const SizedBox(height: 30),

                     ElevatedButton(
                       onPressed: _isLoading ? null : _signUp,
                       // Style via thème
                       child: _isLoading
                           ? const SizedBox(
                               height: 24, width: 24,
                               child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                             )
                           : const Text('S\'INSCRIRE'),
                     ),
                     const SizedBox(height: 15),

                     Align(
                       alignment: Alignment.center,
                       child: TextButton(
                         onPressed: _isLoading ? null : () {
                           if (Navigator.canPop(context)) {
                             Navigator.pop(context); // Retourne à SignInPage
                           }
                         },
                         // Style via thème
                         child: const Text('Déjà un compte ? Se connecter'),
                       ),
                     )
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