import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import pour FirebaseAuth

// Importer les couches pour l'authentification
// Data Sources
import 'features/auth/data/datasources/firebase_auth_data_source.dart';
// Repositories
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart'; // Interface Domain
// Use Cases
import 'features/auth/domain/usecases/get_auth_status.dart';
import 'features/auth/domain/usecases/sign_in.dart';
import 'features/auth/domain/usecases/sign_up.dart';
import 'features/auth/domain/usecases/sign_out.dart';

// Blocs
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Instance du Service Locator GetIt
final sl = GetIt.instance;

// Fonction d'initialisation pour enregistrer toutes les dépendances
void initDi() {

  // ========================================
  // Feature: Authentication
  // ========================================

// Blocs/Cubits (enregistrés comme factory car ils ont un état)
  sl.registerFactory(
    () => AuthBloc(
      getAuthStatus: sl(), // Injecte les Use Cases enregistrés
      signIn: sl(),
      signUp: sl(),
      signOut: sl(),
    ),
  );

  // Use Cases (enregistrés comme lazy singletons car ils n'ont pas d'état)
  sl.registerLazySingleton(() => GetAuthStatus(sl())); // sl() récupère l'instance AuthRepository enregistrée
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));

  // Repositories (enregistrer l'implémentation contre l'interface Domain)
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(firebaseDataSource: sl()),
   
  );

  // Data Sources
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSourceImpl(firebaseAuth: sl()),
  );



  // ========================================
  // Externes (dépendances externes comme FirebaseAuth, Connectivity...)
  // ========================================
  // Enregistre FirebaseAuth comme lazy singleton pour qu'il soit disponible
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  
}