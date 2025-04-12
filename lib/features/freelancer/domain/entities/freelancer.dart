import 'package:equatable/equatable.dart';

class Freelancer extends Equatable {
  final String id;
  final String name;
  final String primarySkill;
  final String? imageUrl;

  const Freelancer({
    required this.id,
    required this.name,
    required this.primarySkill,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, primarySkill, imageUrl];
}