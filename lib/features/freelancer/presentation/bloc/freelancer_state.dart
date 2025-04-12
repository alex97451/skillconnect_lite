part of 'freelancer_bloc.dart'; // Lier au fichier du Bloc

abstract class FreelancerState extends Equatable {
  const FreelancerState();

  @override
  List<Object> get props => [];
}

// État initial ou non initialisé
class FreelancerInitial extends FreelancerState {}

// État pendant le chargement des données
class FreelancerLoading extends FreelancerState {}

// État lorsque les freelances sont chargés avec succès
class FreelancerLoaded extends FreelancerState {
  final List<Freelancer> freelancers; // La liste des freelances

  const FreelancerLoaded(this.freelancers);

  @override
  List<Object> get props => [freelancers];
}

// État en cas d'erreur lors du chargement
class FreelancerError extends FreelancerState {
  final String message; // Message d'erreur à afficher

  const FreelancerError(this.message);

  @override
  List<Object> get props => [message];
}