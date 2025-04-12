part of 'freelancer_bloc.dart'; // Lier au fichier du Bloc

abstract class FreelancerEvent extends Equatable {
  const FreelancerEvent();

  @override
  List<Object> get props => [];
}

// Événement pour demander la récupération de la liste des freelances
class FetchFreelancers extends FreelancerEvent {}

