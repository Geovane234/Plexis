import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'services/location_service.dart';

class MapMarker {
  final LatLng position;
  final String title;
  final String? description;

  MapMarker({
    required this.position,
    required this.title,
    this.description,
  });
}

class Route {
  final List<LatLng> coordinates;
  final String name;

  Route({required this.coordinates, required this.name});
}

class MapState {
  final List<MapMarker> markers;
  final Route? currentRoute;
  final String currentStyle;
  final double zoom;
  final LatLng center;

  MapState({
    this.markers = const [],
    this.currentRoute,
    this.currentStyle = 'standard',
    this.zoom = 13,
    required this.center,
  });

  MapState copyWith({
    List<MapMarker>? markers,
    Route? currentRoute,
    String? currentStyle,
    double? zoom,
    LatLng? center,
  }) {
    return MapState(
      markers: markers ?? this.markers,
      currentRoute: currentRoute ?? this.currentRoute,
      currentStyle: currentStyle ?? this.currentStyle,
      zoom: zoom ?? this.zoom,
      center: center ?? this.center,
    );
  }
}

final mapStateProvider = StateNotifierProvider<MapStateNotifier, MapState>((ref) {
  return MapStateNotifier();
});

class MapStateNotifier extends StateNotifier<MapState> {
  MapStateNotifier() : super(MapState(center: LatLng(48.8566, 2.3522))) {
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    final currentLocation = await LocationService.getCurrentLocation();
    if (currentLocation != null) {
      state = state.copyWith(center: currentLocation);
    }
  }

  void addMarker(MapMarker marker) {
    state = state.copyWith(
      markers: [...state.markers, marker],
    );
  }

  void setRoute(Route route) {
    state = state.copyWith(currentRoute: route);
  }

  void changeMapStyle(String style) {
    state = state.copyWith(currentStyle: style);
  }

  void updateCenter(LatLng newCenter) {
    state = state.copyWith(center: newCenter);
  }

  void updateZoom(double newZoom) {
    state = state.copyWith(zoom: newZoom);
  }
} 