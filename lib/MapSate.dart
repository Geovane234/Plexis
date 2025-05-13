// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:latlong2/latlong.dart';
//
// // Supposons que les classes Place, Route et ApiService sont définies ailleurs.
//
// class MapState {
//   final List<Place> searchResults;
//   final Route? currentRoute;
//
//   MapState({
//     this.searchResults = const [],
//     this.currentRoute,
//   });
//
//   MapState copyWith({
//     List<Place>? searchResults,
//     Route? currentRoute,
//   }) {
//     return MapState(
//       searchResults: searchResults ?? this.searchResults,
//       currentRoute: currentRoute ?? this.currentRoute,
//     );
//   }
// }
//
// class MapNotifier extends StateNotifier<MapState> {
//   final ApiService _apiService;
//
//   MapNotifier(this._apiService) : super(MapState());
//
//   Future<void> searchPlaces(String query) async {
//     final results = await _apiService.searchPlaces(query);
//     state = state.copyWith(searchResults: results);
//   }
//
//   Future<void> calculateRoute(LatLng start, LatLng end) async {
//     final route = await _apiService.getRoute(start, end);
//     state = state.copyWith(currentRoute: route);
//   }
// }
//
// // Création du provider Riverpod pour le MapNotifier
// final mapProvider = StateNotifierProvider<MapNotifier, MapState>((ref) {
//   return MapNotifier(ApiService());
// });
