import 'package:flutter/material.dart';
import '../../domain/entities/freelancer.dart'; // Importer l'entité

class FreelancerListItem extends StatelessWidget {
  final Freelancer freelancer;

  const FreelancerListItem({required this.freelancer, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Afficher une image par défaut ou celle du freelance
      leading: CircleAvatar(
        // Utiliser NetworkImage si imageUrl existe, sinon une icône par défaut
        backgroundImage: freelancer.imageUrl != null && freelancer.imageUrl!.isNotEmpty
            ? NetworkImage(freelancer.imageUrl!)
            : null, // NetworkImage gère le chargement et le cache basique
        child: freelancer.imageUrl == null || freelancer.imageUrl!.isEmpty
            ? const Icon(Icons.person) // Icône par défaut si pas d'image
            : null,
      ),
      title: Text(freelancer.name),
      subtitle: Text(freelancer.primarySkill),
      // On pourrait ajouter un onTap pour aller vers une page de détail plus tard
      // onTap: () {
      //   // Logique de navigation vers les détails du freelance
      // },
    );
  }
}