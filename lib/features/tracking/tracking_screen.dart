import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({
    Key? key,
    required this.appId,
    required this.userId,
    required this.petId,
  }) : super(key: key);

  static const routeName = '/tracking';

  final String appId;
  final String userId;
  final String petId;

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  BitmapDescriptor? _petIcon;
  LatLng? _lastLatLng;

  Stream<
      DocumentSnapshot<
          Map<String, dynamic>>> get _petStream => FirebaseFirestore.instance
      .doc(
          'artifacts/${widget.appId}/users/${widget.userId}/pets/${widget.petId}')
      .snapshots();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadMarkerIcon();
  }

  Future<void> _loadMarkerIcon() async {
    if (_petIcon != null) return;
    try {
      // Ensure you declare this file in pubspec.yaml under 'assets:'
      // assets/icons/paw_marker.png
      final icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(54, 54)),
        'assets/icons/paw_marker.png',
      );
      if (mounted) setState(() => _petIcon = icon);
    } catch (_) {
      // Fallback handled by using default marker if loading fails.
    }
  }

  Future<void> _animateTo(LatLng target, {double zoom = 16}) async {
    if (!_mapController.isCompleted) return;
    final controller = await _mapController.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: zoom),
      ),
    );
  }

  Set<Marker> _markersFor(LatLng pos, String? name) {
    return {
      Marker(
        markerId: MarkerId(widget.petId),
        position: pos,
        icon: _petIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(title: name ?? 'Pet'),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Live Tracking', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF4A905),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _petStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load device data.'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data();
          if (data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final double? lat = (data['latestLatitude'] as num?)?.toDouble();
          final double? lng = (data['latestLongitude'] as num?)?.toDouble();
          final String? name = data['name'] as String?;

          if (lat == null || lng == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final current = LatLng(lat, lng);

          // Smoothly follow position as it updates.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_lastLatLng == null ||
                _lastLatLng!.latitude != current.latitude ||
                _lastLatLng!.longitude != current.longitude) {
              _lastLatLng = current;
              _animateTo(current);
            }
          });

          return GoogleMap(
            initialCameraPosition: CameraPosition(target: current, zoom: 15),
            onMapCreated: (c) {
              if (!_mapController.isCompleted) {
                _mapController.complete(c);
              }
            },
            markers: _markersFor(current, name),
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            compassEnabled: true,
            mapToolbarEnabled: false,
          );
        },
      ),
    );
  }
}
