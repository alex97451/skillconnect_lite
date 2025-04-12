import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUp implements UseCase<User, SignUpParams> {
  final AuthRepository repository;

  SignUp(this.repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    return await repository.signUpWithEmailAndPassword(
      email: params.email,
      password: params.password,
     
    );
  }
}

// Classe pour encapsuler les paramètres d'inscription
class SignUpParams extends Equatable {
  final String email;
  final String password;
  // Ajoutez d'autres champs si nécessaire (ex: final String name;)

  const SignUpParams({
    required this.email,
    required this.password,
    // required this.name
  });

  @override
  List<Object?> get props => [email, password /*, name */];
}