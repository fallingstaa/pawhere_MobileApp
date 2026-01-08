import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pawhere/models/position_model.dart';
import 'package:pawhere/services/traccar_service.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  List<Position> _petPositions = [];
  bool _isLoading = true;
  final TraccarService _traccarService = TraccarService();

  final LatLng _defaultCenter = const LatLng(11.5621, 104.9160);

  @override
  void initState() {
    super.initState();
    _fetchPetLocations();
  }

  Future<void> _fetchPetLocations() async {
    setState(() => _isLoading = true);
    try {
      final positions = await _traccarService.fetchDevicePositions();
      if (!mounted) return;
      setState(() {
        _petPositions = positions;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch locations: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  List<Marker> _buildMarkers() {
    return _petPositions.map((pos) {
      final isFresh = DateTime.now().difference(pos.deviceTime).inHours < 1;
      final color = isFresh ? Colors.green.shade700 : Colors.red.shade700;
      return Marker(
        point: LatLng(pos.latitude, pos.longitude),
        width: 80,
        height: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on, size: 40, color: color),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Last: ${_formatAgo(pos.deviceTime)}',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  String _formatAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    final center = _petPositions.isNotEmpty
        ? LatLng(_petPositions.first.latitude, _petPositions.first.longitude)
        : _defaultCenter;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paw Tracker Map',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF4A905),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _fetchPetLocations,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFF4A905)))
          : FlutterMap(
              options: MapOptions(
                initialCenter: center,
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.pawhere.app',
                ),
                MarkerLayer(markers: _buildMarkers()),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchPetLocations,
        backgroundColor: const Color(0xFF134694),
        child: const Icon(Icons.gps_fixed, color: Colors.white),
      ),
    );
  }
}
