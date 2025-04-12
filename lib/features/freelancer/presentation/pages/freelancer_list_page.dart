import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart'; // Importer sl pour créer le Bloc
import '../bloc/freelancer_bloc.dart'; // Importer le Bloc, State, Event
import '../widgets/freelancer_list_item.dart'; // Importer le widget d'item

class FreelancerListPage extends StatelessWidget {
  const FreelancerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Utiliser BlocProvider pour créer et fournir une instance de FreelancerBloc
    // à cet endroit de l'arbre de widgets.
    return BlocProvider(
      create: (context) => sl<FreelancerBloc>() // Récupérer le Bloc depuis GetIt
        ..add(FetchFreelancers()), // IMPORTANT: Envoyer l'événement initial pour charger les données
      child: Scaffold( // Un Scaffold pour la structure de base de la page
      
        
        body: RefreshIndicator( // Permet le "Pull-to-refresh"
           onRefresh: () async {
             // Déclencher à nouveau le fetch lors du refresh
             context.read<FreelancerBloc>().add(FetchFreelancers());
             // Attendre la fin de la mise à jour (optionnel mais bonne pratique)
             // On peut écouter le stream du bloc pour savoir quand c'est fini
             await context.read<FreelancerBloc>().stream.firstWhere((state) => state is! FreelancerLoading);
           },
           child: BlocBuilder<FreelancerBloc, FreelancerState>(
            builder: (context, state) {
              // Afficher un indicateur de chargement
              if (state is FreelancerLoading || state is FreelancerInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              // Afficher la liste si chargée
              else if (state is FreelancerLoaded) {
                 // Gérer le cas où la liste est vide
                 if (state.freelancers.isEmpty) {
                    return const Center(child: Text('Aucun freelance trouvé.'));
                 }
                 // Construire la liste
                return ListView.builder(
                  itemCount: state.freelancers.length,
                  itemBuilder: (context, index) {
                    final freelancer = state.freelancers[index];
                    return FreelancerListItem(freelancer: freelancer);
                  },
                );
              }
              // Afficher un message d'erreur
              else if (state is FreelancerError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Erreur: ${state.message}'),
                      const SizedBox(height: 10),
                      ElevatedButton(
                         onPressed: () => context.read<FreelancerBloc>().add(FetchFreelancers()),
                         child: const Text('Réessayer'),
                       )
                    ],
                  ),
                );
              }
              // État par défaut (ne devrait pas arriver)
              else {
                return const Center(child: Text('Quelque chose s\'est mal passé.'));
              }
            },
                   ),
        ),
      ),
    );
  }
}