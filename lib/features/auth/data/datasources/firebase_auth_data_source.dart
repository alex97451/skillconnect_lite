import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // Alias pour éviter conflit nom User

// Interface pour la source de données Firebase Auth
abstract class FirebaseAuthDataSource {
  Stream<firebase_auth.User?> get authStateChanges;
  Future<firebase_auth.UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<firebase_auth.UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signOut();
  
}

// Implémentation concrète utilisant le package firebase_auth
class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSourceImpl({firebase_auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance; // Injection ou instance par défaut

  @override
  Stream<firebase_auth.User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<firebase_auth.UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // La gestion d'erreur (try-catch pour FirebaseAuthException)
    // sera faite dans le RepositoryImpl pour mapper vers nos Failures.
    // Ici, on laisse l'exception remonter si elle se produit.
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<firebase_auth.UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}