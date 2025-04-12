import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

// Importer les classes à tester et leurs dépendances
import 'package:skillconnect_lite/features/freelancer/presentation/bloc/freelancer_bloc.dart';
import 'package:skillconnect_lite/features/freelancer/domain/usecases/get_freelancers.dart';
import 'package:skillconnect_lite/features/freelancer/domain/entities/freelancer.dart';
import 'package:skillconnect_lite/core/error/failures.dart';
// Potentiellement core/usecases/usecase.dart si GetFreelancers utilisait NoParams explicitement

// --- Création du Mock ---
class MockGetFreelancers extends Mock implements GetFreelancers {}

void main() {
  // Déclarations
  late MockGetFreelancers mockGetFreelancers;
  late FreelancerBloc freelancerBloc;

  // --- Données de test ---
  const tFreelancer1 = Freelancer(id: 'f1', name: 'Alice', primarySkill: 'Flutter Dev');
  const tFreelancer2 = Freelancer(id: 'f2', name: 'Bob', primarySkill: 'Designer');
  const tFreelancerList = [tFreelancer1, tFreelancer2];
  const tServerFailure = ServerFailure(message: 'Erreur serveur simulée');
  const tNetworkFailure = NetworkFailure(message: 'Erreur réseau simulée');

  // --- Configuration avant chaque test ---
  setUp(() {
    mockGetFreelancers = MockGetFreelancers();
    freelancerBloc = FreelancerBloc(getFreelancers: mockGetFreelancers);
  });

  // --- Tests ---

  test('l état initial devrait être FreelancerInitial', () {
    expect(freelancerBloc.state, equals(FreelancerInitial()));
  });

  group('FetchFreelancers Event', () {

    // Test du cas succès
    blocTest<FreelancerBloc, FreelancerState>(
      'devrait émettre [FreelancerLoading, FreelancerLoaded] quand GetFreelancers réussit',
      setUp: () {
        // Configurer le mock pour retourner la liste avec succès (Right)
        when(() => mockGetFreelancers()) // Pas de paramètre ici car UseCaseWithoutParams
            .thenAnswer((_) async => const Right(tFreelancerList));
      },
      build: () => freelancerBloc, // Utiliser le bloc du setUp
      act: (bloc) => bloc.add(FetchFreelancers()), // Ajouter l'événement
      expect: () => <FreelancerState>[
        FreelancerLoading(), // Attend l'état de chargement
        const FreelancerLoaded(tFreelancerList), // Attend l'état chargé avec la liste
      ],
      verify: (_) {
        // Vérifier que le use case a été appelé une fois
        verify(() => mockGetFreelancers()).called(1);
        // S'assurer qu'aucune autre interaction n'a eu lieu avec ce mock
        verifyNoMoreInteractions(mockGetFreelancers);
      },
    );

    // Test du cas échec (ServerFailure)
    blocTest<FreelancerBloc, FreelancerState>(
      'devrait émettre [FreelancerLoading, FreelancerError] avec msg serveur quand GetFreelancers retourne ServerFailure',
      setUp: () {
        // Configurer le mock pour retourner une erreur serveur (Left)
        when(() => mockGetFreelancers())
            .thenAnswer((_) async => const Left(tServerFailure));
      },
      build: () => freelancerBloc,
      act: (bloc) => bloc.add(FetchFreelancers()),
      expect: () => <FreelancerState>[
        FreelancerLoading(),
        // Attend l'état d'erreur avec le message mappé depuis la failure
        FreelancerError(tServerFailure.message),
      ],
       verify: (_) {
        verify(() => mockGetFreelancers()).called(1);
        verifyNoMoreInteractions(mockGetFreelancers);
      },
    );

     // Test du cas échec (NetworkFailure)
     blocTest<FreelancerBloc, FreelancerState>(
      'devrait émettre [FreelancerLoading, FreelancerError] avec msg réseau quand GetFreelancers retourne NetworkFailure',
      setUp: () {
        // Configurer le mock pour retourner une erreur réseau (Left)
        when(() => mockGetFreelancers())
            .thenAnswer((_) async => const Left(tNetworkFailure));
      },
      build: () => freelancerBloc,
      act: (bloc) => bloc.add(FetchFreelancers()),
      expect: () => <FreelancerState>[
        FreelancerLoading(),
        // Attend l'état d'erreur avec le message mappé
        FreelancerError(tNetworkFailure.message), // Utiliser le message spécifique de NetworkFailure
      ],
       verify: (_) {
        verify(() => mockGetFreelancers()).called(1);
        verifyNoMoreInteractions(mockGetFreelancers);
      },
    );

     // Test du cas échec (autre Failure)
     blocTest<FreelancerBloc, FreelancerState>(
      'devrait émettre [FreelancerLoading, FreelancerError] avec msg générique pour autres Failures',
      setUp: () {
         // Utiliser une failure personnalisée ou une non mappée explicitement
         const otherFailure = CacheFailure(message: 'Erreur cache spécifique');
         when(() => mockGetFreelancers())
             .thenAnswer((_) async => const Left(otherFailure));
      },
      build: () => freelancerBloc,
      act: (bloc) => bloc.add(FetchFreelancers()),
      expect: () => <FreelancerState>[
        FreelancerLoading(),
        // Attend l'état d'erreur avec le message de la failure
        const FreelancerError('Erreur cache spécifique'),
      ],
       verify: (_) {
        verify(() => mockGetFreelancers()).called(1);
        verifyNoMoreInteractions(mockGetFreelancers);
      },
    );
  });
}