import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

// Classe de base pour les Use Cases qui retournent un Future<Either<Failure, Type>>
// Type: Le type de retour en cas de succès
// Params: Le type des paramètres d'entrée (si nécessaire)
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// Classe de base pour les Use Cases qui ne prennent pas de paramètres
abstract class UseCaseWithoutParams<Type> {
  Future<Either<Failure, Type>> call();
}

// Classe helper pour quand un Use Case ne prend aucun paramètre
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

