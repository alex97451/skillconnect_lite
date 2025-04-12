import 'package:dartz/dartz.dart'; // Import pour Either
import '../../../../core/error/failures.dart'; // Import notre classe Failure
import '../entities/user.dart'; // Import notre entité User

abstract class AuthRepository {

  // Méthode pour obtenir le statut d'authentification actuel (flux continu)
  // Renvoie un Stream de User (peut être null si non connecté ou User.empty)
  Stream<User?> get authStatusChanges;

  // Méthode pour se connecter avec email/password
  // Renvoie soit une Failure, soit l'User connecté
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  // Méthode pour s'inscrire avec email/password
  // Renvoie soit une Failure, soit l'User créé
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    // Ajoutez d'autres champs si nécessaire (ex: name)
  });

  // Méthode pour se déconnecter
  // Renvoie Future<void> car une erreur ici est moins critique pour le flux principal
  // Ou pourrait renvoyer Future<Either<Failure, void>> si la gestion d'erreur est cruciale
  Future<void> signOut();

  // Ajoutez d'autres méthodes si nécessaire (ex: signInWithGoogle, resetPassword...)
}