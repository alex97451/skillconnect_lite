import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/freelancer.dart';
import '../repositories/freelancer_repository.dart';

class GetFreelancers implements UseCaseWithoutParams<List<Freelancer>> {
  final FreelancerRepository repository;

  GetFreelancers(this.repository);

  @override
  Future<Either<Failure, List<Freelancer>>> call() async {
    return await repository.getFreelancers();
  }
}