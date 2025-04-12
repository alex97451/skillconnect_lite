import 'package:equatable/equatable.dart';

// Classe abstraite de base
abstract class Failure extends Equatable {
  final String message; // Ajout d'un message pour plus de détails

  const Failure({this.message = 'Une erreur est survenue'});

  @override
  List<Object?> get props => [message];
}

// --- Erreurs Générales ---
class ServerFailure extends Failure {
  const ServerFailure({String message = 'Erreur Serveur'}) : super(message: message);
}

class CacheFailure extends Failure {
   const CacheFailure({String message = 'Erreur de Cache'}) : super(message: message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'Erreur Réseau'}) : super(message: message);
}

// --- Erreurs Spécifiques à l'Authentification ---
class AuthFailure extends Failure {
  const AuthFailure({String message = 'Erreur d\'authentification'}) : super(message: message);
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure({String message = 'Identifiants invalides'}) : super(message: message);
}

class EmailInUseFailure extends AuthFailure {
  const EmailInUseFailure({String message = 'Cet email est déjà utilisé'}) : super(message: message);
}

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure({String message = 'Le mot de passe est trop faible'}) : super(message: message);
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure({String message = 'Utilisateur non trouvé'}) : super(message: message);
}

class OperationNotAllowedFailure extends AuthFailure {
  const OperationNotAllowedFailure({String message = 'Opération non autorisée'}) : super(message: message);
}

