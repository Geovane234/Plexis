import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latlong2/latlong.dart';

class NominatimService {
  static const String baseUrl = 'https://nominatim.openstreetmap.org';

  Future<List<Map<String, dynamic>>> searchPlace(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search?format=json&q=$query'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body);
      return results.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Échec de la recherche');
    }
  }

  LatLng parseLatLng(Map<String, dynamic> result) {
    return LatLng(
      double.parse(result['lat']),
      double.parse(result['lon']),
    );
  }
} 