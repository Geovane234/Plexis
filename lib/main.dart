import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'map_state.dart';
import 'config/map_config.dart';
import 'widgets/map_initialization_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/location_service.dart';

void main() async {
  // Chargement des variables d'environnement
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // Si le fichier .env n'est pas trouvé, on continue avec des valeurs par défaut
    debugPrint("Erreur lors du chargement du fichier .env: $e");
  }
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carte Interactive',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MapInitializationWidget(
        child: MapScreen(),
      ),
    );
  }
}

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte Interactive'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (style) {
              ref.read(mapStateProvider.notifier).changeMapStyle(style);
              if (style == '3D') {
                ref.read(mapStateProvider.notifier).updateZoom(mapState.zoom);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'standard', child: Text('Standard')),
              const PopupMenuItem(value: 'positron', child: Text('Positron')),
              const PopupMenuItem(value: '3D', child: Text('3D')),
            ],
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: mapState.center,
          initialZoom: mapState.zoom,
          onPositionChanged: (position, hasGesture) {
            if (hasGesture) {
              ref.read(mapStateProvider.notifier).updateCenter(position.center!);
              ref.read(mapStateProvider.notifier).updateZoom(position.zoom!);
            }
          },
          maxZoom: MapConfig.maxZoom,
          minZoom: MapConfig.minZoom,
          initialRotation: mapState.currentStyle == '3D' ? 30.0 : 0.0,
          // interactiveFlags: mapState.currentStyle == '3D'
          //   ? InteractiveFlag.all & ~InteractiveFlag.rotate
          //   : InteractiveFlag.all,
        ),
        children: [
          TileLayer(
            urlTemplate: MapConfig.getTileUrl(mapState.currentStyle),
            userAgentPackageName: 'com.example.app',
            keepBuffer: MapConfig.tileBuffer,
            maxZoom: MapConfig.maxZoom,
            minZoom: MapConfig.minZoom,
            tileProvider: NetworkTileProvider(
              headers: {
                'User-Agent': 'YourApp/1.0',
              },
            ),
            evictErrorTileStrategy: EvictErrorTileStrategy.dispose,
          ),
          if (mapState.currentRoute != null)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: mapState.currentRoute!.coordinates,
                  color: Colors.blue,
                  strokeWidth: 4,
                ),
              ],
            ),
          MarkerLayer(
            markers: mapState.markers.map((marker) => Marker(
              point: marker.position,
              width: 80,
              height: 80,
              child: IconButton(
                icon: const Icon(Icons.location_on, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(marker.title),
                      content: Text(marker.description ?? ''),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Fermer'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )).toList(),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              final location = await LocationService.getCurrentLocation();
              if (location != null) {
                ref.read(mapStateProvider.notifier).updateCenter(location);
              }
            },
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              // Votre fonction de recherche existante
            },
            child: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}
