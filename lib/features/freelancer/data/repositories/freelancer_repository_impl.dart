import 'package:dartz/dartz.dart'; // Pour Either

import '../../../../core/error/exceptions.dart'; // Exceptions (ServerException...)
import '../../../../core/error/failures.dart'; // Failures (ServerFailure...)
import '../../domain/entities/freelancer.dart'; // Entité Domain
import '../../domain/repositories/freelancer_repository.dart'; // Interface Domain
import '../datasources/freelancer_remote_data_source.dart'; // Interface DataSource

class FreelancerRepositoryImpl implements FreelancerRepository {
  final FreelancerRemoteDataSource remoteDataSource;
  

  FreelancerRepositoryImpl({
    required this.remoteDataSource,
    
  });

  @override
  Future<Either<Failure, List<Freelancer>>> getFreelancers() async {
    

    try {
      // Appeler la source de données
      final remoteFreelancers = await remoteDataSource.getFreelancers();
      // Comme FreelancerModel étend Freelancer, on peut retourner directement la liste.
      // Si ce n'était pas le cas, il faudrait mapper ici :
      // return Right(remoteFreelancers.map((model) => model.toDomainEntity()).toList());
      return Right(remoteFreelancers);
    } on ServerException catch (e) {
      // En cas d'exception serveur de la datasource, retourner une ServerFailure
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      // Gérer toute autre exception imprévue comme une ServerFailure générique
      return Left(ServerFailure(message: 'Erreur inattendue: ${e.toString()}'));
    }
  }

  
}