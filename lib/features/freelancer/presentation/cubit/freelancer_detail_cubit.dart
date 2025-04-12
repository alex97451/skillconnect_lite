import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Importer les dépendances nécessaires
import '../../../../core/error/failures.dart';
import '../../domain/entities/freelancer.dart';
import '../../domain/usecases/get_freelancer_details.dart';

// Lier le fichier d'état
part 'freelancer_detail_state.dart';

class FreelancerDetailCubit extends Cubit<FreelancerDetailState> {
  final GetFreelancerDetails getFreelancerDetails; // Use Case injecté

  FreelancerDetailCubit({required this.getFreelancerDetails})
      : super(FreelancerDetailInitial()); // État initial

  // Méthode pour charger les détails
  Future<void> fetchFreelancerDetails(String id) async {
    emit(FreelancerDetailLoading()); // Émettre état chargement
    final result = await getFreelancerDetails(id); // Appeler le Use Case
    // Gérer le résultat
    result.fold(
      (failure) => emit(FreelancerDetailError(_mapFailureToMessage(failure))), // Échec
      (freelancer) => emit(FreelancerDetailLoaded(freelancer)), // Succès
    );
  }

  // Fonction helper pour mapper Failure en message (identique à celle de FreelancerBloc)
  String _mapFailureToMessage(Failure failure) {
     switch (failure.runtimeType) {
       case ServerFailure:
         return failure.message.isNotEmpty ? failure.message : 'Erreur Serveur';
       case CacheFailure:
         return failure.message.isNotEmpty ? failure.message : 'Erreur de Cache';
       case NetworkFailure:
          return failure.message.isNotEmpty ? failure.message : 'Erreur Réseau - Vérifiez votre connexion';
       default:
         // Inclure le message de la failure s'il existe, sinon un message générique
         return failure.message.isNotEmpty ? failure.message : 'Erreur Inattendue';
     }
   }
}