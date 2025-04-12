import '../../domain/entities/freelancer.dart'; // Importer l'entité

// Le modèle étend l'entité. C'est une simplification acceptable si les structures
// sont identiques et qu'aucune logique spécifique au modèle (comme fromJson)
// n'est nécessaire immédiatement.
class FreelancerModel extends Freelancer {
  const FreelancerModel({
    required super.id,
    required super.name,
    required super.primarySkill,
    super.imageUrl,
  });

  // --- Si on utilisait une vraie API JSON ---
  // factory FreelancerModel.fromJson(Map<String, dynamic> json) {
  //   return FreelancerModel(
  //     id: json['id'] as String,
  //     name: json['name'] as String,
  //     primarySkill: json['primarySkill'] as String,
  //     imageUrl: json['imageUrl'] as String?,
  //   );
  // }
  //
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'primarySkill': primarySkill,
  //     'imageUrl': imageUrl,
  //   };
  // }
  // -----------------------------------------
}