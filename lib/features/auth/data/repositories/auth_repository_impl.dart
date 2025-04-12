import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
// Importez les éléments du domain nécessaires
import '../../domain/entities/user.dart' as domain_user; // Alias pour notre User
import '../../domain/repositories/auth_repository.dart';
// Importez la data source
import '../datasources/firebase_auth_data_source.dart';


class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource firebaseDataSource;
 

  AuthRepositoryImpl({
    required this.firebaseDataSource,
    // required this.networkInfo,
  });

  @override
  Stream<domain_user.User?> get authStatusChanges {
    return firebaseDataSource.authStateChanges.map((firebaseUser) {
      // Mapper l'utilisateur Firebase vers notre User du domaine
      return firebaseUser == null
          ? null 
          : _mapFirebaseUserToDomainUser(firebaseUser);
    });
  }

  @override
  Future<Either<Failure, domain_user.User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {

    try {
      final userCredential = await firebaseDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
     
      if (userCredential.user == null) {
         return Left(ServerFailure(message: 'Impossible de récupérer les informations utilisateur après connexion.'));
      }
      return Right(_mapFirebaseUserToDomainUser(userCredential.user!));
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Mapper les erreurs Firebase Auth vers nos Failures personnalisées
      return Left(_mapAuthExceptionToFailure(e));
    } catch (e) {
      // Gérer les autres erreurs imprévues
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, domain_user.User>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseDataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
       if (userCredential.user == null) {
         return Left(ServerFailure(message: 'Impossible de récupérer les informations utilisateur après inscription.'));
      }
   
      return Right(_mapFirebaseUserToDomainUser(userCredential.user!));
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(_mapAuthExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<void> signOut() async {
    
    await firebaseDataSource.signOut();
  }

  // --- Helper Methods ---

  // Fonction privée pour mapper l'utilisateur Firebase vers notre User domaine
  domain_user.User _mapFirebaseUserToDomainUser(firebase_auth.User firebaseUser) {
    return domain_user.User(
      id: firebaseUser.uid,
      email: firebaseUser.email,
      
    );
  }

  // Fonction privée pour mapper les exceptions Firebase Auth vers nos Failures
  Failure _mapAuthExceptionToFailure(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
      case 'wrong-password':
      case 'invalid-credential': // Pourrait être email ou mdp invalide
        return const InvalidCredentialsFailure();
      case 'user-not-found':
        return const UserNotFoundFailure();
      case 'email-already-in-use':
        return const EmailInUseFailure();
      case 'weak-password':
        return const WeakPasswordFailure();
       case 'operation-not-allowed':
         return const OperationNotAllowedFailure();
      
      default:
        // Pour les autres erreurs Firebase non gérées explicitement
        return AuthFailure(message: e.message ?? 'Erreur d\'authentification inconnue');
    }
  }
}