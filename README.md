
# SkillConnect Lite - Application Démo Flutter - ECORMIER ALEXANDRE - 0667125795
## EMAIL : alexecormier@gmail.com

Ce projet est une application Flutter de démonstration créée pour illustrer mes compétences en développement mobile.L'application simule une plateforme simple de mise en relation entre freelances et entreprises.

**Note :** Ceci est un projet de démonstration et n'est pas destiné à une utilisation en production. La source de données pour les freelances est actuellement simulée dans le code.

## Fonctionnalités Implémentées

* **Authentification Utilisateur :**
    * Inscription via Email/Mot de passe (Firebase Auth)
    * Connexion via Email/Mot de passe (Firebase Auth)
    * Déconnexion
    * Gestion de l'état d'authentification dans l'application
* **Fonctionnalité Freelance :**
    * Affichage d'une liste de freelances (données simulées)
    * Affichage d'une page de détails pour un freelance sélectionné
    * Gestion des états (chargement, succès, erreur)

## Architecture et Concepts Clés

Ce projet s'efforce de suivre les principes de la **Clean Architecture** et incorpore des éléments de **Domain-Driven Design (DDD)** :

* **Séparation en Couches :** `Domain`, `Data`, `Presentation` (+ `Core` pour les éléments partagés).
* **Feature-First :** Organisation du code par fonctionnalité (`auth`, `freelancer`).
* **Domain Layer :** Contient la logique métier pure, les entités et les interfaces de repositories. Indépendant des frameworks.
* **Data Layer :** Implémente les interfaces du Domain, gère les sources de données (Firebase, API simulée) et le mapping des modèles.
* **Presentation Layer :** Gère l'UI (Widgets Flutter) et l'état de l'interface avec :
    * **Bloc / Cubit** (`flutter_bloc`) pour la gestion d'état réactive.
    * **GetIt** (`get_it`) pour l'Injection de Dépendances (Service Locator).

## Technologies Utilisées

* **Langage :** Dart
* **Framework :** Flutter
* **Gestion d'état :** `flutter_bloc` (Bloc / Cubit)
* **Injection de Dépendances :** `get_it`
* **Backend (Authentification) :** Firebase Authentication
* **Réseau (Simulation) :** Données codées en dur dans `FreelancerRemoteDataSourceImpl` (pourrait être remplacé par `http` ou `dio`).
* **Égalité d'objets :** `equatable`
* **Programmation Fonctionnelle (Either) :** `dartz`
* **Tests :**
    * `flutter_test` (Tests Unitaires / Widgets)


## Configuration et Lancement

**Prérequis :**

* Flutter SDK (vérifiez votre version avec `flutter --version`)
* Un IDE (VS Code, Android Studio...)
* Un compte Firebase et un projet Firebase créé.

**Étapes :**

1.  **Cloner le Dépôt :**
    ```bash
    git clone <URL_DU_DEPOT>
    cd skillconnect_lite
    ```


3.  **Installer les Dépendances :**
    ```bash
    flutter pub get
    ```

4.  **Lancer l'Application :**
    ```bash
    flutter run
    ```
    (Sélectionnez un appareil ou un émulateur/simulateur).

## Structure du Projet (lib/)

* `lib/core/`: Utilitaires, erreurs, DI, thème, etc. partagés.
* `lib/features/`: Dossiers pour chaque fonctionnalité majeure.
    * `auth/`: Authentification (domain, data, presentation).
    * `freelancer/`: Gestion des freelances (domain, data, presentation).
* `lib/main.dart`: Point d'entrée et configuration initiale.
* `lib/injection_container.dart`: Configuration de GetIt.
* `lib/firebase_options.dart`: Options Firebase générées par FlutterFire CLI.

## Source de Données Simulée

Actuellement, la liste et les détails des freelances proviennent d'une liste codée en dur dans :
`lib/features/freelancer/data/datasources/freelancer_remote_data_source.dart`

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