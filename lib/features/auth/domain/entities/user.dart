import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id; // Identifiant unique de l'utilisateur (ex: Firebase UID)
  final String? email; // Email de l'utilisateur (peut être null pour certains types d'auth)
  

  const User({
    required this.id,
    this.email,
    // required this.name,
  });

  // Un utilisateur "vide" ou "non authentifié" peut être utile
  static const empty = User(id: '');

  // Pour faciliter la détermination si l'utilisateur est authentifié
  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;


  @override
  List<Object?> get props => [id, email /*, name */];
}