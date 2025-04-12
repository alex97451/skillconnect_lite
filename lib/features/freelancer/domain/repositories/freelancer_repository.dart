import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/freelancer.dart';

abstract class FreelancerRepository {
  Future<Either<Failure, List<Freelancer>>> getFreelancers();
   Future<Either<Failure, Freelancer>> getFreelancerDetails(String id);
}