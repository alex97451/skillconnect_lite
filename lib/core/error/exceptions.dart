// Exceptions spécifiques à la couche Data (ou Core si très générique)

class ServerException implements Exception {
  final String message;
  ServerException({this.message = 'Erreur Serveur'});
}

class CacheException implements Exception {
   final String message;
   CacheException({this.message = 'Erreur de Cache'});
}

class NetworkException implements Exception {
   final String message;
   NetworkException({this.message = 'Erreur Réseau'});
}
