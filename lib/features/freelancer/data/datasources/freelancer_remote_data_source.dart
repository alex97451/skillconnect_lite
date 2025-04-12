import '../../../../core/error/exceptions.dart'; // Nos exceptions Data/Core
import '../models/freelancer_model.dart'; // Notre modèle Data

// Interface pour la source de données distante (même si simulée)
abstract class FreelancerRemoteDataSource {
  /// Récupère la liste des [FreelancerModel] depuis la source distante.
  ///
  /// Lance une [ServerException] en cas d'erreur serveur/API.
  Future<List<FreelancerModel>> getFreelancers();
}

// Implémentation simulée avec une liste codée en dur
class FreelancerRemoteDataSourceImpl implements FreelancerRemoteDataSource {

  // Notre liste simulée
  final List<FreelancerModel> _mockFreelancers = [
    const FreelancerModel(id: 'f1', name: 'Mohamed Dupont', primarySkill: 'Développement Flutter', imageUrl: null),
    const FreelancerModel(id: 'f2', name: 'Bob Jordan', primarySkill: 'Design UX/UI', imageUrl: null), // Mettez des URLs valides si vous testez l'affichage
    const FreelancerModel(id: 'f3', name: 'Alexandre Ecormier', primarySkill: 'FullStack', imageUrl: null),
    const FreelancerModel(id: 'f4', name: 'David Johan', primarySkill: 'Marketing Digital', imageUrl: null),
  ];

  @override
  Future<List<FreelancerModel>> getFreelancers() async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 800));

    // Simuler une erreur serveur une fois sur cinq (pour tester la gestion d'erreur)
    // if (DateTime.now().second % 5 == 0) {
    //   throw ServerException(message: 'Erreur simulée du serveur');
    // }

    // Retourner la liste simulée
    return _mockFreelancers;

    // --- Si on utilisait une vraie API avec http ---
    // final response = await http.get(Uri.parse('VOTRE_URL_API'));
    // if (response.statusCode == 200) {
    //   final List<dynamic> data = json.decode(response.body);
    //   return data.map((json) => FreelancerModel.fromJson(json)).toList();
    // } else {
    //   throw ServerException(message: 'Erreur API: ${response.statusCode}');
    // }
    // --------------------------------------------
  }
}