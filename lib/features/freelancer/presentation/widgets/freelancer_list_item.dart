import 'package:flutter/material.dart';
import '../../domain/entities/freelancer.dart'; // Importer l'entité

class FreelancerListItem extends StatelessWidget {
  final Freelancer freelancer;

  const FreelancerListItem({required this.freelancer, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Utiliser une Card pour chaque item
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Marge autour de la carte
      elevation: 2, // Légère ombre
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)), // Coins arrondis
      child: ListTile(
        contentPadding: const EdgeInsets.all(12.0), // Padding intérieur
        leading: CircleAvatar(
          radius: 25, // Taille de l'avatar
          backgroundColor: colorScheme.secondaryContainer, // Couleur de fond si image échoue/manque
          // Utiliser Image.network pour un meilleur contrôle du chargement/erreur
          child: freelancer.imageUrl != null && freelancer.imageUrl!.isNotEmpty
              ? ClipOval( // Pour s'assurer que l'image reste ronde
                  child: Image.network(
                    freelancer.imageUrl!,
                    fit: BoxFit.cover, // Couvrir l'espace de l'avatar
                    height: 50, // Taille de l'image = diamètre de l'avatar
                    width: 50,
                    // Afficher un indicateur pendant le chargement
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child; // Image chargée
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          // Calculer la progression si disponible
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    // Afficher une icône en cas d'erreur de chargement
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person_outline, // Ou Icons.broken_image_outlined
                        color: colorScheme.onSecondaryContainer,
                      );
                    },
                  ),
                )
              // Afficher une icône par défaut si pas d'URL
              : Icon(
                  Icons.person_outline,
                  color: colorScheme.onSecondaryContainer,
                ),
        ),
        title: Text(
            freelancer.name,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), // Nom en gras
        ),
        subtitle: Text(
            freelancer.primarySkill,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant), // Couleur pour sous-titre
        ),
        trailing: Icon(Icons.chevron_right, color: colorScheme.outline), // Indicateur pour action future
        onTap: () {
          // TODO: Implémenter la navigation vers la page de détail du freelance
          print('Tapped on ${freelancer.name}');
        },
      ),
    );
  }
}