
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

```text
skillconnect_lite/
└── lib/
    ├── core/                     # Code partagé et infrastructure
    │   ├── error/                # Exceptions personnalisées, Failures
    │   ├── usecases/             # Classe de base pour les Use Cases
    │   ├── network/              # (Optionnel) Utilitaires réseau
    │   ├── di/                   # (Optionnel) Emplacement alternatif pour DI
    │   ├── theme/                # (Optionnel) Thème explicite
    │   ├── constants/            # (Optionnel) Constantes globales
    │   └── utils/                # (Optionnel) Fonctions utilitaires partagées
    │
    ├── features/                 # Dossier contenant toutes les fonctionnalités
    │   │
    │   ├── auth/                 # Fonctionnalité d'Authentification
    │   │   ├── domain/           # Couche Domaine (Logique métier pure)
    │   │   │   ├── entities/     #   - Objets métier (User)
    │   │   │   ├── repositories/ #   - Interfaces Repository (AuthRepository)
    │   │   │   └── usecases/     #   - Cas d'utilisation (SignIn, SignUp...)
    │   │   │
    │   │   ├── data/             # Couche Data (Accès données)
    │   │   │   ├── datasources/  #   - Sources de données (FirebaseAuthDataSource)
    │   │   │   ├── models/       #   - (Optionnel) Modèles de données (UserModel)
    │   │   │   └── repositories/ #   - Implémentation Repository (AuthRepositoryImpl)
    │   │   │
    │   │   └── presentation/     # Couche Présentation (UI & État UI)
    │   │       ├── bloc/         #   - Bloc, Event, State (AuthBloc...)
    │   │       ├── pages/        #   - Écrans (AuthWrapper, SignInPage...)
    │   │       └── widgets/      #   - (Optionnel) Widgets spécifiques Auth
    │   │
    │   └── freelancer/           # Fonctionnalité Freelance
    │       ├── domain/           # Couche Domaine
    │       │   ├── entities/     #   - Entité (Freelancer)
    │       │   ├── repositories/ #   - Interface (FreelancerRepository)
    │       │   └── usecases/     #   - Cas d'utilisation (GetFreelancers...)
    │       │
    │       ├── data/             # Couche Data
    │       │   ├── datasources/  #   - Source de données (FreelancerRemoteDataSource)
    │       │   ├── models/       #   - Modèle (FreelancerModel)
    │       │   └── repositories/ #   - Implémentation (FreelancerRepositoryImpl)
    │       │
    │       └── presentation/     # Couche Présentation
    │           ├── bloc/         #   - Bloc (FreelancerBloc...)
    │           ├── cubit/        #   - Cubit (FreelancerDetailCubit...)
    │           ├── pages/        #   - Écrans (FreelancerListPage...)
    │           └── widgets/      #   - Widgets (FreelancerListItem...)
    │
    ├── main.dart                 # Point d'entrée & MaterialApp
    ├── injection_container.dart  # Configuration GetIt (DI)
    └── firebase_options.dart     # Configuration Firebase (générée)