# skillconnect_lite

## Description
skillconnect_lite/
└── lib/
    ├── core/                     # Code partagé et infrastructure
    │   ├── error/                # Exceptions personnalisées, Failures
    │   ├── usecases/             # Classe de base pour les Use Cases 
    │   ├── network/              # Utilitaires réseau (ex: vérifier connexion)
    │   ├── di/                   # Configuration de l'injection de dépendances (get_it)
    │   ├── theme/                # Thème de l'application
    │   ├── constants/            # Constantes globales
    │   └── utils/                # Fonctions utilitaires partagées
    │
    ├── features/                 # Dossier contenant toutes les fonctionnalités
    │   │
    │   ├── auth/                 # Fonctionnalité d'Authentification
    │   │   ├── domain/           # Logique métier pure (Coeur)
    │   │   │   ├── entities/     # Objets métier
    │   │   │   ├── repositories/ # Interfaces (contrats) pour les dépôts de données
    │   │   │   └── usecases/     # Actions spécifiques (ex: SignIn, GetAuthStatus)
    │   │   │
    │   │   ├── data/             # Implémentation de la récupération de données
    │   │   │   ├── models/       # Modèles de données (DTOs, ex: UserModel)
    │   │   │   ├── repositories/ # Implémentation des interfaces du Domain
    │   │   │   └── datasources/  # Sources de données (API Firebase, locale...)
    │   │   │
    │   │   └── presentation/     # Couche UI et gestion d'état
    │   │       ├── bloc/         # Blocs/Cubits, Events, States (ex: AuthBloc)
    │   │       ├── pages/        # Écrans/Pages principaux (ex: SignInPage)
    │   │       └── widgets/      # Widgets réutilisables pour cette fonctionnalité
    │   │
    │   └── freelancer/           # Fonctionnalité Freelance (Liste/Détail)
    │       ├── domain/
    │       │   ├── entities/     # ex: Freelancer
    │       │   ├── repositories/ # ex: FreelancerRepository
    │       │   └── usecases/     # ex: GetFreelancers, GetFreelancerDetails
    │       │
    │       ├── data/
    │       │   ├── models/       # ex: FreelancerModel
    │       │   ├── repositories/ # ex: FreelancerRepositoryImpl
    │       │   └── datasources/  # ex: FreelancerRemoteDataSource
    │       │
    │       └── presentation/
    │           ├── bloc/         # ex: FreelancerListBloc, FreelancerDetailCubit
    │           ├── pages/        # ex: FreelancerListPage, FreelancerDetailPage
    │           └── widgets/      # ex: FreelancerListItem
    │
    ├── main.dart                 # Point d'entrée de l'application 
    └── firebase_options.dart     # Configuration Firebase 