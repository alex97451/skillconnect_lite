part of 'freelancer_detail_cubit.dart'; // Sera lié au fichier Cubit

abstract class FreelancerDetailState extends Equatable {
  const FreelancerDetailState();
  @override
  List<Object> get props => [];
}

class FreelancerDetailInitial extends FreelancerDetailState {}

class FreelancerDetailLoading extends FreelancerDetailState {}

class FreelancerDetailLoaded extends FreelancerDetailState {
  final Freelancer freelancer;
  const FreelancerDetailLoaded(this.freelancer);
  @override List<Object> get props => [freelancer];
}

class FreelancerDetailError extends FreelancerDetailState {
  final String message;
  const FreelancerDetailError(this.message);
  @override List<Object> get props => [message];
}