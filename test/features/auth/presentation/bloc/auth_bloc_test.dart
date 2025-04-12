import 'dart:async'; // Importer dart:async pour StreamController
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart'; // Importe bloc_test
import 'package:mocktail/mocktail.dart'; // Importe mocktail pour les mocks
import 'package:dartz/dartz.dart'; // Importe dartz pour Either

// Importer les classes à tester et leurs dépendances réelles
// Assurez-vous que les chemins d'importation correspondent à votre structure de projet
import 'package:skillconnect_lite/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:skillconnect_lite/features/auth/domain/entities/user.dart';
import 'package:skillconnect_lite/features/auth/domain/usecases/get_auth_status.dart';
import 'package:skillconnect_lite/features/auth/domain/usecases/sign_in.dart';
import 'package:skillconnect_lite/features/auth/domain/usecases/sign_up.dart';
import 'package:skillconnect_lite/features/auth/domain/usecases/sign_out.dart';
import 'package:skillconnect_lite/core/error/failures.dart';


// --- Création des Mocks ---
// Crée des classes Mock pour chaque Use Case dont AuthBloc dépend
class MockGetAuthStatus extends Mock implements GetAuthStatus {}
class MockSignIn extends Mock implements SignIn {}
class MockSignUp extends Mock implements SignUp {}
class MockSignOut extends Mock implements SignOut {}

void main() {
  // Déclarer les variables pour les mocks et le bloc
  late MockGetAuthStatus mockGetAuthStatus;
  late MockSignIn mockSignIn;
  late MockSignUp mockSignUp;
  late MockSignOut mockSignOut;
  late AuthBloc authBloc;
  // Ajouter un StreamController pour contrôler le stream d'auth
  late StreamController<User?> authStatusController;

  // --- Données de test ---
  const testUser = User(id: '123', email: 'test@example.com');
  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testSignInParams = SignInParams(email: testEmail, password: testPassword);
  const testSignUpParams = SignUpParams(email: testEmail, password: testPassword);
  const testServerFailure = ServerFailure(message: 'Erreur serveur');
  const testInvalidCredentialsFailure = InvalidCredentialsFailure();

  // --- Configuration avant chaque test ---
  setUp(() {
    // Initialiser le StreamController
    authStatusController = StreamController<User?>();
    // Initialiser les mocks
    mockGetAuthStatus = MockGetAuthStatus();
    mockSignIn = MockSignIn();
    mockSignUp = MockSignUp();
    mockSignOut = MockSignOut();

    // --- Comportement par défaut des Mocks ---
    // Configurer GetAuthStatus pour retourner le stream de notre contrôleur
    when(() => mockGetAuthStatus()).thenAnswer((_) => authStatusController.stream);

    // Initialiser le AuthBloc avec les mocks
    authBloc = AuthBloc(
      getAuthStatus: mockGetAuthStatus,
      signIn: mockSignIn,
      signUp: mockSignUp,
      signOut: mockSignOut,
    );
  });

  // --- Nettoyage après chaque test ---
  tearDown(() {
    authStatusController.close(); // Fermer le contrôleur de stream
    authBloc.close(); // Fermer le bloc pour annuler la souscription
  });

  // --- Tests ---

  test('l état initial devrait être AuthInitial', () {
    // Vérifier l'état immédiatement après la création du bloc
    expect(authBloc.state, equals(AuthInitial()));
  });

  group('GetAuthStatus Stream Handling (avec StreamController)', () {
    blocTest<AuthBloc, AuthState>(
      'devrait émettre [Authenticated] quand le contrôleur de stream émet un User',
      build: () => authBloc, // Utiliser le bloc déjà initialisé dans setUp
      act: (bloc) {
        // Déclencher l'émission de l'utilisateur PENDANT la phase `act`
        authStatusController.add(testUser);
      },
      // Attendre seulement l'état final car l'émission est contrôlée
      expect: () => <AuthState>[
        Authenticated(testUser),
      ],
       verify: (_) {
         // Vérifier que le stream a été écouté au moins une fois
         // (l'appel initial lors de la création du bloc)
         verify(() => mockGetAuthStatus()).called(1);
       }
    );

     blocTest<AuthBloc, AuthState>(
       'devrait émettre [Unauthenticated] quand le contrôleur de stream émet null',
       build: () => authBloc,
       act: (bloc) {
         // Déclencher l'émission de null PENDANT la phase `act`
         authStatusController.add(null);
       },
       // Attendre seulement l'état final
       expect: () => <AuthState>[
         Unauthenticated(),
       ],
       verify: (_) {
         verify(() => mockGetAuthStatus()).called(1);
       }
     );
  });


  group('AuthSignInRequested', () {
     blocTest<AuthBloc, AuthState>(
      'devrait émettre [AuthLoading, Authenticated] quand SignIn réussit',
      setUp: () {
        // Configurer le mock SignIn pour retourner un succès (Right)
        when(() => mockSignIn(testSignInParams))
            .thenAnswer((_) async => Right(testUser));
      },
      build: () => authBloc,
      act: (bloc) => bloc.add(AuthSignInRequested(email: testEmail, password: testPassword)),
      expect: () => <AuthState>[
        AuthLoading(),
        Authenticated(testUser),
      ],
      verify: (_) {
        // Vérifier que le Use Case SignIn a été appelé avec les bons paramètres
        verify(() => mockSignIn(testSignInParams)).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'devrait émettre [AuthLoading, AuthFailureState] quand SignIn échoue',
      setUp: () {
        // Configurer le mock SignIn pour retourner une erreur (Left)
        when(() => mockSignIn(testSignInParams))
            .thenAnswer((_) async => Left(testInvalidCredentialsFailure));
      },
      build: () => authBloc,
      act: (bloc) => bloc.add(AuthSignInRequested(email: testEmail, password: testPassword)),
      expect: () => <AuthState>[
        AuthLoading(),
        AuthFailureState(testInvalidCredentialsFailure), // Contient l'erreur
      ],
       verify: (_) {
        verify(() => mockSignIn(testSignInParams)).called(1);
      },
    );
  });

  group('AuthSignUpRequested', () {
     blocTest<AuthBloc, AuthState>(
      'devrait émettre [AuthLoading, Authenticated] quand SignUp réussit',
      setUp: () {
        when(() => mockSignUp(testSignUpParams))
            .thenAnswer((_) async => Right(testUser));
      },
      build: () => authBloc,
      act: (bloc) => bloc.add(AuthSignUpRequested(email: testEmail, password: testPassword)),
      expect: () => <AuthState>[
        AuthLoading(),
        Authenticated(testUser),
      ],
      verify: (_) {
        verify(() => mockSignUp(testSignUpParams)).called(1);
      },
    );

     blocTest<AuthBloc, AuthState>(
      'devrait émettre [AuthLoading, AuthFailureState] quand SignUp échoue',
      setUp: () {
         when(() => mockSignUp(testSignUpParams))
            .thenAnswer((_) async => Left(testServerFailure));
      },
      build: () => authBloc,
      act: (bloc) => bloc.add(AuthSignUpRequested(email: testEmail, password: testPassword)),
      expect: () => <AuthState>[
        AuthLoading(),
        AuthFailureState(testServerFailure),
      ],
       verify: (_) {
        verify(() => mockSignUp(testSignUpParams)).called(1);
      },
    );
  });

   group('AuthSignOutRequested', () {
     blocTest<AuthBloc, AuthState>(
       'devrait appeler SignOut UseCase mais ne pas émettre d état directement',
       setUp: () {
         when(() => mockSignOut()).thenAnswer((_) async => {}); // Simule succès void
       },
       build: () => authBloc,
       act: (bloc) => bloc.add(AuthSignOutRequested()),
       expect: () => <AuthState>[], // Aucun état émis DIRECTEMENT par ce handler
       verify: (_) {
         verify(() => mockSignOut()).called(1);
       },
     );

     // Test supplémentaire: si SignOut échouait et qu'on gérait l'erreur
      blocTest<AuthBloc, AuthState>(
       'devrait émettre [AuthFailureState] si SignOut échoue (si géré)',
       setUp: () {
         when(() => mockSignOut()).thenThrow(Exception('Déconnexion impossible'));
       },
       build: () => authBloc,
       act: (bloc) => bloc.add(AuthSignOutRequested()),
       expect: () => <AuthState>[
         AuthFailureState(AuthFailure(message: 'Erreur lors de la déconnexion: Exception: Déconnexion impossible')),
       ],
       verify: (_) {
         verify(() => mockSignOut()).called(1);
       },
     );
   });

}