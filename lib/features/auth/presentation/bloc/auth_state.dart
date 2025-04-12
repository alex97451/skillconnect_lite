part of 'auth_bloc.dart'; // Indique que ce fichier fait partie de auth_bloc.dart

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// État initial, avant toute vérification
class AuthInitial extends AuthState {}

// État pendant une opération (connexion, inscription...)
class AuthLoading extends AuthState {}

// État lorsque l'utilisateur est authentifié
class Authenticated extends AuthState {
  final User user; // Contient les informations de l'utilisateur connecté

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

// État lorsque l'utilisateur n'est pas authentifié
class Unauthenticated extends AuthState {}

// État lorsqu'une erreur s'est produite pendant une opération
class AuthFailureState extends AuthState {
  final Failure failure; // Contient l'objet Failure pour potentiellement afficher un message

  const AuthFailureState(this.failure);

  @override
  List<Object?> get props => [failure];
}