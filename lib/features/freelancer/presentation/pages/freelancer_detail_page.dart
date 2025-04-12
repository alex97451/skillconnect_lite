import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart'; // Pour sl
import '../../domain/entities/freelancer.dart'; // Entité
import '../cubit/freelancer_detail_cubit.dart'; // Cubit et State
import '../../data/models/freelancer_model.dart';
class FreelancerDetailPage extends StatelessWidget {
  final String freelancerId; // ID reçu en paramètre

  const FreelancerDetailPage({required this.freelancerId, super.key});

  @override
  Widget build(BuildContext context) {
    // Fournir le Cubit et déclencher le fetch initial
    return BlocProvider(
      create: (context) => sl<FreelancerDetailCubit>()
        ..fetchFreelancerDetails(freelancerId), // Appel fetch initial
      child: Scaffold(
        appBar: AppBar(
          // Le titre sera défini dynamiquement dans le builder si état Loaded
          title: BlocBuilder<FreelancerDetailCubit, FreelancerDetailState>(
            builder: (context, state) {
              if (state is FreelancerDetailLoaded) {
                return Text(state.freelancer.name); // Afficher nom dans l'AppBar
              }
              return const Text('Détails'); // Titre par défaut ou pendant chargement
            },
          ),
        ),
        body: BlocBuilder<FreelancerDetailCubit, FreelancerDetailState>(
          builder: (context, state) {
            // Affichage selon l'état
            if (state is FreelancerDetailLoading || state is FreelancerDetailInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FreelancerDetailLoaded) {
              // Construire l'UI des détails une fois les données chargées
              return _buildFreelancerDetails(context, state.freelancer);
            } else if (state is FreelancerDetailError) {
              // Affichage de l'erreur (similaire à la page liste)
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
                       const SizedBox(height: 10),
                       Text('Erreur: ${state.message}', textAlign: TextAlign.center),
                       const SizedBox(height: 20),
                       ElevatedButton.icon(
                         icon: const Icon(Icons.refresh),
                         label: const Text('Réessayer'),
                         // Relancer le fetch en cas d'erreur
                         onPressed: () => context.read<FreelancerDetailCubit>().fetchFreelancerDetails(freelancerId),
                       )
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('État inconnu'));
            }
          },
        ),
      ),
    );
  }

  // Widget helper pour construire l'affichage des détails du freelance
  Widget _buildFreelancerDetails(BuildContext context, Freelancer freelancer) {
     final textTheme = Theme.of(context).textTheme;
     final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView( // Permettre le défilement
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligner texte à gauche par défaut
        children: [
          Center( // Centrer la partie haute (Avatar, Nom, Compétence)
            child: Column(
              children: [
                 CircleAvatar(
                    radius: 50,
                    backgroundColor: colorScheme.secondaryContainer,
                     child: freelancer.imageUrl != null && freelancer.imageUrl!.isNotEmpty
                         ? ClipOval(
                           child: Image.network(
                             freelancer.imageUrl!,
                             fit: BoxFit.cover, height: 100, width: 100,
                             // Ajouter loading/error builder pour robustesse
                             loadingBuilder: (context, child, progress) => progress == null ? child : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                             errorBuilder: (context, error, stack) => Icon(Icons.person_outline, size: 50, color: colorScheme.onSecondaryContainer),
                           )
                         )
                         : Icon(Icons.person_outline, size: 50, color: colorScheme.onSecondaryContainer),
                  ),
                  const SizedBox(height: 12),
                  Text(
                     freelancer.name,
                     style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                     textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                     freelancer.primarySkill,
                     style: textTheme.titleMedium?.copyWith(color: colorScheme.primary),
                      textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Divider(), // Séparateur visuel
          const SizedBox(height: 16),

          // Section "À propos"
          Text(
            'À propos',
            style: textTheme.titleLarge, // Style pour les titres de section
          ),
          const SizedBox(height: 8),
          Text(
            // Utiliser la description ajoutée au modèle/données simulées
            (freelancer is FreelancerModel && freelancer.description != null && freelancer.description!.isNotEmpty)
               ? freelancer.description!
               : 'Aucune description disponible.',
            style: textTheme.bodyMedium?.copyWith(height: 1.5), // Interligne pour lisibilité
          ),
          const SizedBox(height: 24),

          // Section Contact (Exemple)
          Text(
            'Contact',
             style: textTheme.titleLarge,
          ),
           const SizedBox(height: 8),
           Center( // Centrer le bouton
             child: ElevatedButton.icon(
               icon: const Icon(Icons.contact_mail_outlined),
               label: const Text('Contacter'),
               style: ElevatedButton.styleFrom( // Style un peu différent
                   backgroundColor: colorScheme.secondary,
                   foregroundColor: colorScheme.onSecondary
               ),
               onPressed: () {
                
                 print('Contacter ${freelancer.name}');
                 ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fonctionnalité de contact non implémentée.'))
                 );
               },
             ),
           )
         
        ],
      ),
    );
  }
}