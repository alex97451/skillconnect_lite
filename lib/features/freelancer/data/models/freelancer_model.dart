import '../../domain/entities/freelancer.dart'; // Importer l'entité

class FreelancerModel extends Freelancer {
 
  final String? description;


  const FreelancerModel({
    required super.id,
    required super.name,
    required super.primarySkill,
    super.imageUrl,
    this.description, // Paramètre dans le constructeur
  });

  // --- Méthodes fromJson/toJson (Optionnelles pour l'instant) ---
  // factory FreelancerModel.fromJson(Map<String, dynamic> json) {
  //   return FreelancerModel(
  //     id: json['id'] as String,
  //     name: json['name'] as String,
  //     primarySkill: json['primarySkill'] as String,
  //     imageUrl: json['imageUrl'] as String?,
  //     description: json['description'] as String?, // Inclure description
  //   );
  // }
  //
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'primarySkill': primarySkill,
  //     'imageUrl': imageUrl,
  //     'description': description, // Inclure description
  //   };
  // }
  // ----------------------------------------------------------
}