import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/freelancer_bloc.dart';
import '../widgets/freelancer_list_item.dart';

class FreelancerListPage extends StatelessWidget {
  const FreelancerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FreelancerBloc>()..add(FetchFreelancers()),
      child: Scaffold(
        // Pas d'AppBar ici car intégrée dans HomePage
        body: RefreshIndicator(
           onRefresh: () async {
             context.read<FreelancerBloc>().add(FetchFreelancers());
             await context.read<FreelancerBloc>().stream.firstWhere((state) => state is! FreelancerLoading);
           },
           // --- Modification du BlocBuilder ---
           child: BlocBuilder<FreelancerBloc, FreelancerState>(
            builder: (context, state) {
              // --- État Chargement / Initial Amélioré ---
              if (state is FreelancerLoading || state is FreelancerInitial) {
                return const Center(
                    child: Column( // Centrer verticalement
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text('Chargement des freelances...'),
                      ],
                    ),
                );
              }
              // --- État Chargé ---
              else if (state is FreelancerLoaded) {
                 // Gérer liste vide
                 if (state.freelancers.isEmpty) {
                    return const Center(
                        child: Column( // Centrer
                          mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                              Icon(Icons.people_outline, size: 48, color: Colors.grey),
                              SizedBox(height: 10),
                              Text('Aucun freelance trouvé pour le moment.'),
                           ],
                        )
                    );
                 }
                 // Afficher la liste avec padding
                return Padding( // Ajouter du padding autour de la liste
                  padding: const EdgeInsets.symmetric(vertical: 4.0), // Juste vertical pour coller aux bords si besoin
                  child: ListView.builder(
                    itemCount: state.freelancers.length,
                    itemBuilder: (context, index) {
                      final freelancer = state.freelancers[index];
                      return FreelancerListItem(freelancer: freelancer);
                    },
                  ),
                );
              }
              // --- État Erreur Amélioré ---
              else if (state is FreelancerError) {
                return Center(
                  child: Padding( // Ajouter du padding
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
                        const SizedBox(height: 10),
                        Text(
                          'Oops ! Une erreur est survenue :',
                           style: Theme.of(context).textTheme.titleMedium,
                           textAlign: TextAlign.center,
                        ),
                         const SizedBox(height: 5),
                        Text(
                          state.message, // Message d'erreur du Bloc
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon( // Bouton avec icône
                           icon: const Icon(Icons.refresh),
                           label: const Text('Réessayer'),
                           onPressed: () => context.read<FreelancerBloc>().add(FetchFreelancers()),
                         )
                      ],
                    ),
                  ),
                );
              }
              // État par défaut
              else {
                return const Center(child: Text('État inconnu.'));
              }
            },
           ),
        ),
      ),
    );
  }
}