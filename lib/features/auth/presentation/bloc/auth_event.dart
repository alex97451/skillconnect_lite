part of 'auth_bloc.dart'; // Lié aussi à auth_bloc.dart

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Événement interne: le statut d'authentification a changé (via le Stream)
class AuthStatusChanged extends AuthEvent {
  final User? user; // L'utilisateur actuel (peut être null)

  const AuthStatusChanged(this.user);

  @override
  List<Object> get props => [user ?? Object()]; // Gérer le cas null pour props
}

// Événement: l'utilisateur demande à se connecter
class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

// Événement: l'utilisateur demande à s'inscrire
class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  

  const AuthSignUpRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

// Événement: l'utilisateur demande à se déconnecter
class AuthSignOutRequested extends AuthEvent {}