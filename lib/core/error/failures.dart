import 'package:equatable/equatable.dart';

// Classe abstraite de base pour toutes les erreurs (Failures)
// On utilise Equatable pour pouvoir comparer facilement les instances de Failure.
abstract class Failure extends Equatable {
  
  // const Failure([List properties = const <dynamic>[]]);

  @override
  List<Object?> get props => []; // Permet la comparaison basée sur les valeurs
}

