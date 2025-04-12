import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Importer les éléments nécessaires du Domain et Core
import '../../domain/entities/freelancer.dart';
import '../../domain/usecases/get_freelancers.dart';
import '../../../../core/usecases/usecase.dart'; // Pour NoParams si GetFreelancers l'utilise
import '../../../../core/error/failures.dart'; // Pour Failure

// Lier les fichiers d'états et d'événements
part 'freelancer_event.dart';
part 'freelancer_state.dart';

class FreelancerBloc extends Bloc<FreelancerEvent, FreelancerState> {
  final GetFreelancers getFreelancers; // Injection du Use Case

  FreelancerBloc({required this.getFreelancers}) : super(FreelancerInitial()) {
    // Enregistrer le gestionnaire pour l'événement FetchFreelancers
    on<FetchFreelancers>(_onFetchFreelancers);
  }

  Future<void> _onFetchFreelancers(
    FetchFreelancers event,
    Emitter<FreelancerState> emit,
  ) async {
    emit(FreelancerLoading()); // Émettre l'état de chargement

    
    final result = await getFreelancers(); // Si use case utilise UseCaseWithoutParams

    // Gérer le résultat (soit Failure soit List<Freelancer>)
    result.fold(
      (failure) {
        // En cas d'échec (Left), émettre l'état d'erreur avec un message
        emit(FreelancerError(_mapFailureToMessage(failure)));
      },
      (freelancers) {
        // En cas de succès (Right), émettre l'état chargé avec la liste
        emit(FreelancerLoaded(freelancers));
      },
    );
  }

  // Fonction helper pour convertir une Failure en message String pour l'UI
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        // Utiliser le message de ServerFailure s'il existe, sinon un message générique
        return failure.message.isNotEmpty ? failure.message : 'Erreur Serveur';
      case CacheFailure:
        return failure.message.isNotEmpty ? failure.message : 'Erreur de Cache';
      case NetworkFailure:
         return failure.message.isNotEmpty ? failure.message : 'Erreur Réseau - Vérifiez votre connexion';
      default:
        return failure.message.isNotEmpty ? failure.message : 'Erreur Inattendue';
    }
  }
}