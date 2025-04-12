import 'dart:async';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

// Ce use case est un peu spécial car il retourne un Stream directement.
// Il n'étend pas notre UseCase de base pour Future<Either>.
class GetAuthStatus {
  final AuthRepository repository;

  GetAuthStatus(this.repository);

  // L'appel retourne directement le stream du repository
  Stream<User?> call() {
    return repository.authStatusChanges;
  }
}