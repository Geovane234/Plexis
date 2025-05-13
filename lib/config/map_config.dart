import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapConfig {
  // URLs de base pour différents fournisseurs gratuits
  static const String osmBaseUrl = 'https://tile.openstreetmap.org';
  static const String cartoBaseUrl = 'https://cartodb-basemaps-a.global.ssl.fastly.net';
  static const String geoapifyBaseUrl = 'https://maps.geoapify.com/v1';

  // Obtenir la clé API depuis les variables d'environnement
  static String get apiKey => dotenv.env['GEOAPIFY_API_KEY'] ?? '';

  // Styles de carte disponibles avec leurs URLs
  static Map<String, Map<String, String>> get mapStyles => {
    'standard': {
      'url': '$osmBaseUrl/{z}/{x}/{y}.png?style=streets&buildings=true&color=default',
      'attribution': '© OpenStreetMap contributors',
    },
    'positron': {
      'url': '$geoapifyBaseUrl/tile/positron/{z}/{x}/{y}.png?apiKey=$apiKey&buildings=true&color=light&shadows=true',
      'attribution': '© CartoDB and OpenStreetMap contributors',
    },
    '3D': {
      // Style 3D amélioré avec des bâtiments et des effets
      'url': 'https://maps.geoapify.com/v1/tile/maptiler-3d/{z}/{x}/{y}.png?apiKey=$apiKey'
          '&style=dark'
          '&buildings3d=true'
          '&buildingColor=#4B5563'
          '&buildingHeight=1.5'
          '&shadows=true'
          '&pitch=60'
          '&bearing=30'
          '&effects=atmosphere,terrain'
          '&language=fr',
      'attribution': '© OpenStreetMap contributors, © Geoapify',
    },
  };

  // Configuration des limites de tuiles
  static const double maxZoom = 20; // Augmenté pour plus de détails en 3D
  static const double minZoom = 4;
  static const int tileBuffer = 3;

  // Paramètres de style supplémentaires
  static const Map<String, dynamic> styleParams = {
    'standard': {
      'buildingColor': '#808080',
      'waterColor': '#B3D1FF',
      'parkColor': '#B0D2A7',
      'roadColor': '#FFFFFF',
    },
    'positron': {
      'buildingColor': '#E0E0E0',
      'waterColor': '#DAE7F5',
      'parkColor': '#E6EFE3',
      'roadColor': '#FFFFFF',
    },
    '3D': {
      'buildingColor': '#4B5563',
      'waterColor': '#1A365D',
      'parkColor': '#2F4F2F',
      'roadColor': '#374151',
      'buildingHeight': 1.5,
      'shadowIntensity': 0.5,
      'atmosphereIntensity': 0.3,
    },
  };

  static String? getTileUrl(String style) {
    String? baseUrl = mapStyles[style]?['url'];
    if (baseUrl == null) return null;

    // Ajout des paramètres de style supplémentaires
    if (styleParams.containsKey(style)) {
      final params = styleParams[style]!;
      if (style == '3D') {
        return baseUrl
            .replaceAll('buildingColor=#4B5563', 'buildingColor=${params['buildingColor']}')
            .replaceAll('buildingHeight=1.5', 'buildingHeight=${params['buildingHeight']}')
            .replaceAll('shadows=true', 'shadows=true&shadowIntensity=${params['shadowIntensity']}')
            .replaceAll('effects=atmosphere', 'effects=atmosphere&atmosphereIntensity=${params['atmosphereIntensity']}');
      }
    }
    return baseUrl;
  }

  static String? getAttribution(String style) {
    return mapStyles[style]?['attribution'] ?? mapStyles['standard']!['attribution'];
  }
} 