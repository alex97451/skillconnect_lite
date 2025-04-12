import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Importer les éléments nécessaires du Domain et Core
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_auth_status.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/sign_out.dart';
import '../../../../core/error/failures.dart';

// Lier les fichiers d'états et d'événements
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetAuthStatus _getAuthStatus;
  final SignIn _signIn;
  final SignUp _signUp;
  final SignOut _signOut;
  StreamSubscription<User?>? _authStatusSubscription; // Pour gérer l'écoute du stream

  AuthBloc({
    required GetAuthStatus getAuthStatus,
    required SignIn signIn,
    required SignUp signUp,
    required SignOut signOut,
  })  : _getAuthStatus = getAuthStatus,
        _signIn = signIn,
        _signUp = signUp,
        _signOut = signOut,
        super(AuthInitial()) { // État initial

    // --- Enregistrer les gestionnaires d'événements ---

    // Écouter les changements de statut d'authentification
    on<AuthStatusChanged>(_onAuthStatusChanged);

    // Gérer la demande de connexion
    on<AuthSignInRequested>(_onSignInRequested);

    // Gérer la demande d'inscription
    on<AuthSignUpRequested>(_onSignUpRequested);

    // Gérer la demande de déconnexion
    on<AuthSignOutRequested>(_onSignOutRequested);

    // --- Démarrer l'écoute du stream d'authentification ---
    _startListeningToAuthChanges();
  }

  void _startListeningToAuthChanges() {
     // Annuler l'ancienne souscription si elle existe
    _authStatusSubscription?.cancel();
    // Écouter le stream venant du Use Case
    _authStatusSubscription = _getAuthStatus().listen((user) {
      // Ajouter un événement interne AuthStatusChanged au Bloc lui-même
      add(AuthStatusChanged(user));
    });
  }

  // --- Gestionnaires d'événements spécifiques ---

  void _onAuthStatusChanged(AuthStatusChanged event, Emitter<AuthState> emit) {
    if (event.user != null && event.user != User.empty) {
      // Si l'utilisateur existe (et n'est pas notre User.empty), émettre Authenticated
      emit(Authenticated(event.user!));
    } else {
      // Sinon, émettre Unauthenticated
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignInRequested(AuthSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading()); // Indiquer le chargement
    final result = await _signIn(SignInParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(AuthFailureState(failure)), // Émettre l'état d'échec
      (user) {
         // Sur succès, on pourrait émettre Authenticated ici pour une màj UI immédiate,
         // mais on va surtout compter sur le AuthStatusChanged qui suivra.
         // Pour une meilleure UX, émettons quand même :
         emit(Authenticated(user));
      }
    );
  }

   Future<void> _onSignUpRequested(AuthSignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _signUp(SignUpParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(AuthFailureState(failure)),
      (user) {
          // Émettre Authenticated pour feedback immédiat si souhaité.
          // Le stream AuthStatusChanged confirmera l'état de toute façon.
         emit(Authenticated(user));
      }
    );
  }

   Future<void> _onSignOutRequested(AuthSignOutRequested event, Emitter<AuthState> emit) async {
     // Optionnel: émettre AuthLoading() si la déconnexion peut prendre du temps
     // emit(AuthLoading());
     try {
       await _signOut();
       // NE PAS émettre Unauthenticated ici. Laisser _onAuthStatusChanged le faire
       // quand le stream notifiera la déconnexion.
     } catch (e) {
       // Gérer une erreur de déconnexion si nécessaire, peut-être avec un état spécifique
       // ou un AuthFailureState. Pour l'instant, on suppose que ça réussit.
       emit(AuthFailureState(AuthFailure(message: 'Erreur lors de la déconnexion: ${e.toString()}')));
     }
   }


  // --- Nettoyage ---
  @override
  Future<void> close() {
    // Très important : annuler la souscription au stream pour éviter les fuites mémoire
    _authStatusSubscription?.cancel();
    return super.close();
  }
}