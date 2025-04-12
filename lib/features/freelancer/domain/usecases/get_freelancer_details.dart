import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart'; // Pour les Params si besoin

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/freelancer.dart';
import '../repositories/freelancer_repository.dart';

// Use case pour récupérer les détails d'un freelance par ID
class GetFreelancerDetails implements UseCase<Freelancer, String> {
  final FreelancerRepository repository;

  GetFreelancerDetails(this.repository);

  // Prend l'ID en paramètre et retourne Either<Failure, Freelancer>
  @override
  Future<Either<Failure, Freelancer>> call(String id) async {
    // Vous pouvez ajouter une validation ici si l'ID ne doit pas être vide
    if (id.isEmpty) {
      return Left(ServerFailure(message: 'L\'ID du freelance ne peut pas être vide'));
    }
    return await repository.getFreelancerDetails(id);
  }
}