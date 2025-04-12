import '../../../../core/usecases/usecase.dart'; // Pour NoParams si on utilisait une base void
import '../repositories/auth_repository.dart';


class SignOut {
  final AuthRepository repository;

  SignOut(this.repository);

  // L'appel retourne directement le Future<void> du repository
  Future<void> call() async {
    
    await repository.signOut();
    
  }
}